import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/tokens.dart';
import '../../constants/typography.dart';
import '../../constants/strings.dart';
import '../../constants/endpoints.dart';
import '../../core/api_client.dart';
import '../../models/attendance_model.dart';
import 'widgets/attendance_course_meter.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  List<AttendanceSummaryModel> _attendance = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAttendance();
  }

  Future<void> _fetchAttendance() async {
    setState(() => _isLoading = true);
    try {
      final res = await apiClient.get(AppEndpoints.attendance) as List;
      if (mounted) {
        setState(() {
          _attendance = res.map((e) => AttendanceSummaryModel.fromJson(e as Map<String, dynamic>)).toList();
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
        title: const Text(AppStrings.attendanceTitle, style: AppTypography.screenTitle),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary))
          : RefreshIndicator(
              color: AppColors.primary,
              onRefresh: _fetchAttendance,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                padding: const EdgeInsets.symmetric(horizontal: AppTokens.space16, vertical: AppTokens.space12),
                children: [
                  _buildRegulationNotice(),
                  const SizedBox(height: AppTokens.space12),
                  Text('REKAPITULASI PRESENSI PER MATA KULIAH', style: AppTypography.sectionHeader),
                  const SizedBox(height: AppTokens.space8),
                  ..._attendance.map((a) => AttendanceCourseMeter(item: a)),
                ],
              ),
            ),
    );
  }

  Widget _buildRegulationNotice() {
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
              const Icon(Icons.verified_user_outlined, size: 16, color: AppColors.primary),
              const SizedBox(width: AppTokens.space8),
              Text('Pedoman Akademik Universitas Esa Unggul', style: AppTypography.caption.copyWith(fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: AppTokens.space4),
          Text(
            'Mahasiswa diwajibkan memiliki presensi minimum 75% dari total 14 sesi tatap muka (maksimal 4 kali ketidakhadiran) agar berhak mengikuti Ujian Akhir Semester (UAS).',
            style: AppTypography.badge.copyWith(color: AppColors.textSecondary, height: 1.4),
          ),
        ],
      ),
    );
  }
}
