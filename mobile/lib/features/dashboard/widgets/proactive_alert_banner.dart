import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../constants/tokens.dart';
import '../../../constants/typography.dart';
import '../../../constants/strings.dart';

class ProactiveAlertBanner extends StatelessWidget {
  final bool hasAttendanceWarning;
  final String? nextClassInfo;
  final VoidCallback? onAttendanceTap;
  final VoidCallback? onNextClassTap;

  const ProactiveAlertBanner({
    super.key,
    required this.hasAttendanceWarning,
    this.nextClassInfo,
    this.onAttendanceTap,
    this.onNextClassTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (hasAttendanceWarning) ...[
          _buildWarningBanner(
            title: AppStrings.alertAttendanceWarning,
            actionText: 'Lihat Detail',
            onTap: onAttendanceTap,
          ),
          const SizedBox(height: AppTokens.space8),
        ],
        if (nextClassInfo != null)
          _buildInfoBanner(
            title: nextClassInfo!,
            actionText: 'Lihat Jadwal',
            onTap: onNextClassTap,
          ),
      ],
    );
  }

  Widget _buildWarningBanner({required String title, required String actionText, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTokens.radiusSm),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppTokens.space12, vertical: AppTokens.space8),
        decoration: BoxDecoration(
          color: AppColors.redLight,
          borderRadius: BorderRadius.circular(AppTokens.radiusSm),
          border: Border.all(color: AppColors.red.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppColors.red, size: 16),
            const SizedBox(width: AppTokens.space8),
            Expanded(
              child: Text(
                title,
                style: AppTypography.caption.copyWith(color: AppColors.red, fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(actionText, style: AppTypography.badge.copyWith(color: AppColors.red, fontWeight: FontWeight.w700, decoration: TextDecoration.underline)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBanner({required String title, required String actionText, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTokens.radiusSm),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppTokens.space12, vertical: AppTokens.space8),
        decoration: BoxDecoration(
          color: AppColors.blueLight,
          borderRadius: BorderRadius.circular(AppTokens.radiusSm),
          border: Border.all(color: AppColors.blue.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined, color: AppColors.blue, size: 15),
            const SizedBox(width: AppTokens.space8),
            Expanded(
              child: Text(
                title,
                style: AppTypography.caption.copyWith(color: AppColors.blue, fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(actionText, style: AppTypography.badge.copyWith(color: AppColors.blue, fontWeight: FontWeight.w700, decoration: TextDecoration.underline)),
          ],
        ),
      ),
    );
  }
}
