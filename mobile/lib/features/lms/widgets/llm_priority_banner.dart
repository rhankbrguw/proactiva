import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../constants/tokens.dart';
import '../../../constants/typography.dart';
import '../../../constants/strings.dart';

class LlmPriorityBanner extends StatelessWidget {
  final VoidCallback onTapDetail;

  const LlmPriorityBanner({super.key, required this.onTapDetail});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapDetail,
      borderRadius: BorderRadius.circular(AppTokens.radiusMd),
      child: Container(
        padding: const EdgeInsets.all(AppTokens.space12),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppTokens.radiusMd),
          border: Border.all(color: AppColors.amber.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppTokens.space8),
              decoration: BoxDecoration(
                color: AppColors.amber.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppTokens.radiusSm),
              ),
              child: const Icon(Icons.auto_awesome, color: AppColors.amber, size: 20),
            ),
            const SizedBox(width: AppTokens.space12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.collidingDeadlinesBadge,
                    style: AppTypography.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: AppTokens.space2),
                  Text(
                    'LLM menganalisis bobot SKS & estimasi waktu pengerjaan.',
                    style: AppTypography.badge.copyWith(color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 18),
          ],
        ),
      ),
    );
  }
}
