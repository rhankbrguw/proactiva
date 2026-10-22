import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../constants/tokens.dart';
import '../../../constants/typography.dart';
import '../../../models/attendance_model.dart';

class AttendanceCourseMeter extends StatelessWidget {
  final AttendanceSummaryModel item;

  const AttendanceCourseMeter({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isCritical = item.persentaseKehadiran < 75.0 || item.totalAbsen >= 2;
    final statusColor = isCritical ? AppColors.red : AppColors.green;
    final statusBg = isCritical ? AppColors.redLight : AppColors.greenLight;

    return Container(
      margin: const EdgeInsets.only(bottom: AppTokens.space10),
      padding: const EdgeInsets.all(AppTokens.space12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTokens.radiusMd),
        border: Border.all(color: isCritical ? AppColors.red.withValues(alpha: 0.4) : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '${item.kodeMatkul} - ${item.namaMatkul}',
                  style: AppTypography.caption.copyWith(fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppTokens.space6, vertical: AppTokens.space2),
                decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(AppTokens.radiusSm)),
                child: Text(
                  '${item.persentaseKehadiran.toStringAsFixed(0)}%',
                  style: AppTypography.badge.copyWith(color: statusColor, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTokens.space8),
          _buildProgressBar(item.persentaseKehadiran, statusColor),
          const SizedBox(height: AppTokens.space8),
          _buildSessionGrid(item.totalAbsen),
          if (isCritical) ...[
            const SizedBox(height: AppTokens.space8),
            _buildWarningBanner(item.totalAbsen),
          ],
        ],
      ),
    );
  }

  Widget _buildProgressBar(double percentage, Color color) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppTokens.radiusSm),
      child: LinearProgressIndicator(
        value: (percentage / 100.0).clamp(0.0, 1.0),
        minHeight: 6,
        backgroundColor: AppColors.surfaceAlt,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }

  Widget _buildSessionGrid(int totalAbsen) {
    return Wrap(
      spacing: AppTokens.space4,
      runSpacing: AppTokens.space4,
      children: List.generate(14, (index) {
        final sessionNum = index + 1;
        final isAbsen = sessionNum <= totalAbsen;
        final isPassed = sessionNum <= 4; // current week 4
        
        Color bg = AppColors.surfaceAlt;
        Color textC = AppColors.textMuted;

        if (isPassed) {
          bg = isAbsen ? AppColors.redLight : AppColors.greenLight;
          textC = isAbsen ? AppColors.red : AppColors.green;
        }

        return Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(AppTokens.radiusSm),
            border: Border.all(color: isPassed ? textC.withValues(alpha: 0.3) : AppColors.border),
          ),
          child: Center(
            child: Text(
              '$sessionNum',
              style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: textC),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildWarningBanner(int totalAbsen) {
    final sisaAlpha = (4 - totalAbsen).clamp(0, 4);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppTokens.space8, vertical: AppTokens.space4),
      decoration: BoxDecoration(
        color: AppColors.redLight,
        borderRadius: BorderRadius.circular(AppTokens.radiusSm),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: AppColors.red, size: 14),
          const SizedBox(width: AppTokens.space6),
          Expanded(
            child: Text(
              'Absen: $totalAbsen kali. Sisa jatah alpha: $sisaAlpha kali sebelum gugur syarat UAS.',
              style: AppTypography.badge.copyWith(color: AppColors.red, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
