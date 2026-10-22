import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/tokens.dart';
import '../../constants/typography.dart';
import '../../constants/strings.dart';
import '../../constants/endpoints.dart';
import '../../core/api_client.dart';
import '../../core/session.dart';
import '../../models/user_model.dart';
import '../shell/main_navigation_shell.dart';
import 'widgets/login_form_fields.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _nimController = TextEditingController(text: '20220801055');
  final _passController = TextEditingController(text: 'password123');
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _handleLogin({String? nim, String? password}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final res = await apiClient.post(AppEndpoints.login, body: {
        'nim': nim ?? _nimController.text.trim(),
        'password': password ?? _passController.text.trim(),
      });

      final token = res['token'] as String;
      final user = UserModel.fromJson(res['user'] as Map<String, dynamic>);
      await SessionManager.saveSession(token, user);

      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainNavigationShell()));
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: AppTokens.space20, vertical: AppTokens.space16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 380),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.hub_outlined, size: 36, color: AppColors.primary),
                  const SizedBox(height: AppTokens.space12),
                  const Text(AppStrings.appName, textAlign: TextAlign.center, style: AppTypography.pageTitle),
                  const SizedBox(height: AppTokens.space2),
                  Text(AppStrings.caseStudyName, textAlign: TextAlign.center, style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: AppTokens.space24),
                  LoginFormFields(
                    nimController: _nimController,
                    passController: _passController,
                    errorMessage: _errorMessage,
                    nimLabel: AppStrings.nimLabel,
                    nimHint: AppStrings.nimHint,
                    passLabel: AppStrings.passwordLabel,
                    passHint: AppStrings.passwordHint,
                  ),
                  const SizedBox(height: AppTokens.space20),
                  _buildSubmitButton(),
                  const SizedBox(height: AppTokens.space24),
                  _buildHelpDeskFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      height: 44,
      child: ElevatedButton(
        onPressed: _isLoading ? null : () => _handleLogin(),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTokens.radiusSm)),
        ),
        child: _isLoading
            ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
            : Text(AppStrings.loginButton, style: AppTypography.cardTitle.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildHelpDeskFooter() {
    return Column(
      children: [
        const Divider(color: AppColors.border, height: 1),
        const SizedBox(height: AppTokens.space12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.help_outline_rounded, size: 14, color: AppColors.textSecondary),
            const SizedBox(width: AppTokens.space6),
            Flexible(
              child: Text(
                'Kendala akun? Hubungi Biro Administrasi Pembelajaran (BAP)',
                textAlign: TextAlign.center,
                style: AppTypography.badge.copyWith(color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
