import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../constants/tokens.dart';
import '../../../constants/typography.dart';
import '../../../constants/strings.dart';
import '../../../models/schedule_model.dart';

class TodayClassCard extends StatelessWidget {
  final List<ScheduleModel> schedules;
  final VoidCallback? onOpenSchedule;

  const TodayClassCard({super.key, required this.schedules, this.onOpenSchedule});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTokens.space12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTokens.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('JADWAL KULIAH HARI INI', style: AppTypography.badge.copyWith(color: AppColors.textSecondary, letterSpacing: 0.5)),
              if (onOpenSchedule != null)
                GestureDetector(
                  onTap: onOpenSchedule,
                  child: Text('Semua Jadwal →', style: AppTypography.badge.copyWith(color: AppColors.blue, fontWeight: FontWeight.w600)),
                ),
            ],
          ),
          const SizedBox(height: AppTokens.space10),
          if (schedules.isEmpty)
            Text(AppStrings.emptySchedule, style: AppTypography.caption.copyWith(color: AppColors.textMuted))
          else
            ...schedules.take(2).map((s) => _buildScheduleItem(s)),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(ScheduleModel s) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTokens.space8),
      padding: const EdgeInsets.all(AppTokens.space10),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(AppTokens.radiusSm),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppTokens.space6, vertical: AppTokens.space4),
            decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(AppTokens.radiusSm)),
            child: Text('${s.jamMulai}\n${s.jamSelesai}', textAlign: TextAlign.center, style: AppTypography.badge.copyWith(color: Colors.white, fontSize: 9)),
          ),
          const SizedBox(width: AppTokens.space10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${s.kodeMatkul} - ${s.namaMatkul}',
                  style: AppTypography.caption.copyWith(fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppTokens.space2),
                Text(s.dosen, style: AppTypography.badge.copyWith(color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppTokens.space6, vertical: AppTokens.space2),
            decoration: BoxDecoration(color: AppColors.blueLight, borderRadius: BorderRadius.circular(AppTokens.radiusSm)),
            child: Text(s.ruang, style: AppTypography.badge.copyWith(color: AppColors.blue, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
