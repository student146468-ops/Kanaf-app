import 'package:flutter/material.dart';
import '../../providers/app_provider_scope.dart';
import '../../utils/app_colors.dart';
import 'care_home_light_widgets.dart';

/// [CareHomeDashboardScreen] - ط§ظ„ظˆط§ط¬ظ‡ط© ط±ظ‚ظ… 27: ظ„ظˆط­ط© ط§ظ„طھط­ظƒظ… ط§ظ„ط±ط¦ظٹط³ظٹط© ظ„ط¯ط§ط± ط§ظ„ط±ط¹ط§ظٹط© ظ„ط¹ط§ظ… 2026.
/// ظ…طµظ…ظ…ط© ط¨ظˆط§ط¬ظ‡ط© ظ…ظˆط¨ط§ظٹظ„ ط¨ظٹط¶ط§ط، ظˆظ†ط¸ظٹظپط© ظ„طھظ†ط¸ظٹظ… ط¯ط¹ظ… ط¯ط§ط± ط§ظ„ط±ط¹ط§ظٹط© ط¨ظˆط¶ظˆط­.
class CareHomeDashboardScreen extends StatefulWidget {
  const CareHomeDashboardScreen({super.key});

  @override
  State<CareHomeDashboardScreen> createState() =>
      _CareHomeDashboardScreenState();
}

