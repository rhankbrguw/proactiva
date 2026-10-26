import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../constants/tokens.dart';
import '../../../constants/typography.dart';
import '../../../constants/strings.dart';
import '../../../models/schedule_model.dart';

class ScheduleItemCard extends StatelessWidget {
  final ScheduleModel schedule;

  const ScheduleItemCard({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTokens.space8),
      padding: const EdgeInsets.all(AppTokens.space12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTokens.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTimeBadge(),
          const SizedBox(width: AppTokens.space12),
          Expanded(child: _buildCourseDetails()),
          _buildRoomBadge(),
        ],
      ),
    );
  }

  Widget _buildTimeBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppTokens.space8, vertical: AppTokens.space6),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(AppTokens.radiusSm),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(schedule.jamMulai, style: AppTypography.caption.copyWith(fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          Text('s/d', style: AppTypography.badge.copyWith(color: AppColors.textMuted, fontSize: 8)),
          Text(schedule.jamSelesai, style: AppTypography.caption.copyWith(fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildCourseDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(schedule.kodeMatkul, style: AppTypography.badge.copyWith(fontWeight: FontWeight.w700, color: AppColors.blue)),
            const SizedBox(width: AppTokens.space6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppTokens.space4, vertical: 1),
              decoration: BoxDecoration(color: AppColors.greenLight, borderRadius: BorderRadius.circular(AppTokens.radiusSm)),
              child: Text(AppStrings.faceToFace, style: AppTypography.badge.copyWith(color: AppColors.green, fontSize: 8, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
        const SizedBox(height: AppTokens.space2),
        Text(schedule.namaMatkul, style: AppTypography.caption.copyWith(fontWeight: FontWeight.w700), maxLines: 2, overflow: TextOverflow.ellipsis),
        const SizedBox(height: AppTokens.space4),
        Text(schedule.dosen, style: AppTypography.badge.copyWith(color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
      ],
    );
  }

  Widget _buildRoomBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppTokens.space8, vertical: AppTokens.space4),
      decoration: BoxDecoration(
        color: AppColors.blueLight,
        borderRadius: BorderRadius.circular(AppTokens.radiusSm),
        border: Border.all(color: AppColors.blue.withValues(alpha: 0.2)),
      ),
      child: Text('${AppStrings.roomLabel} ${schedule.ruang}', style: AppTypography.badge.copyWith(color: AppColors.blue, fontWeight: FontWeight.w700)),
    );
  }
}
