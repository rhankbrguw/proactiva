import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants/colors.dart';
import '../../constants/tokens.dart';
import '../../constants/typography.dart';
import '../../constants/strings.dart';
import '../../constants/endpoints.dart';
import '../../core/api_client.dart';
import '../../models/announcement_model.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  List<AnnouncementModel> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAnnouncements();
  }

  Future<void> _fetchAnnouncements() async {
    setState(() => _isLoading = true);
    try {
      final res = await apiClient.get(AppEndpoints.announcements) as List;
      if (mounted) {
        setState(() {
          _items = res.map((e) => AnnouncementModel.fromJson(e as Map<String, dynamic>)).toList();
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        bottom: const PreferredSize(preferredSize: Size.fromHeight(1), child: Divider(height: 1, color: AppColors.border)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primary, size: 16),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(AppStrings.announcementsTitle, style: AppTypography.pageTitle),
      ),
      body: _isLoading
          ? const Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)))
          : RefreshIndicator(
              color: AppColors.primary,
              onRefresh: _fetchAnnouncements,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                padding: const EdgeInsets.symmetric(horizontal: AppTokens.space16, vertical: AppTokens.space12),
                itemCount: _items.length,
                itemBuilder: (_, i) => _buildAnnouncementCard(_items[i]),
              ),
            ),
    );
  }

  Widget _buildAnnouncementCard(AnnouncementModel item) {
    final hasLlm = item.extractedAction != null || item.extractedDeadline != null;

    return Container(
      margin: const EdgeInsets.only(bottom: AppTokens.space8),
      padding: const EdgeInsets.all(AppTokens.space12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTokens.radiusMd),
        border: Border.all(color: AppColors.border),
        boxShadow: AppTokens.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(DateFormat('d MMM yyyy').format(item.tanggalTerbit), style: AppTypography.caption),
              const Spacer(),
              if (hasLlm)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.amberLight, borderRadius: BorderRadius.circular(AppTokens.radiusXs)),
                  child: Text('NLP Extracted', style: AppTypography.badge.copyWith(color: AppColors.amber)),
                ),
            ],
          ),
          const SizedBox(height: AppTokens.space6),
          Text(item.judul, style: AppTypography.cardTitle),
          const SizedBox(height: AppTokens.space4),
          Text(item.isiTeks, style: AppTypography.body),
          if (hasLlm) ...[
            const SizedBox(height: AppTokens.space8),
            Container(
              padding: const EdgeInsets.all(AppTokens.space8),
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt,
                borderRadius: BorderRadius.circular(AppTokens.radiusXs),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item.extractedAction != null)
                    Text('${AppStrings.extractedActionLabel} ${item.extractedAction}',
                        style: AppTypography.caption.copyWith(fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  if (item.extractedDeadline != null)
                    Padding(
                      padding: const EdgeInsets.only(top: AppTokens.space2),
                      child: Text(
                        '${AppStrings.extractedDeadlineLabel} ${DateFormat('d MMMM yyyy, HH:mm').format(item.extractedDeadline!)} WIB',
                        style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600, color: AppColors.red),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
