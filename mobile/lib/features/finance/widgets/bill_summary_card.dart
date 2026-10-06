import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../constants/tokens.dart';
import '../../../constants/typography.dart';
import '../../../constants/strings.dart';

class BillSummaryCard extends StatelessWidget {
  final int unpaidAmount;

  const BillSummaryCard({super.key, required this.unpaidAmount});

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
          Text(AppStrings.financeTitle.toUpperCase(), style: AppTypography.badge.copyWith(color: AppColors.textSecondary, letterSpacing: 0.5)),
          const SizedBox(height: AppTokens.space10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetricColumn(AppStrings.totalBilled, 'Rp 86.950.000', AppColors.textPrimary),
              _buildDivider(),
              _buildMetricColumn(AppStrings.totalPaid, 'Rp 81.150.000', AppColors.green),
              _buildDivider(),
              _buildMetricColumn(AppStrings.totalUnpaid, 'Rp 5.800.000', AppColors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 28, color: AppColors.border);
  }

  Widget _buildMetricColumn(String label, String amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.badge.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: AppTokens.space2),
        Text(amount, style: AppTypography.caption.copyWith(fontWeight: FontWeight.w700, color: color)),
      ],
    );
  }
}
