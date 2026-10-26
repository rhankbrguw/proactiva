import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../constants/tokens.dart';
import '../../../constants/typography.dart';

class LoginFormFields extends StatelessWidget {
  final TextEditingController nimController;
  final TextEditingController passController;
  final String? errorMessage;
  final String nimLabel;
  final String nimHint;
  final String passLabel;
  final String passHint;

  const LoginFormFields({
    super.key,
    required this.nimController,
    required this.passController,
    this.errorMessage,
    required this.nimLabel,
    required this.nimHint,
    required this.passLabel,
    required this.passHint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (errorMessage != null) _buildErrorBanner(),
        _buildTextField(label: nimLabel, hint: nimHint, controller: nimController, icon: Icons.badge_outlined),
        const SizedBox(height: AppTokens.space12),
        _buildTextField(label: passLabel, hint: passHint, controller: passController, isPassword: true, icon: Icons.lock_outline_rounded),
      ],
    );
  }

  Widget _buildErrorBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTokens.space12),
      padding: const EdgeInsets.symmetric(horizontal: AppTokens.space12, vertical: AppTokens.space8),
      decoration: BoxDecoration(
        color: AppColors.redLight,
        borderRadius: BorderRadius.circular(AppTokens.radiusSm),
        border: Border.all(color: AppColors.red.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: AppColors.red, size: 16),
          const SizedBox(width: AppTokens.space8),
          Expanded(child: Text(errorMessage!, style: const TextStyle(color: AppColors.red, fontSize: 12, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool isPassword = false,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        const SizedBox(height: AppTokens.space4),
        SizedBox(
          height: 42,
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            style: AppTypography.body.copyWith(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTypography.caption,
              prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 18),
              contentPadding: const EdgeInsets.symmetric(horizontal: AppTokens.space12),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppTokens.radiusSm), borderSide: const BorderSide(color: AppColors.border)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppTokens.radiusSm), borderSide: const BorderSide(color: AppColors.border)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppTokens.radiusSm), borderSide: const BorderSide(color: AppColors.primary, width: 1.2)),
            ),
          ),
        ),
      ],
    );
  }
}
