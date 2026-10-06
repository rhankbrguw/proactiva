import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../constants/tokens.dart';
import '../../../constants/typography.dart';
import '../../../models/user_model.dart';

class AcademicHeaderCard extends StatelessWidget {
  final UserModel? user;

  const AcademicHeaderCard({super.key, required this.user});

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
            children: [
              _buildAvatar(),
              const SizedBox(width: AppTokens.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.nama ?? 'Raihan Akbar Gunawan',
                      style: AppTypography.cardTitle.copyWith(fontWeight: FontWeight.w700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppTokens.space2),
                    Text(
                      '${user?.nim ?? '20220801055'} • Teknik Informatika',
                      style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: AppTokens.space2),
                    Text(
                      'Dosen PA: Dr. Budi Tjahjono, M.Kom.',
                      style: AppTypography.badge.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTokens.space12),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: AppTokens.space8),
          _buildAcademicMetricsRow(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppTokens.radiusSm),
      ),
      child: const Center(
        child: Text(
          'RG',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildAcademicMetricsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildMetricItem('IPK', '3.86', AppColors.green),
        _buildDivider(),
        _buildMetricItem('IPS Terakhir', '3.96', AppColors.blue),
        _buildDivider(),
        _buildMetricItem('SKS Lulus', '127 / 144', AppColors.textPrimary),
        _buildDivider(),
        _buildMetricItem('Semester', '7 (Aktif)', AppColors.amber),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 24, color: AppColors.border);
  }

  Widget _buildMetricItem(String label, String value, Color valueColor) {
    return Column(
      children: [
        Text(value, style: AppTypography.caption.copyWith(fontWeight: FontWeight.w700, color: valueColor)),
        const SizedBox(height: AppTokens.space2),
        Text(label, style: AppTypography.badge.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }
}
