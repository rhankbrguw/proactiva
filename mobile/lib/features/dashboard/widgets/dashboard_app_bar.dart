import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../constants/strings.dart';
import '../../../constants/typography.dart';
import '../../../core/session.dart';
import '../../academic/announcements_screen.dart';
import '../../academic/assignments_screen.dart';
import '../../auth/login_screen.dart';
import '../../notifications/notification_feed_screen.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DashboardAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(48.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: 16,
      title: const Row(
        children: [
          Icon(Icons.hub_outlined, color: AppColors.primary, size: 20),
          SizedBox(width: 8),
          Text(AppStrings.appName, style: AppTypography.pageTitle),
        ],
      ),
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: AppColors.border),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.assignment_outlined, color: AppColors.textSecondary, size: 20),
          tooltip: 'Tugas',
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AssignmentsScreen())),
        ),
        IconButton(
          icon: const Icon(Icons.campaign_outlined, color: AppColors.textSecondary, size: 20),
          tooltip: 'Pengumuman',
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AnnouncementsScreen())),
        ),
        IconButton(
          icon: const Icon(Icons.notifications_none_rounded, color: AppColors.textSecondary, size: 20),
          tooltip: 'Notifikasi',
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationFeedScreen())),
        ),
        IconButton(
          icon: const Icon(Icons.logout_rounded, color: AppColors.textMuted, size: 18),
          tooltip: 'Keluar',
          onPressed: () async {
            await SessionManager.clearSession();
            if (context.mounted) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
            }
          },
        ),
      ],
    );
  }
}
