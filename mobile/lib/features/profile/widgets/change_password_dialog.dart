import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../constants/tokens.dart';
import '../../../constants/typography.dart';
import '../../../constants/strings.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _oldPass = TextEditingController();
  final _newPass = TextEditingController();
  final _confirmPass = TextEditingController();
  bool _isSuccess = false;

  void _handleSave() {
    if (_newPass.text.isNotEmpty && _newPass.text == _confirmPass.text) {
      setState(() => _isSuccess = true);
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTokens.radiusMd)),
      child: Padding(
        padding: const EdgeInsets.all(AppTokens.space16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.lock_outline_rounded, size: 18, color: AppColors.primary),
                const SizedBox(width: AppTokens.space8),
                Text(AppStrings.changePasswordTitle, style: AppTypography.cardTitle.copyWith(fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: AppTokens.space12),
            if (_isSuccess)
              Container(
                padding: const EdgeInsets.all(AppTokens.space8),
                decoration: BoxDecoration(color: AppColors.greenLight, borderRadius: BorderRadius.circular(AppTokens.radiusSm)),
                child: const Center(child: Text('Password berhasil diperbarui!', style: TextStyle(color: AppColors.green, fontSize: 12, fontWeight: FontWeight.bold))),
              )
            else ...[
              _buildInput(label: AppStrings.oldPasswordLabel, controller: _oldPass),
              const SizedBox(height: AppTokens.space8),
              _buildInput(label: AppStrings.newPasswordLabel, controller: _newPass),
              const SizedBox(height: AppTokens.space8),
              _buildInput(label: AppStrings.confirmPasswordLabel, controller: _confirmPass),
              const SizedBox(height: AppTokens.space16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Batal', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                  ),
                  const SizedBox(width: AppTokens.space8),
                  ElevatedButton(
                    onPressed: _handleSave,
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, elevation: 0),
                    child: Text(AppStrings.savePasswordBtn, style: AppTypography.badge.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInput({required String label, required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.badge.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
        const SizedBox(height: AppTokens.space4),
        SizedBox(
          height: 38,
          child: TextField(
            controller: controller,
            obscureText: true,
            style: AppTypography.caption,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: AppTokens.space10),
              filled: true,
              fillColor: AppColors.surfaceAlt,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppTokens.radiusSm), borderSide: const BorderSide(color: AppColors.border)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppTokens.radiusSm), borderSide: const BorderSide(color: AppColors.border)),
            ),
          ),
        ),
      ],
    );
  }
}
