import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../constants/colors.dart';
import '../../../constants/tokens.dart';
import '../../../constants/typography.dart';
import '../../../models/payment_model.dart';

class TuitionStatusCard extends StatelessWidget {
  final List<PaymentModel> payments;

  const TuitionStatusCard({super.key, required this.payments});

  @override
  Widget build(BuildContext context) {
    if (payments.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppTokens.space12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppTokens.radiusMd),
          border: Border.all(color: AppColors.border),
        ),
        child: const Center(child: Text('Tidak ada tagihan aktif.', style: AppTypography.caption)),
      );
    }

    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Column(
      children: payments.map((p) {
        final isLunas = p.status == 'LUNAS';
        final diffDays = p.jatuhTempo.difference(DateTime.now()).inDays;

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
                  color: isLunas ? AppColors.greenLight : AppColors.amberLight,
                  borderRadius: BorderRadius.circular(AppTokens.radiusXs),
                ),
                child: Icon(Icons.receipt_outlined, color: isLunas ? AppColors.green : AppColors.amber, size: 16),
              ),
              const SizedBox(width: AppTokens.space10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.jenis, style: AppTypography.cardTitle, maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: AppTokens.space2),
                    Text(
                      isLunas ? 'Lunas' : 'Jatuh tempo: $diffDays hari lagi (${DateFormat('d MMM yyyy').format(p.jatuhTempo)})',
                      style: AppTypography.caption.copyWith(
                        color: isLunas ? AppColors.green : (diffDays <= 3 ? AppColors.red : AppColors.textSecondary),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Text(currency.format(p.nominal), style: AppTypography.cardTitle.copyWith(fontWeight: FontWeight.w700)),
            ],
          ),
        );
      }).toList(),
    );
  }
}
