import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../constants/tokens.dart';
import '../../../constants/typography.dart';
import '../../../models/schedule_model.dart';

class TodayScheduleCard extends StatelessWidget {
  final List<ScheduleModel> schedules;

  const TodayScheduleCard({super.key, required this.schedules});

  @override
  Widget build(BuildContext context) {
    if (schedules.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppTokens.space12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppTokens.radiusMd),
          border: Border.all(color: AppColors.border),
        ),
        child: const Center(
          child: Text('Tidak ada perkuliahan hari ini.', style: AppTypography.caption),
        ),
      );
    }

    return Column(
      children: schedules.map((sch) => _buildScheduleItem(sch)).toList(),
    );
  }

  Widget _buildScheduleItem(ScheduleModel sch) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTokens.space6),
      padding: const EdgeInsets.symmetric(horizontal: AppTokens.space12, vertical: AppTokens.space10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTokens.radiusMd),
        border: Border.all(color: AppColors.border),
        boxShadow: AppTokens.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppTokens.space6),
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(AppTokens.radiusXs),
            ),
            child: const Icon(Icons.schedule_rounded, color: AppColors.primary, size: 16),
          ),
          const SizedBox(width: AppTokens.space10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(sch.namaMatkul, style: AppTypography.cardTitle),
                const SizedBox(height: AppTokens.space2),
                Text(
                  '${sch.jamMulai} - ${sch.jamSelesai} • ${sch.ruang} • ${sch.dosen}',
                  style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
