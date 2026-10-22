import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../constants/tokens.dart';
import '../../../constants/typography.dart';
import '../../../models/notification_model.dart';

class UrgentActionCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const UrgentActionCard({super.key, required this.notification, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isLLM = notification.source == 'LLM';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTokens.radiusMd),
      child: Container(
        padding: const EdgeInsets.all(AppTokens.space12),
        decoration: BoxDecoration(
          color: isLLM ? AppColors.amberLight.withValues(alpha: 0.3) : AppColors.redLight.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(AppTokens.radiusMd),
          border: Border.all(
            color: isLLM ? AppColors.amber.withValues(alpha: 0.4) : AppColors.red.withValues(alpha: 0.4),
            width: 1.0,
          ),
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
                    color: isLLM ? AppColors.amberLight : AppColors.redLight,
                    borderRadius: BorderRadius.circular(AppTokens.radiusXs),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(isLLM ? Icons.bolt_rounded : Icons.warning_amber_rounded, size: 12, color: isLLM ? AppColors.amber : AppColors.red),
                      const SizedBox(width: 3),
                      Text(
                        isLLM ? 'AI Prioritized' : 'Rule Alert',
                        style: AppTypography.badge.copyWith(color: isLLM ? AppColors.amber : AppColors.red),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios_rounded, size: 11, color: AppColors.textMuted),
              ],
            ),
            const SizedBox(height: AppTokens.space8),
            Text(notification.judul, style: AppTypography.cardTitle),
            const SizedBox(height: AppTokens.space2),
            Text(
              notification.pesan,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.body.copyWith(fontSize: 11.5, height: 1.35),
            ),
          ],
        ),
      ),
    );
  }
}
