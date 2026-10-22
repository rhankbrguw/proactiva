import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/tokens.dart';
import '../../constants/typography.dart';
import '../../constants/endpoints.dart';
import '../../core/api_client.dart';
import '../../core/session.dart';
import '../../models/user_model.dart';
import '../../models/schedule_model.dart';
import '../../models/attendance_model.dart';
import '../../models/notification_model.dart';
import 'widgets/academic_header_card.dart';
import 'widgets/proactive_alert_banner.dart';
import 'widgets/quick_access_grid.dart';
import 'widgets/today_class_card.dart';
import 'widgets/urgent_action_card.dart';
import '../academic/announcements_screen.dart';
import '../notifications/notification_feed_screen.dart';
import '../profile/profile_screen.dart';
import '../simulation/simulation_sheet.dart';

class DashboardScreen extends StatefulWidget {
  final Function(int tabIndex)? onNavigateTab;

  const DashboardScreen({super.key, this.onNavigateTab});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  UserModel? _user;
  List<ScheduleModel> _schedules = [];
  List<AttendanceSummaryModel> _attendance = [];
  List<NotificationModel> _urgentNotifs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);
    final user = await SessionManager.getUser();

    try {
      final schData = await apiClient.get(AppEndpoints.schedules) as List;
      final attData = await apiClient.get(AppEndpoints.attendance) as List;
      final notifData = await apiClient.get(AppEndpoints.notifications, queryParams: {'prioritas': 'URGENT'}) as List;

      if (mounted) {
        setState(() {
          _user = user;
          _schedules = schData.map((e) => ScheduleModel.fromJson(e as Map<String, dynamic>)).toList();
          _attendance = attData.map((e) => AttendanceSummaryModel.fromJson(e as Map<String, dynamic>)).toList();
          _urgentNotifs = notifData.map((e) => NotificationModel.fromJson(e as Map<String, dynamic>)).toList();
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasAttendanceRisk = _attendance.any((a) => a.persentaseKehadiran < 75.0 || a.totalAbsen >= 2);
    final nextClass = _schedules.isNotEmpty ? 'Kuliah berikutnya: 2 hari lagi | ${_schedules.first.kodeMatkul} (RE112)' : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary))
          : RefreshIndicator(
              color: AppColors.primary,
              onRefresh: _loadDashboardData,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                padding: const EdgeInsets.symmetric(horizontal: AppTokens.space16, vertical: AppTokens.space12),
                children: [
                  GestureDetector(
                    onLongPress: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => SimulationSheet(onDataChanged: _loadDashboardData),
                    ),
                    child: AcademicHeaderCard(user: _user),
                  ),
                  const SizedBox(height: AppTokens.space10),
                  ProactiveAlertBanner(
                    hasAttendanceWarning: hasAttendanceRisk,
                    nextClassInfo: nextClass,
                    onAttendanceTap: () => widget.onNavigateTab?.call(2),
                    onNextClassTap: () => widget.onNavigateTab?.call(1),
                  ),
                  const SizedBox(height: AppTokens.space12),
                  if (_urgentNotifs.isNotEmpty) ...[
                    Text('REKOMENDASI PRIORITAS MENDESAK', style: AppTypography.sectionHeader),
                    const SizedBox(height: AppTokens.space6),
                    ..._urgentNotifs.map((n) => Padding(
                          padding: const EdgeInsets.only(bottom: AppTokens.space6),
                          child: UrgentActionCard(
                            notification: n,
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationFeedScreen())),
                          ),
                        )),
                    const SizedBox(height: AppTokens.space12),
                  ],
                  QuickAccessGrid(
                    onNavigateTab: (idx) => widget.onNavigateTab?.call(idx),
                    onOpenAnnouncements: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AnnouncementsScreen())),
                    onOpenProfile: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
                  ),
                  const SizedBox(height: AppTokens.space12),
                  TodayClassCard(
                    schedules: _schedules,
                    onOpenSchedule: () => widget.onNavigateTab?.call(1),
                  ),
                  const SizedBox(height: AppTokens.space24),
                ],
              ),
            ),
    );
  }
}
