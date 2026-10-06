import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants/colors.dart';
import '../../constants/tokens.dart';
import '../../constants/typography.dart';
import '../../constants/endpoints.dart';
import '../../core/api_client.dart';
import '../../models/assignment_model.dart';

class AssignmentsScreen extends StatefulWidget {
  const AssignmentsScreen({super.key});

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  List<AssignmentModel> _items = [];
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
          _items = res.map((e) => AssignmentModel.fromJson(e as Map<String, dynamic>)).toList();
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
        scrolledUnderElevation: 0,
        bottom: const PreferredSize(preferredSize: Size.fromHeight(1), child: Divider(height: 1, color: AppColors.border)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primary, size: 16),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Daftar Tugas & Kuis LMS', style: AppTypography.pageTitle),
      ),
      body: _isLoading
          ? const Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)))
          : RefreshIndicator(
              color: AppColors.primary,
              onRefresh: _fetchAssignments,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                padding: const EdgeInsets.symmetric(horizontal: AppTokens.space16, vertical: AppTokens.space12),
                itemCount: _items.length,
                itemBuilder: (_, i) => _buildAssignmentCard(_items[i]),
              ),
            ),
    );
  }

  Widget _buildAssignmentCard(AssignmentModel item) {
    final diffDays = item.deadline.difference(DateTime.now()).inDays;
    final isUrgent = diffDays <= 2;

    return Container(
      margin: const EdgeInsets.only(bottom: AppTokens.space8),
      padding: const EdgeInsets.all(AppTokens.space12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTokens.radiusMd),
        border: Border.all(color: isUrgent ? AppColors.red.withValues(alpha: 0.3) : AppColors.border),
        boxShadow: AppTokens.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: item.jenis == 'KUIS' ? AppColors.amberLight : AppColors.blueLight,
                  borderRadius: BorderRadius.circular(AppTokens.radiusXs),
                ),
                child: Text(
                  item.jenis,
                  style: AppTypography.badge.copyWith(color: item.jenis == 'KUIS' ? AppColors.amber : AppColors.blue),
                ),
              ),
              const SizedBox(width: AppTokens.space6),
              Expanded(
                child: Text(item.namaMatkul, style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              ),
            ],
          ),
          const SizedBox(height: AppTokens.space6),
          Text(item.judul, style: AppTypography.cardTitle),
          if (item.deskripsi != null) ...[
            const SizedBox(height: AppTokens.space2),
            Text(item.deskripsi!, style: AppTypography.body),
          ],
          const SizedBox(height: AppTokens.space8),
          Row(
            children: [
              Icon(Icons.access_time_rounded, size: 13, color: isUrgent ? AppColors.red : AppColors.textMuted),
              const SizedBox(width: AppTokens.space4),
              Text(
                'Tenggat: ${DateFormat('EEE, d MMM yyyy, HH:mm', 'id_ID').format(item.deadline)} WIB',
                style: AppTypography.caption.copyWith(
                  fontWeight: isUrgent ? FontWeight.w700 : FontWeight.w500,
                  color: isUrgent ? AppColors.red : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
