import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/tokens.dart';
import '../../constants/typography.dart';
import '../../constants/strings.dart';
import '../../constants/endpoints.dart';
import '../../core/api_client.dart';
import '../../models/schedule_model.dart';
import 'widgets/schedule_item_card.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<ScheduleModel> _schedules = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchSchedules();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchSchedules() async {
    setState(() => _isLoading = true);
    try {
      final res = await apiClient.get(AppEndpoints.schedules) as List;
      if (mounted) {
        setState(() {
          _schedules = res.map((e) => ScheduleModel.fromJson(e as Map<String, dynamic>)).toList();
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
      appBar: _buildAppBar(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary))
          : RefreshIndicator(
              color: AppColors.primary,
              onRefresh: _fetchSchedules,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                padding: const EdgeInsets.symmetric(horizontal: AppTokens.space16, vertical: AppTokens.space12),
                children: [
                  _buildSemesterHeader(),
                  const SizedBox(height: AppTokens.space12),
                  ..._buildGroupedScheduleList(),
                ],
              ),
            ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      title: const Text(AppStrings.scheduleTitle, style: AppTypography.screenTitle),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: Container(
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.border))),
          child: TabBar(
            controller: _tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            labelStyle: AppTypography.caption.copyWith(fontWeight: FontWeight.w700),
            indicatorColor: AppColors.primary,
            indicatorWeight: 2,
            tabs: const [Tab(text: AppStrings.weeklyView), Tab(text: AppStrings.dailyView)],
          ),
        ),
      ),
    );
  }

  Widget _buildSemesterHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppTokens.space12, vertical: AppTokens.space10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTokens.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(AppStrings.academicYear, style: AppTypography.caption.copyWith(fontWeight: FontWeight.w700)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppTokens.space8, vertical: AppTokens.space2),
            decoration: BoxDecoration(color: AppColors.blueLight, borderRadius: BorderRadius.circular(AppTokens.radiusSm)),
            child: Text('${_schedules.length} Mata Kuliah', style: AppTypography.badge.copyWith(color: AppColors.blue, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildGroupedScheduleList() {
    final Map<String, List<ScheduleModel>> grouped = {};
    for (var s in _schedules) {
      grouped.putIfAbsent(s.hari, () => []).add(s);
    }

    final List<Widget> widgets = [];
    grouped.forEach((day, items) {
      widgets.add(Padding(
        padding: const EdgeInsets.only(top: AppTokens.space8, bottom: AppTokens.space6, left: AppTokens.space2),
        child: Text(day.toUpperCase(), style: AppTypography.sectionHeader),
      ));
      for (var item in items) {
        widgets.add(ScheduleItemCard(schedule: item));
      }
    });
    return widgets;
  }
}
