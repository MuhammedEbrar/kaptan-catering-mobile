import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

enum AccountStatus {
  active,
  pending,
  inactive,
}

class StatusBadge extends StatelessWidget {
  final AccountStatus status;

  const StatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        border: Border.all(
          color: _getBorderColor(),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getIcon(),
            size: 18,
            color: _getColor(),
          ),
          const SizedBox(width: 8),
          Text(
            _getText(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: _getColor(),
            ),
          ),
        ],
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (status) {
      case AccountStatus.active:
        return const Color(0xFF28A745).withOpacity(0.1);
      case AccountStatus.pending:
        return const Color(0xFFFFC107).withOpacity(0.1);
      case AccountStatus.inactive:
        return const Color(0xFFDC3545).withOpacity(0.1);
    }
  }

  Color _getBorderColor() {
    switch (status) {
      case AccountStatus.active:
        return const Color(0xFF28A745);
      case AccountStatus.pending:
        return const Color(0xFFFFC107);
      case AccountStatus.inactive:
        return const Color(0xFFDC3545);
    }
  }

  Color _getColor() {
    switch (status) {
      case AccountStatus.active:
        return const Color(0xFF28A745);
      case AccountStatus.pending:
        return const Color(0xFFFFC107);
      case AccountStatus.inactive:
        return const Color(0xFFDC3545);
    }
  }

  IconData _getIcon() {
    switch (status) {
      case AccountStatus.active:
        return Icons.check_circle;
      case AccountStatus.pending:
        return Icons.pending;
      case AccountStatus.inactive:
        return Icons.block;
    }
  }

  String _getText() {
    switch (status) {
      case AccountStatus.active:
        return 'Aktif Hesap';
      case AccountStatus.pending:
        return 'Onay Bekliyor';
      case AccountStatus.inactive:
        return 'Hesap Askıda';
    }
  }
}

// Müşteri Tipi Badge Widget
class CustomerTypeBadge extends StatelessWidget {
  final String emoji;
  final String displayName;

  const CustomerTypeBadge({
    super.key,
    required this.emoji,
    required this.displayName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[300]!,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(width: 10),
          Text(
            displayName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}