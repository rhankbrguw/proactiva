import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/tokens.dart';
import '../../constants/typography.dart';
import '../../constants/strings.dart';
import '../dashboard/dashboard_screen.dart';
import '../schedule/schedule_screen.dart';
import '../attendance/attendance_screen.dart';
import '../lms/lms_screen.dart';
import '../finance/finance_screen.dart';
import '../notifications/notification_feed_screen.dart';
import '../profile/profile_screen.dart';

class MainNavigationShell extends StatefulWidget {
  final int initialIndex;

  const MainNavigationShell({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _navigateToTab(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      DashboardScreen(onNavigateTab: _navigateToTab),
      const ScheduleScreen(),
      const AttendanceScreen(),
      const LmsScreen(),
      const FinanceScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildTopBar(),
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  PreferredSizeWidget _buildTopBar() {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      title: Row(
        children: [
          const Icon(Icons.hub_outlined, color: AppColors.primary, size: 20),
          const SizedBox(width: AppTokens.space8),
          const Text(AppStrings.appName, style: AppTypography.screenTitle),
          const SizedBox(width: AppTokens.space6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppTokens.space6, vertical: 2),
            decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(AppTokens.radiusSm)),
            child: Text('SIAKAD', style: AppTypography.badge.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w700, fontSize: 8)),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none_rounded, color: AppColors.textPrimary, size: 22),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationFeedScreen())),
        ),
        IconButton(
          icon: const Icon(Icons.account_circle_outlined, color: AppColors.textPrimary, size: 22),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _navigateToTab,
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        selectedLabelStyle: AppTypography.badge.copyWith(fontWeight: FontWeight.w700, fontSize: 10),
        unselectedLabelStyle: AppTypography.badge.copyWith(fontSize: 10),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined, size: 20), activeIcon: Icon(Icons.dashboard, size: 20), label: AppStrings.tabHome),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined, size: 20), activeIcon: Icon(Icons.calendar_month, size: 20), label: AppStrings.tabSchedule),
          BottomNavigationBarItem(icon: Icon(Icons.how_to_reg_outlined, size: 20), activeIcon: Icon(Icons.how_to_reg, size: 20), label: AppStrings.tabAttendance),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined, size: 20), activeIcon: Icon(Icons.assignment, size: 20), label: AppStrings.tabLms),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined, size: 20), activeIcon: Icon(Icons.receipt_long, size: 20), label: AppStrings.tabFinance),
        ],
      ),
    );
  }
}
