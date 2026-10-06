import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/tokens.dart';
import '../../constants/typography.dart';
import '../../constants/strings.dart';
import '../../core/session.dart';
import '../../models/user_model.dart';
import '../auth/login_screen.dart';
import 'widgets/change_password_dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final u = await SessionManager.getUser();
    if (mounted) setState(() => _user = u);
  }

  void _handleLogout() async {
    await SessionManager.clearSession();
    if (mounted) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(AppStrings.profileTitle, style: AppTypography.screenTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTokens.space16),
        children: [
          _buildBioCard(),
          const SizedBox(height: AppTokens.space12),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildBioCard() {
    return Container(
      padding: const EdgeInsets.all(AppTokens.space16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTokens.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(AppTokens.radiusSm)),
            child: const Center(child: Text('RG', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))),
          ),
          const SizedBox(height: AppTokens.space10),
          Text(_user?.nama ?? 'Raihan Akbar Gunawan', style: AppTypography.cardTitle.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: AppTokens.space2),
          Text('NIM: ${_user?.nim ?? '20220801055'}', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppTokens.space12),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: AppTokens.space12),
          _buildBioRow('Fakultas', 'Ilmu Komputer'),
          _buildBioRow('Program Studi', 'Teknik Informatika (S1)'),
          _buildBioRow('Kampus', 'Reguler-1 Kebon Jeruk, Jakarta'),
          _buildBioRow('Dosen Pembimbing Akademik', 'Dr. Budi Tjahjono, S.Kom, M.Kom'),
          _buildBioRow('Status Mahasiswa', 'Aktif (Semester 7)'),
        ],
      ),
    );
  }

  Widget _buildBioRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTokens.space8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.badge.copyWith(color: AppColors.textSecondary)),
          Text(value, style: AppTypography.badge.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 42,
          child: OutlinedButton.icon(
            onPressed: () => showDialog(context: context, builder: (_) => const ChangePasswordDialog()),
            icon: const Icon(Icons.lock_reset_rounded, size: 16, color: AppColors.primary),
            label: Text(AppStrings.changePasswordTitle, style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600, color: AppColors.primary)),
            style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.border)),
          ),
        ),
        const SizedBox(height: AppTokens.space8),
        SizedBox(
          width: double.infinity,
          height: 42,
          child: ElevatedButton.icon(
            onPressed: _handleLogout,
            icon: const Icon(Icons.logout_rounded, size: 16, color: AppColors.red),
            label: Text(AppStrings.logoutBtn, style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600, color: AppColors.red)),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.redLight, elevation: 0),
          ),
        ),
      ],
    );
  }
}
