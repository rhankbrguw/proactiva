import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../constants/tokens.dart';
import '../../../constants/typography.dart';
import '../../../constants/strings.dart';
import '../../../models/payment_model.dart';

class BillItemCard extends StatelessWidget {
  final PaymentModel payment;

  const BillItemCard({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    final isUnpaid = payment.status.toUpperCase() == 'BELUM_LUNAS';
    final statusColor = isUnpaid ? AppColors.red : AppColors.green;
    final statusBg = isUnpaid ? AppColors.redLight : AppColors.greenLight;

    return Container(
      margin: const EdgeInsets.only(bottom: AppTokens.space10),
      padding: const EdgeInsets.all(AppTokens.space12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTokens.radiusMd),
        border: Border.all(color: isUnpaid ? AppColors.red.withValues(alpha: 0.3) : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rp ${payment.nominal.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                style: AppTypography.cardTitle.copyWith(fontWeight: FontWeight.w700),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppTokens.space6, vertical: AppTokens.space2),
                decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(AppTokens.radiusSm)),
                child: Text(
                  isUnpaid ? 'BELUM LUNAS' : 'LUNAS',
                  style: AppTypography.badge.copyWith(color: statusColor, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTokens.space6),
          Text(payment.jenis, style: AppTypography.caption.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
          const SizedBox(height: AppTokens.space8),
          Row(
            children: [
              const Icon(Icons.event_outlined, size: 13, color: AppColors.textSecondary),
              const SizedBox(width: AppTokens.space4),
              Text(
                'Jatuh Tempo: ${payment.jatuhTempo.day}/${payment.jatuhTempo.month}/${payment.jatuhTempo.year}',
                style: AppTypography.badge.copyWith(color: AppColors.textSecondary),
              ),
              const Spacer(),
              if (isUnpaid)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppTokens.space6, vertical: AppTokens.space2),
                  decoration: BoxDecoration(color: AppColors.amberLight, borderRadius: BorderRadius.circular(AppTokens.radiusSm)),
                  child: Text(AppStrings.milestoneH3, style: AppTypography.badge.copyWith(color: AppColors.amber, fontWeight: FontWeight.w700, fontSize: 8)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
