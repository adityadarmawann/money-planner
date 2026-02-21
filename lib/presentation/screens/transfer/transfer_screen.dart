import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/wallet_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/wallet_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../providers/transaction_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/validators.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/repositories/wallet_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../widgets/common/sp_button.dart';
import '../../widgets/common/sp_text_field.dart';
import '../../widgets/common/sp_snackbar.dart';

enum TransferType { user, bank, qris }

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.transferMoney),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Pengguna'),
            Tab(text: 'Bank'),
            Tab(text: 'QRIS'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _UserTransferTab(),
          _BankTransferTab(),
          _QrisTab(),
        ],
      ),
    );
  }
}

class _UserTransferTab extends StatefulWidget {
  const _UserTransferTab();

  @override
  State<_UserTransferTab> createState() => _UserTransferTabState();
}

class _UserTransferTabState extends State<_UserTransferTab> {
  final _usernameController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  UserModel? _recipient;
  bool _searching = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _searchUser() async {
    final username = _usernameController.text.trim();
    if (username.isEmpty) return;

    setState(() => _searching = true);

    final userRepo = UserRepository(
      client: Supabase.instance.client,
    );

    final user = await userRepo.getUserByUsername(username);
    setState(() {
      _recipient = user;
      _searching = false;
    });

    if (user == null && mounted) {
      showSpSnackbar(context, 'Pengguna tidak ditemukan', isError: true);
    }
  }

  Future<void> _transfer() async {
    if (_recipient == null) {
      showSpSnackbar(context, 'Cari penerima terlebih dahulu', isError: true);
      return;
    }

    final amount = CurrencyFormatter.parse(_amountController.text);
    if (amount <= 0) {
      showSpSnackbar(context, 'Masukkan jumlah transfer', isError: true);
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final walletProvider = context.read<WalletProvider>();
    final senderId = authProvider.currentUser?.id;
    final senderWalletId = walletProvider.wallet?.id;

    if (senderId == null || senderWalletId == null) return;
    if (senderId == _recipient!.id) {
      showSpSnackbar(context, 'Tidak bisa transfer ke diri sendiri',
          isError: true);
      return;
    }

    if (amount > walletProvider.balance) {
      showSpSnackbar(context, AppStrings.insufficientBalance, isError: true);
      return;
    }

    // Get receiver wallet
    final walletRepo = WalletRepository(client: Supabase.instance.client);
    final receiverWallet = await walletRepo.getWallet(_recipient!.id);
    if (receiverWallet == null) {
      if (mounted) {
        showSpSnackbar(context, 'Wallet penerima tidak ditemukan',
            isError: true);
      }
      return;
    }

    // Navigate to confirm screen
    if (!mounted) return;
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.transferConfirm,
      arguments: {
        'type': TransferType.user,
        'recipient': _recipient,
        'amount': amount,
        'note': _noteController.text,
        'senderId': senderId,
        'senderWalletId': senderWalletId,
        'receiverId': _recipient!.id,
        'receiverWalletId': receiverWallet.id,
      },
    );

    if (result == true && mounted) {
      await walletProvider.loadWallet(senderId);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Username Penerima',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    prefixText: '@',
                    hintText: 'username_penerima',
                    filled: true,
                    fillColor: AppColors.backgroundSecondary,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _searching ? null : _searchUser,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(0, 52),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: _searching
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.search),
              ),
            ],
          ),
          if (_recipient != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.successLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.primaryLightest,
                    child: Text(
                      _recipient!.fullName[0].toUpperCase(),
                      style: const TextStyle(color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_recipient!.fullName,
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text('@${_recipient!.username}',
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.check_circle, color: AppColors.success),
                ],
              ),
            ),
          ],
          const SizedBox(height: 20),
          const Text('Jumlah Transfer',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              prefixText: 'Rp ',
              hintText: '0',
              filled: true,
              fillColor: AppColors.backgroundSecondary,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SpTextField(
            label: '${AppStrings.note} (${AppStrings.optional})',
            hint: 'Contoh: Bayar makan siang',
            controller: _noteController,
            maxLines: 2,
          ),
          const SizedBox(height: 32),
          SpButton(
            text: 'Lanjutkan Transfer',
            onPressed: _transfer,
            isLoading: context.watch<TransactionProvider>().isLoading,
          ),
        ],
      ),
    );
  }
}

class _BankTransferTab extends StatefulWidget {
  const _BankTransferTab();

  @override
  State<_BankTransferTab> createState() => _BankTransferTabState();
}

class _BankTransferTabState extends State<_BankTransferTab> {
  String? _selectedBank;
  final _accountController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  final List<Map<String, String>> _banks = [
    {'name': 'BCA', 'icon': '🏦'},
    {'name': 'BNI', 'icon': '🏛️'},
    {'name': 'BRI', 'icon': '🏧'},
    {'name': 'Mandiri', 'icon': '💳'},
    {'name': 'CIMB Niaga', 'icon': '🏦'},
    {'name': 'Danamon', 'icon': '🏦'},
    {'name': 'BTN', 'icon': '🏠'},
    {'name': 'BSI', 'icon': '🕌'},
  ];

