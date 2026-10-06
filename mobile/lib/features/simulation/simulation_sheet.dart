import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/tokens.dart';
import '../../constants/strings.dart';
import '../../constants/endpoints.dart';
import '../../core/api_client.dart';

class SimulationSheet extends StatefulWidget {
  final VoidCallback onDataChanged;

  const SimulationSheet({super.key, required this.onDataChanged});

  @override
  State<SimulationSheet> createState() => _SimulationSheetState();
}

class _SimulationSheetState extends State<SimulationSheet> {
  bool _isLoading = false;
  String? _statusMessage;

  Future<void> _trigger(String endpoint, String successMsg) async {
    setState(() {
      _isLoading = true;
      _statusMessage = null;
    });

    try {
      await apiClient.post(endpoint);
      setState(() => _statusMessage = successMsg);
      widget.onDataChanged();
    } catch (e) {
      setState(() => _statusMessage = 'Gagal: ${e.toString().replaceAll("Exception: ", "")}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTokens.space24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTokens.radiusLg)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.science_rounded, color: AppColors.accent, size: 24),
              const SizedBox(width: AppTokens.space8),
              const Expanded(
                child: Text(
                  AppStrings.simulationDrawerTitle,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded, size: 20),
              ),
            ],
          ),
          const SizedBox(height: AppTokens.space12),
          if (_statusMessage != null) _buildStatusBanner(),
          _buildActionButton(
            label: AppStrings.triggerCollisionBtn,
            color: AppColors.accent,
            onPressed: () => _trigger(AppEndpoints.simCollision, 'Simulasi 3 tugas bertabrakan berhasil dipicu!'),
          ),
          const SizedBox(height: AppTokens.space8),
          _buildActionButton(
            label: AppStrings.triggerAttendanceBtn,
            color: AppColors.danger,
            onPressed: () => _trigger(AppEndpoints.simAttendanceRisk, 'Simulasi absen ke-3 (kritis) berhasil dipicu!'),
          ),
          const SizedBox(height: AppTokens.space8),
          _buildActionButton(
            label: AppStrings.triggerPaymentBtn,
            color: AppColors.info,
            onPressed: () => _trigger(AppEndpoints.simUrgentPayment, 'Simulasi tagihan jatuh tempo berhasil dipicu!'),
          ),
          const SizedBox(height: AppTokens.space8),
          _buildActionButton(
            label: AppStrings.triggerCycleBtn,
            color: AppColors.primary,
            onPressed: () => _trigger(AppEndpoints.simRunCycle, 'Siklus evaluasi proaktif global selesai!'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTokens.space12),
      padding: const EdgeInsets.all(AppTokens.space12),
      decoration: BoxDecoration(
        color: AppColors.accentLight,
        borderRadius: BorderRadius.circular(AppTokens.radiusSm),
      ),
      child: Text(_statusMessage!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildActionButton({required String label, required Color color, required VoidCallback onPressed}) {
    return OutlinedButton(
      onPressed: _isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color),
        padding: const EdgeInsets.symmetric(vertical: AppTokens.space12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTokens.radiusMd)),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w700)),
    );
  }
}
