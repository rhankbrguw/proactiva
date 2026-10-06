import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../constants/tokens.dart';
import '../../../constants/typography.dart';
import '../../../constants/strings.dart';
import '../../../models/assignment_model.dart';

class AssignmentCard extends StatelessWidget {
  final AssignmentModel assignment;
  final int index;

  const AssignmentCard({super.key, required this.assignment, required this.index});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final diffHours = assignment.deadline.difference(now).inHours;
    final isUrgent = diffHours <= 48 && diffHours >= 0;

    return Container(
      margin: const EdgeInsets.only(bottom: AppTokens.space10),
      padding: const EdgeInsets.all(AppTokens.space12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTokens.radiusMd),
        border: Border.all(color: isUrgent ? AppColors.amber.withValues(alpha: 0.5) : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTypeBadge(),
              _buildDeadlineBadge(diffHours, isUrgent),
            ],
          ),
          const SizedBox(height: AppTokens.space8),
          Text(assignment.judul, style: AppTypography.caption.copyWith(fontWeight: FontWeight.w700), maxLines: 2),
          const SizedBox(height: AppTokens.space4),
          Text(assignment.namaMatkul, style: AppTypography.badge.copyWith(color: AppColors.blue, fontWeight: FontWeight.w600)),
          if (assignment.deskripsi != null) ...[
            const SizedBox(height: AppTokens.space6),
            Text(assignment.deskripsi!, style: AppTypography.badge.copyWith(color: AppColors.textSecondary), maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
          const SizedBox(height: AppTokens.space10),
          _buildSubmissionFooter(isUrgent),
        ],
      ),
    );
  }

  Widget _buildTypeBadge() {
    final isKuis = assignment.jenis.toUpperCase() == 'KUIS';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppTokens.space6, vertical: AppTokens.space2),
      decoration: BoxDecoration(
        color: isKuis ? AppColors.blueLight : AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(AppTokens.radiusSm),
      ),
      child: Text(
        assignment.jenis.toUpperCase(),
        style: AppTypography.badge.copyWith(color: isKuis ? AppColors.blue : AppColors.textSecondary, fontWeight: FontWeight.w700, fontSize: 9),
      ),
    );
  }

  Widget _buildDeadlineBadge(int diffHours, bool isUrgent) {
    String text;
    if (diffHours < 0) {
      text = 'Lewat Tenggat';
    } else if (diffHours <= 24) {
      text = '$diffHours jam lagi';
    } else {
      text = '${(diffHours / 24).ceil()} hari lagi';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppTokens.space6, vertical: AppTokens.space2),
      decoration: BoxDecoration(
        color: isUrgent ? AppColors.amberLight : AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(AppTokens.radiusSm),
      ),
      child: Row(
        children: [
          Icon(Icons.schedule_rounded, size: 11, color: isUrgent ? AppColors.amber : AppColors.textSecondary),
          const SizedBox(width: AppTokens.space4),
          Text(text, style: AppTypography.badge.copyWith(color: isUrgent ? AppColors.amber : AppColors.textSecondary, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildSubmissionFooter(bool isUrgent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppTokens.space8, vertical: AppTokens.space4),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(AppTokens.radiusSm),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.radio_button_unchecked, size: 12, color: AppColors.textMuted),
              const SizedBox(width: AppTokens.space6),
              Text(
                isUrgent ? AppStrings.dueSoonStatus : AppStrings.submittedStatus,
                style: AppTypography.badge.copyWith(color: isUrgent ? AppColors.amber : AppColors.green, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Text('Sesi Perkuliahan', style: AppTypography.badge.copyWith(color: AppColors.textMuted)),
        ],
      ),
    );
  }
}
