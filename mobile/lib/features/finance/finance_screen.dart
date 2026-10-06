import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/tokens.dart';
import '../../constants/typography.dart';
import '../../constants/strings.dart';
import '../../constants/endpoints.dart';
import '../../core/api_client.dart';
import '../../models/payment_model.dart';
import 'widgets/bill_summary_card.dart';
import 'widgets/bill_item_card.dart';

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({super.key});

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  List<PaymentModel> _payments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPayments();
  }

  Future<void> _fetchPayments() async {
    setState(() => _isLoading = true);
    try {
      final res = await apiClient.get(AppEndpoints.payments) as List;
      if (mounted) {
        setState(() {
          _payments = res.map((e) => PaymentModel.fromJson(e as Map<String, dynamic>)).toList();
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(AppStrings.financeTitle, style: AppTypography.screenTitle),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary))
          : RefreshIndicator(
              color: AppColors.primary,
              onRefresh: _fetchPayments,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                padding: const EdgeInsets.symmetric(horizontal: AppTokens.space16, vertical: AppTokens.space12),
                children: [
                  const BillSummaryCard(unpaidAmount: 5800000),
                  const SizedBox(height: AppTokens.space12),
                  Text('TAGIHAN SEMESTER INI', style: AppTypography.sectionHeader),
                  const SizedBox(height: AppTokens.space8),
                  if (_payments.isEmpty)
                    Center(child: Text('Semua kewajiban keuangan telah lunas.', style: AppTypography.caption.copyWith(color: AppColors.textMuted)))
                  else
                    ..._payments.map((p) => BillItemCard(payment: p)),
                  const SizedBox(height: AppTokens.space12),
                  _buildProactiveBksNotice(),
                ],
              ),
            ),
    );
  }

  Widget _buildProactiveBksNotice() {
    return Container(
      padding: const EdgeInsets.all(AppTokens.space12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTokens.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.primary),
          const SizedBox(width: AppTokens.space8),
          Expanded(
            child: Text(
              'Pengingat jatuh tempo tagihan dikirimkan secara otomatis pada H-7, H-3, dan H-0 oleh mesin notifikasi proaktif.',
              style: AppTypography.badge.copyWith(color: AppColors.textSecondary, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