  @override
  void dispose() {
    _accountController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _transfer() async {
    if (_selectedBank == null) {
      showSpSnackbar(context, 'Pilih bank tujuan', isError: true);
      return;
    }
    if (_accountController.text.isEmpty) {
      showSpSnackbar(context, 'Masukkan nomor rekening', isError: true);
      return;
    }
    final amount = CurrencyFormatter.parse(_amountController.text);
    if (amount <= 0) {
      showSpSnackbar(context, 'Masukkan jumlah transfer', isError: true);
      return;
    }

    const fee = 6500.0;
    final authProvider = context.read<AuthProvider>();
    final walletProvider = context.read<WalletProvider>();
    final senderId = authProvider.currentUser?.id;
    final senderWalletId = walletProvider.wallet?.id;

    if (senderId == null || senderWalletId == null) return;

    if (amount + fee > walletProvider.balance) {
      showSpSnackbar(context, AppStrings.insufficientBalance, isError: true);
      return;
    }

    final result = await Navigator.pushNamed(
      context,
      AppRoutes.transferConfirm,
      arguments: {
        'type': TransferType.bank,
        'bankName': _selectedBank,
        'accountNumber': _accountController.text,
        'amount': amount,
        'fee': fee,
        'note': _noteController.text,
        'senderId': senderId,
        'senderWalletId': senderWalletId,
      },
    );

    if (result == true && mounted) {
      await walletProvider.loadWallet(senderId);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Pilih Bank',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.2,
            ),
            itemCount: _banks.length,
            itemBuilder: (context, index) {
              final bank = _banks[index];
              final isSelected = _selectedBank == bank['name'];
              return GestureDetector(
                onTap: () => setState(() => _selectedBank = bank['name']),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryLightest
                        : AppColors.backgroundSecondary,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(bank['icon']!, style: const TextStyle(fontSize: 20)),
                      const SizedBox(height: 4),
                      Text(
                        bank['name']!,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          SpTextField(
            label: 'Nomor Rekening',
            hint: 'Masukkan nomor rekening',
            controller: _accountController,
            keyboardType: TextInputType.number,
            prefix:
                const Icon(Icons.credit_card, color: AppColors.textHint),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Jumlah Transfer',
              prefixText: 'Rp ',
              hintText: '0',
              filled: true,
              fillColor: AppColors.backgroundSecondary,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
              helperText: 'Biaya admin: Rp 6.500',
            ),
          ),
          const SizedBox(height: 16),
          SpTextField(
            label: '${AppStrings.note} (${AppStrings.optional})',
            hint: 'Catatan transfer',
            controller: _noteController,
            maxLines: 2,
          ),
          const SizedBox(height: 32),
          SpButton(
            text: 'Lanjutkan Transfer',
            onPressed: _transfer,
            isLoading: context.watch<TransactionProvider>().isLoading,
          ),
        ],
      ),
    );
  }
}

class _QrisTab extends StatefulWidget {
  const _QrisTab();

  @override
  State<_QrisTab> createState() => _QrisTabState();
}

class _QrisTabState extends State<_QrisTab> {
  final _merchantController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _merchantController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pay() async {
    final merchant = _merchantController.text.trim();
    final amount = CurrencyFormatter.parse(_amountController.text);

    if (merchant.isEmpty) {
      showSpSnackbar(context, 'Masukkan nama merchant', isError: true);
      return;
    }
    if (amount <= 0) {
      showSpSnackbar(context, 'Masukkan jumlah pembayaran', isError: true);
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final walletProvider = context.read<WalletProvider>();
    final txProvider = context.read<TransactionProvider>();
    final userId = authProvider.currentUser?.id;
    final walletId = walletProvider.wallet?.id;

    if (userId == null || walletId == null) return;
    if (amount > walletProvider.balance) {
      showSpSnackbar(context, AppStrings.insufficientBalance, isError: true);
      return;
    }

    final success = await txProvider.qrisPayment(
      userId: userId,
      walletId: walletId,
      amount: amount,
      merchantName: merchant,
    );

    if (!mounted) return;

    if (success) {
      await walletProvider.loadWallet(userId);
      Navigator.pushNamed(
        context,
        AppRoutes.transferSuccess,
        arguments: {
          'type': 'qris',
          'merchant': merchant,
          'amount': amount,
          'refCode': txProvider.lastTransaction?.refCode ?? '',
        },
      );
    } else {
      showSpSnackbar(
        context,
        txProvider.errorMessage ?? 'Pembayaran gagal',
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<TransactionProvider>().isLoading;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              color: AppColors.backgroundSecondary,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.qr_code_2, size: 100, color: AppColors.primary),
                SizedBox(height: 8),
                Text(
                  'Simulasi QR Code',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SpTextField(
            label: 'Nama Merchant',
            hint: 'Contoh: Kantin Kampus',
            controller: _merchantController,
            prefix: const Icon(Icons.store_outlined, color: AppColors.textHint),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Jumlah Pembayaran',
              prefixText: 'Rp ',
              hintText: '0',
              filled: true,
              fillColor: AppColors.backgroundSecondary,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: 32),
          SpButton(
            text: 'Bayar Sekarang',
            onPressed: _pay,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }
}
