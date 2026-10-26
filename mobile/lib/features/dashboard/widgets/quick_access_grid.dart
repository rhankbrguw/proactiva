import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../constants/tokens.dart';
import '../../../constants/typography.dart';

class QuickAccessGrid extends StatelessWidget {
  final Function(int tabIndex) onNavigateTab;
  final VoidCallback onOpenAnnouncements;
  final VoidCallback onOpenProfile;

  const QuickAccessGrid({
    super.key,
    required this.onNavigateTab,
    required this.onOpenAnnouncements,
    required this.onOpenProfile,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _QuickItem(title: 'Jadwal Kuliah', icon: Icons.calendar_month_outlined, color: AppColors.blue, onTap: () => onNavigateTab(1)),
      _QuickItem(title: 'Presensi', icon: Icons.how_to_reg_outlined, color: AppColors.amber, onTap: () => onNavigateTab(2)),
      _QuickItem(title: 'Tugas LMS', icon: Icons.assignment_outlined, color: AppColors.green, onTap: () => onNavigateTab(3)),
      _QuickItem(title: 'Tagihan UKT', icon: Icons.receipt_long_outlined, color: AppColors.red, onTap: () => onNavigateTab(4)),
      _QuickItem(title: 'Pengumuman', icon: Icons.campaign_outlined, color: AppColors.primary, onTap: onOpenAnnouncements),
      _QuickItem(title: 'Biodata', icon: Icons.person_outline_rounded, color: AppColors.textSecondary, onTap: onOpenProfile),
    ];

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
          Text('AKSES CEPAT MODUL', style: AppTypography.badge.copyWith(color: AppColors.textSecondary, letterSpacing: 0.5)),
          const SizedBox(height: AppTokens.space12),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppTokens.space10,
            crossAxisSpacing: AppTokens.space10,
            childAspectRatio: 1.25,
            children: items.map((item) => _buildItemTile(item)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildItemTile(_QuickItem item) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(AppTokens.radiusSm),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppTokens.space8, horizontal: AppTokens.space4),
        decoration: BoxDecoration(
          color: AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(AppTokens.radiusSm),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, size: 20, color: item.color),
            const SizedBox(height: AppTokens.space4),
            Text(
              item.title,
              textAlign: TextAlign.center,
              style: AppTypography.badge.copyWith(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickItem {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  _QuickItem({required this.title, required this.icon, required this.color, required this.onTap});
}
