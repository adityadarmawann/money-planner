import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class QuickActionGrid extends StatelessWidget {
  final VoidCallback onTopUp;
  final VoidCallback onTransfer;
  final VoidCallback onPaylater;
  final VoidCallback onScan;

  const QuickActionGrid({
    super.key,
    required this.onTopUp,
    required this.onTransfer,
    required this.onPaylater,
    required this.onScan,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _ActionItem(
          icon: Icons.add_circle_outline,
          label: 'Top Up',
          color: AppColors.success,
          onTap: onTopUp,
        ),
        _ActionItem(
          icon: Icons.send,
          label: 'Transfer',
          color: AppColors.primary,
          onTap: onTransfer,
        ),
        _ActionItem(
          icon: Icons.credit_card,
          label: 'Paylater',
          color: AppColors.warning,
          onTap: onPaylater,
        ),
        _ActionItem(
          icon: Icons.qr_code_scanner,
          label: 'Scan QR',
          color: AppColors.info,
          onTap: onScan,
        ),
      ],
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
