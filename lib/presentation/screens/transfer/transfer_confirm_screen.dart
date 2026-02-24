import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/wallet_provider.dart';
import '../../../providers/transaction_provider.dart';
import '../../../data/models/user_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../widgets/common/sp_button.dart';
import '../../widgets/common/sp_snackbar.dart';
import 'transfer_screen.dart';

class TransferConfirmScreen extends StatelessWidget {
  const TransferConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final type = args['type'] as TransferType;
    final amount = args['amount'] as double;
    final fee = (args['fee'] as double?) ?? 0;
    final note = args['note'] as String? ?? '';

    final isLoading = context.watch<TransactionProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Konfirmasi Transfer'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Transfer icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLightest,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send_rounded,
                          size: 36, color: AppColors.primary),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      type == TransferType.user
                          ? 'Transfer ke Pengguna'
                          : type == TransferType.bank
                              ? 'Transfer ke Bank'
                              : 'Pembayaran QRIS',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Details card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundSecondary,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          if (type == TransferType.user) ...[
                            _DetailRow(
                              label: 'Penerima',
                              value:
                                  '${(args['recipient'] as UserModel).fullName}\n@${(args['recipient'] as UserModel).username}',
                            ),
                          ] else if (type == TransferType.bank) ...[
                            _DetailRow(
                                label: 'Bank', value: args['bankName'] as String),
                            _DetailRow(
                                label: 'No. Rekening',
                                value: args['accountNumber'] as String),
                          ],
                          _DetailRow(
                            label: 'Jumlah',
                            value: CurrencyFormatter.format(amount),
                            valueStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          if (fee > 0)
                            _DetailRow(
                              label: 'Biaya Admin',
                              value: CurrencyFormatter.format(fee),
                            ),
                          if (fee > 0) const Divider(height: 24),
                          if (fee > 0)
                            _DetailRow(
                              label: 'Total',
                              value: CurrencyFormatter.format(amount + fee),
                              valueStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          if (note.isNotEmpty) ...[
                            const Divider(height: 24),
                            _DetailRow(label: 'Catatan', value: note),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SpButton(
              text: 'Konfirmasi & Transfer',
              onPressed: () => _processTransfer(context, args, type),
              isLoading: isLoading,
            ),
            const SizedBox(height: 8),
            SpButton(
              text: 'Batal',
              onPressed: () => Navigator.pop(context),
              isOutlined: true,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _processTransfer(
    BuildContext context,
    Map<String, dynamic> args,
    TransferType type,
  ) async {
    final txProvider = context.read<TransactionProvider>();
    final walletProvider = context.read<WalletProvider>();
    final authProvider = context.read<AuthProvider>();
    final amount = args['amount'] as double;
    final fee = (args['fee'] as double?) ?? 0;
    bool success = false;

    if (type == TransferType.user) {
      success = await txProvider.transfer(
        senderId: args['senderId'] as String,
        senderWalletId: args['senderWalletId'] as String,
        receiverId: args['receiverId'] as String,
        receiverWalletId: args['receiverWalletId'] as String,
        amount: amount,
        note: args['note'] as String?,
      );
    } else if (type == TransferType.bank) {
      success = await txProvider.bankTransfer(
        userId: args['senderId'] as String,
        walletId: args['senderWalletId'] as String,
        amount: amount,
        fee: fee,
        bankName: args['bankName'] as String,
        accountNumber: args['accountNumber'] as String,
        note: args['note'] as String?,
      );
    }

    if (!context.mounted) return;

    if (success) {
      final userId = authProvider.currentUser?.id;
      if (userId != null) {
        await walletProvider.loadWallet(userId);
      }
      Navigator.pushReplacementNamed(
        // ignore: use_build_context_synchronously
        context,
        AppRoutes.transferSuccess,
        arguments: {
          'type': type == TransferType.user ? 'user' : 'bank',
          'amount': amount,
          'refCode': txProvider.lastTransaction?.refCode ?? '',
          if (type == TransferType.user)
            'recipient':
                (args['recipient'] as UserModel).fullName,
          if (type == TransferType.bank) 'bankName': args['bankName'],
        },
      );
    } else {
      showSpSnackbar(
        context,
        txProvider.errorMessage ?? 'Transfer gagal',
        isError: true,
      );
    }
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? valueStyle;

  const _DetailRow({
    required this.label,
    required this.value,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 14)),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: valueStyle ??
                  const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