class _CareHomeDashboardScreenState extends State<CareHomeDashboardScreen> {
  // TODO: Replace fallback dashboard numbers with live AppProvider/backend data.
  final int _activeNeedsCount = 14;
  final int _newVolunteersCount = 8;
  final String _totalDonations = "4,250 د.ل";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWebOrDesktop = size.width > 600;
    final containerWidth = isWebOrDesktop ? 430.0 : double.infinity;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: Center(
          child: Container(
            width: containerWidth,
            height: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: AppColors.scaffoldBackground,
              boxShadow: isWebOrDesktop
                  ? [
                      BoxShadow(
                          color: AppColors.innerShadow,
                          blurRadius: 24,
                          spreadRadius: 0)
                    ]
                  : [],
            ),
            child: Stack(
              children: [
                // 1ï¸ڈâƒ£ ط®ظ„ظپظٹط© ظ‡ط§ط¯ط¦ط© ظ„طھط·ط¨ظٹظ‚ ظƒظژظ†ظژظپظ’
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Colors.white,
                          AppColors.scaffoldBackground,
                          AppColors.scaffoldBackground,
                        ],
                        stops: [0.0, 0.52, 1.0],
                      ),
                    ),
                  ),
                ),

                // 2ï¸ڈâƒ£ ط؛ط·ط§ط، ط­ظ…ط§ظٹط© ط§ظ„ظ†طµ ظˆط§ظ„طھط¹طھظٹظ… ط§ظ„ظ…طھط¯ط±ط¬ ط§ظ„ط§ط­طھط±ط§ظپظٹ ظ„ط±ط§ط­ط© ط§ظ„ط¹ظٹظ†
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white,
                          Colors.white,
                          Colors.white,
                        ],
                      ),
                    ),
                  ),
                ),

                // 3ï¸ڈâƒ£ ط§ظ„ظ…ط­طھظˆظ‰ ط§ظ„ط¨ط±ظ…ط¬ظٹ ظ…ظ‚ط³ظ… ظˆظ…ظˆط²ط¹ ظ‡ظ†ط¯ط³ظٹط§ظ‹ ط¨ط¯ظˆظ† طھط´طھظٹطھ
                SafeArea(
                  child: Column(
                    children: [
                      _buildHeader(),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildWelcomeSection(),
                              const SizedBox(height: 24),
                              _buildStatisticsGrid(),
                              const SizedBox(height: 28),
                              _buildSectionTitle('إجراءات سريعة'),
                              const SizedBox(height: 14),
                              _buildQuickActionsGrid(),
                              const SizedBox(height: 28),
                              _buildSectionTitle('آخر التحديثات'),
                              const SizedBox(height: 14),
                              _buildRecentActivitiesList(),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ظ‹ع؛â€؛آ أ¯آ¸عˆ ط§ظ„ط¬ط²ط، 1: ط§ظ„طھط±ظˆظٹط³ط© ط§ظ„ط¹ظ„ظˆظٹط© ط§ظ„ظˆط§ط¶ط­ط© ط§ظ„ظ…ط±طھط¨ط·ط© ط¨ط§ظ„ط¥ط´ط¹ط§ط±ط§طھ ظˆط§ظ„ظ…ظ„ظپ ط§ظ„ط´ط®طµظٹ
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () =>
                    Navigator.of(context).pushNamed('/care_home_profile'),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: AppColors.brandOrange.withOpacity(0.6),
                        width: 1.5),
                    color: AppColors.brandOrange.withOpacity(0.12),
                  ),
                  child: const Icon(
                    Icons.home_work_rounded,
                    color: AppColors.brandOrange,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'دار الأمان لرعاية الأيتام',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDarkPrimary,
                    ),
                  ),
                  Text(
                    'فرع غريان الرئيسي',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      color: AppColors.textDarkSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // ط²ط± ط§ظ„ط¥ط´ط¹ط§ط±ط§طھ ط§ظ„ظ…ط±ط¨ظˆط· ط¨ط§ظ„ظˆط§ط¬ظ‡ط© ط±ظ‚ظ… 37 طھظ„ظ‚ط§ط¦ظٹط§ظ‹
          GestureDetector(
            onTap: () =>
                Navigator.of(context).pushNamed('/care_home_notifications'),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.innerBorder, width: 1),
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: AppColors.textDarkPrimary,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ظ‹ع؛â€؛آ أ¯آ¸عˆ ط§ظ„ط¬ط²ط، 2: ط§ظ„ظ…ظ‚ط·ط¹ ط§ظ„طھط±ط­ظٹط¨ظٹ ط§ظ„طھظپط§ط¹ظ„ظٹ
  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'مرحبًا بك مجددًا',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16,
            color: AppColors.textDarkSecondary,
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          'نظّم احتياجات الدار بوضوح',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: AppColors.textDarkPrimary,
          ),
        ),
      ],
    );
  }

  /// ظ‹ع؛â€؛آ أ¯آ¸عˆ ط§ظ„ط¬ط²ط، 3: ط´ط¨ظƒط© ط§ظ„ط¥ط­طµط§ط¦ظٹط§طھ ط§ظ„ظˆط§ط¶ط­ط© ط¨ظ„ظ…ط³ط© ط£ظ„ظˆط§ظ† ط¹طµط±ظٹط© ط·ط§ظپظٹط© ظˆظ…ط±ظٹط­ط©
  Widget _buildStatisticsGrid() {
    final stats = AppProviderScope.of(context).dashboardStats;
    final activeNeeds =
        stats['active_needs']?.toString() ?? '$_activeNeedsCount';
    final totalDonations =
        stats['monthly_support']?.toString() ?? _totalDonations;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'احتياجات نشطة',
            activeNeeds,
            Icons.analytics_outlined,
            AppColors.brandOrange,
            () => Navigator.of(context).pushNamed('/care_home_needs_list'),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _buildStatCard(
            'تبرعات واردة',
            totalDonations,
            Icons.account_balance_wallet_outlined,
            const Color(
                0xFF10B981), // طھظ… ط§ط³طھط¨ط¯ط§ظ„ ط§ظ„ط³ظ…ط© ط؛ظٹط± ط§ظ„ظ…ط¹ط±ظپط© ط¨ط§ظ„ظƒظˆط¯ ط§ظ„ط³ط¯ط§ط³ظٹ ط§ظ„طµط§ظپظٹ ظ„ظ„ظˆظ† ط§ظ„ط²ظ…ط±ط¯ظٹ
            () => Navigator.of(context)
                .pushNamed('/care_home_incoming_donations'),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon,
      Color accentColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: CareHomeCard(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: accentColor, size: 24),
                Icon(Icons.arrow_outward_rounded,
                    color: AppColors.textDarkMuted.withOpacity(0.45), size: 16),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.textDarkPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textDarkSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ظ‹ع؛â€؛آ أ¯آ¸عˆ ط§ظ„ط¬ط²ط، 4: ط´ط¨ظƒط© ط£ط²ط±ط§ط± ط§ظ„ط¹ظ…ظ„ظٹط§طھ ط§ظ„ط³ط±ظٹط¹ط© ط§ظ„ظ…ط±ط¨ظˆط·ط© ظ‡ظ†ط¯ط³ظٹط§ظ‹ ط¨ط¨ظ‚ظٹط© ط§ظ„ظ…ظ„ظپط§طھ ط§ظ„ظ€ 13
  Widget _buildQuickActionsGrid() {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width < 380 ? 2 : 3;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: crossAxisCount == 2 ? 1.45 : 0.95,
      children: [
        _buildActionItem(
          'إضافة احتياج',
          Icons.add_circle_outline_rounded,
          AppColors.brandOrange,
          () => Navigator.of(context).pushNamed('/care_home_add_need'),
        ),
        _buildActionItem(
          'المتطوعون',
          Icons.groups_2_outlined,
          Colors.blueAccent,
          () => Navigator.of(context).pushNamed('/care_home_manage_volunteers'),
        ),
        _buildActionItem(
          'مواعيد الزيارة',
          Icons.event_available_outlined,
          const Color(0xFF8B5CF6),
          () => Navigator.of(context).pushNamed('/care_home_visit_hours'),
        ),
        _buildActionItem(
          'التقارير',
          Icons.query_stats_outlined,
          const Color(0xFF0F766E),
          () => Navigator.of(context).pushNamed('/care_home_reports'),
        ),
        _buildActionItem(
          'تقييم الأداء',
          Icons.star_half_rounded,
          Colors.amber,
          () => Navigator.of(context).pushNamed('/care_home_rate_volunteers'),
        ),
        _buildActionItem(
          'ملف الدار',
          Icons.home_work_outlined,
          const Color(0xFFDB2777),
          () => Navigator.of(context).pushNamed('/care_home_profile'),
        ),
      ],
    );
  }

  Widget _buildActionItem(
      String label, IconData icon, Color iconColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: CareHomeCard(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textDarkPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ظ‹ع؛â€؛آ أ¯آ¸عˆ ط§ظ„ط¬ط²ط، 5: ط§ظ„طھط­ط¯ظٹط«ط§طھ ظˆط§ظ„ظ†ط´ط§ط·ط§طھ ط§ظ„ط£ط®ظٹط±ط© ط¯ط§ط®ظ„ ط§ظ„ط¯ط§ط±
  Widget _buildRecentActivitiesList() {
    final activities = [
      {
        'title': 'تمت كفالة احتياج كسوة العيد',
        'time': 'منذ 10 دقائق',
        'type': 'donation'
      },
      {
        'title': 'طلب تطوع جديد بانتظار المراجعة',
        'time': 'منذ ساعة',
        'type': 'volunteer'
      },
      // ط¯ظ…ط¬ ط§ظ„ظ…طھط؛ظٹط± ط§ظ„ط°ظƒظٹ ظ‡ظ†ط§ ظ„ط¥ظ†ظ‡ط§ط، طھط­ط°ظٹط± ط§ظ„ظƒظˆظ…ط¨ط§ظٹظ„ط± ط§ظ„ط£طµظپط± طھظ…ط§ظ…ط§ظ‹
      {
        'title': 'يوجد حاليًا $_newVolunteersCount طلبات تطوع تحتاج قرارًا',
        'time': 'منذ ساعتين',
        'type': 'system'
      },
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: activities.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final activity = activities[index];
        IconData leadingIcon = Icons.info_outline_rounded;
        Color iconColor = Colors.grey;

        if (activity['type'] == 'donation') {
          leadingIcon = Icons.favorite_rounded;
          iconColor = AppColors.brandOrange;
        } else if (activity['type'] == 'volunteer') {
          leadingIcon = Icons.person_add_alt_1_rounded;
          iconColor = Colors.blueAccent;
        }

        return CareHomeCard(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            children: [
              Icon(leadingIcon, color: iconColor, size: 20),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  activity['title']!,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDarkPrimary,
                  ),
                ),
              ),
              Text(
                activity['time']!,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 11,
                  color: AppColors.textDarkSecondary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// ط¹ظ†ظˆط§ظ† ط¬ط§ظ†ط¨ظٹ ظ…ظ†ط³ظ‚ ظˆظ…ظˆط­ط¯ ظ„ظ…ظ†ط¹ ط§ظ„ظ‡ط²ط© ظˆط§ظ„طھط´طھطھ ط§ظ„ط¨طµط±ظٹ
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Cairo',
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: AppColors.textDarkPrimary,
      ),
    );
  }
}
