import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/tokens.dart';
import '../../constants/typography.dart';
import '../../constants/strings.dart';
import '../../constants/endpoints.dart';
import '../../core/api_client.dart';
import '../../models/notification_model.dart';
import 'widgets/notification_card.dart';

class NotificationFeedScreen extends StatefulWidget {
  const NotificationFeedScreen({super.key});

  @override
  State<NotificationFeedScreen> createState() => _NotificationFeedScreenState();
}

class _NotificationFeedScreenState extends State<NotificationFeedScreen> {
  List<NotificationModel> _notifs = [];
  String _selectedFilter = 'ALL';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    setState(() => _isLoading = true);
    try {
      final params = _selectedFilter == 'ALL' ? null : {'source': _selectedFilter};
      final res = await apiClient.get(AppEndpoints.notifications, queryParams: params) as List;

      if (mounted) {
        setState(() {
          _notifs = res.map((e) => NotificationModel.fromJson(e as Map<String, dynamic>)).toList();
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
        title: const Text(AppStrings.notificationCenterTitle, style: AppTypography.pageTitle),
      ),
      body: Column(
        children: [
          _buildFilterTabs(),
          Expanded(
            child: _isLoading
                ? const Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)))
                : _notifs.isEmpty
                    ? const Center(child: Text(AppStrings.emptyNotifications, style: AppTypography.caption))
                    : RefreshIndicator(
                        color: AppColors.primary,
                        onRefresh: _fetchNotifications,
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                          padding: const EdgeInsets.symmetric(horizontal: AppTokens.space16, vertical: AppTokens.space12),
                          itemCount: _notifs.length,
                          itemBuilder: (_, i) => NotificationCard(item: _notifs[i]),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: AppTokens.space16, vertical: AppTokens.space6),
      child: Row(
        children: [
          _buildFilterChip('ALL', AppStrings.filterAll),
          const SizedBox(width: AppTokens.space6),
          _buildFilterChip('LLM', AppStrings.filterAi),
          const SizedBox(width: AppTokens.space6),
          _buildFilterChip('RULE', AppStrings.filterRule),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String key, String label) {
    final isSelected = _selectedFilter == key;
    return ChoiceChip(
      label: Text(label, style: AppTypography.badge.copyWith(color: isSelected ? Colors.white : AppColors.textSecondary)),
      selected: isSelected,
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.surfaceAlt,
      visualDensity: VisualDensity.compact,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTokens.radiusXs), side: const BorderSide(color: Colors.transparent)),
      onSelected: (val) {
        if (val) {
          setState(() => _selectedFilter = key);
          _fetchNotifications();
        }
      },
    );
  }
}
