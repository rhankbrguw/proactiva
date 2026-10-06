import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../constants/tokens.dart';
import '../../../constants/typography.dart';
import '../../../models/attendance_model.dart';

class AttendanceMeterCard extends StatelessWidget {
  final List<AttendanceSummaryModel> attendanceList;

  const AttendanceMeterCard({super.key, required this.attendanceList});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: attendanceList.map((item) => _buildMeterItem(item)).toList(),
    );
  }

  Widget _buildMeterItem(AttendanceSummaryModel item) {
    final isCritical = item.warningLevel == 'CRITICAL';
    final isWarning = item.warningLevel == 'WARNING';
    final color = isCritical ? AppColors.red : (isWarning ? AppColors.amber : AppColors.green);
    final bgLight = isCritical ? AppColors.redLight : (isWarning ? AppColors.amberLight : AppColors.greenLight);
    final statusText = isCritical ? 'Kritis (Batas UAS)' : (isWarning ? 'Peringatan' : 'Aman');

    return Container(
      margin: const EdgeInsets.only(bottom: AppTokens.space6),
      padding: const EdgeInsets.all(AppTokens.space10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTokens.radiusMd),
        border: Border.all(color: AppColors.border),
        boxShadow: AppTokens.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(item.namaMatkul, style: AppTypography.cardTitle, maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
              const SizedBox(width: AppTokens.space8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: bgLight, borderRadius: BorderRadius.circular(AppTokens.radiusXs)),
                child: Text(statusText, style: AppTypography.badge.copyWith(color: color)),
              ),
            ],
          ),
          const SizedBox(height: AppTokens.space6),
          LinearProgressIndicator(
            value: item.totalAbsen / item.maxAllowedAbsen,
            backgroundColor: AppColors.surfaceAlt,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            borderRadius: BorderRadius.circular(AppTokens.radiusFull),
            minHeight: 4,
          ),
          const SizedBox(height: AppTokens.space4),
          Row(
            children: [
              Text('Ketidakhadiran: ${item.totalAbsen} dari max ${item.maxAllowedAbsen}x', style: AppTypography.caption),
              const Spacer(),
              Text('Ambang: 75%', style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}
