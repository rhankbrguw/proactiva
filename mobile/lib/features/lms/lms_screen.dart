import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/tokens.dart';
import '../../constants/typography.dart';
import '../../constants/strings.dart';
import '../../constants/endpoints.dart';
import '../../core/api_client.dart';
import '../../models/assignment_model.dart';
import 'widgets/assignment_card.dart';
import 'widgets/llm_priority_banner.dart';

class LmsScreen extends StatefulWidget {
  const LmsScreen({super.key});

  @override
  State<LmsScreen> createState() => _LmsScreenState();
}

class _LmsScreenState extends State<LmsScreen> {
  List<AssignmentModel> _assignments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAssignments();
  }

  Future<void> _fetchAssignments() async {
    setState(() => _isLoading = true);
    try {
      final res = await apiClient.get(AppEndpoints.assignments) as List;
      if (mounted) {
        setState(() {
          _assignments = res.map((e) => AssignmentModel.fromJson(e as Map<String, dynamic>)).toList();
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showLlmRationale() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppTokens.radiusMd))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppTokens.space16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.auto_awesome, color: AppColors.amber, size: 18),
                const SizedBox(width: AppTokens.space8),
                Text('Rasionalisasi Prioritas LLM', style: AppTypography.cardTitle.copyWith(fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: AppTokens.space10),
            Text(
              'Terdeteksi 3 tugas bertabrakan dalam rentang 3 hari (CIE515, CIE722, CIE723). LLM menyarankan mengerjakan "Tugas Latihan 1: Agile vs RUP" terlebih dahulu karena bobot 3 SKS dan batas waktu paling dekat, disusul Kuis Sesi 1 AI.',
              style: AppTypography.caption.copyWith(color: AppColors.textSecondary, height: 1.4),
            ),
            const SizedBox(height: AppTokens.space16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, elevation: 0),
                child: const Text('Mengerti', style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasCollision = _assignments.length >= 3;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(AppStrings.lmsTitle, style: AppTypography.screenTitle),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary))
          : RefreshIndicator(
              color: AppColors.primary,
              onRefresh: _fetchAssignments,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                padding: const EdgeInsets.symmetric(horizontal: AppTokens.space16, vertical: AppTokens.space12),
                children: [
                  if (hasCollision) ...[
                    LlmPriorityBanner(onTapDetail: _showLlmRationale),
                    const SizedBox(height: AppTokens.space12),
                  ],
                  Text('DAFTAR TUGAS & KUIS AKTIF', style: AppTypography.sectionHeader),
                  const SizedBox(height: AppTokens.space8),
                  if (_assignments.isEmpty)
                    Center(child: Text('Tidak ada tugas aktif.', style: AppTypography.caption.copyWith(color: AppColors.textMuted)))
                  else
                    ..._assignments.asMap().entries.map((e) => AssignmentCard(assignment: e.value, index: e.key)),
                ],
              ),
            ),
    );
  }
}
