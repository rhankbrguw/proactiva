import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../constants/colors.dart';
import '../../../constants/tokens.dart';
import '../../../constants/typography.dart';
import '../../../models/notification_model.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel item;

  const NotificationCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isLLM = item.source == 'LLM';
    final isUrgent = item.prioritas == 'URGENT';

    return Container(
      margin: const EdgeInsets.only(bottom: AppTokens.space8),
      padding: const EdgeInsets.all(AppTokens.space12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTokens.radiusMd),
        border: Border.all(color: isUrgent ? AppColors.red.withValues(alpha: 0.3) : AppColors.border),
        boxShadow: AppTokens.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isLLM ? AppColors.amberLight : AppColors.surfaceAlt,
                  borderRadius: BorderRadius.circular(AppTokens.radiusXs),
                ),
                child: Text(
                  isLLM ? 'AI Prioritized' : 'Rule Engine',
                  style: AppTypography.badge.copyWith(color: isLLM ? AppColors.amber : AppColors.textSecondary),
                ),
              ),
              const Spacer(),
              Text(DateFormat('d MMM, HH:mm').format(item.createdAt), style: AppTypography.caption),
            ],
          ),
          const SizedBox(height: AppTokens.space6),
          Text(item.judul, style: AppTypography.cardTitle),
          const SizedBox(height: AppTokens.space4),
          Text(item.pesan, style: AppTypography.body.copyWith(fontSize: 11.5)),
        ],
      ),
    );
  }
}
