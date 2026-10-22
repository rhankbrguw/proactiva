import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../constants/tokens.dart';
import '../../../constants/typography.dart';
import '../../../constants/strings.dart';
import '../../../models/user_model.dart';

class DashboardHeader extends StatelessWidget {
  final UserModel? user;

  const DashboardHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTokens.space12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTokens.radiusMd),
        border: Border.all(color: AppColors.border),
        boxShadow: AppTokens.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppTokens.radiusSm),
            ),
            child: const Icon(Icons.person_outline_rounded, color: Colors.white, size: 18),
          ),
          const SizedBox(width: AppTokens.space10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${AppStrings.greetingPrefix}${user?.nama ?? "Mahasiswa"}',
                  style: AppTypography.cardTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppTokens.space2),
                Text(
                  'NIM: ${user?.nim ?? "-"} • Teknik Informatika',
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
