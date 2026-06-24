import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import 'donor_mobile_chrome.dart';

class SupporterHomeScreen extends StatefulWidget {
  const SupporterHomeScreen({super.key});

  @override
  State<SupporterHomeScreen> createState() => _SupporterHomeScreenState();
}

class _SupporterHomeScreenState extends State<SupporterHomeScreen> {
  String _selectedCategory = 'الكل';

  final List<Map<String, dynamic>> _categories = const [
    {'title': 'الكل', 'icon': Icons.apps_rounded},
    {'title': 'مالي', 'icon': Icons.savings_outlined},
    {'title': 'غذائي', 'icon': Icons.restaurant_outlined},
    {'title': 'كسوة', 'icon': Icons.checkroom_outlined},
    {'title': 'صحي', 'icon': Icons.health_and_safety_outlined},
  ];

  // TODO: Replace fallback needs with AppProvider/backend donor needs when available.
  final List<Map<String, dynamic>> _needs = const [
    {
      'id': '1',
      'orphanage': 'دار الأمان لرعاية الأيتام - غريان',
      'category': 'مالي',
      'title': 'تغطية المصاريف الدراسية لخمسة طلاب',
      'progress': 0.65,
      'raised': '3,250 د.ل',
      'target': '5,000 د.ل',
      'remaining': '1,750 د.ل',
      'urgency': 'عاجل',
      'daysLeft': '3 أيام',
      'status': 'قيد التنفيذ',
      'description': 'مساهمة تعليمية تحفظ انتظام الطلاب وتخفف العبء عن الدار.',
    },
    {
      'id': '2',
      'orphanage': 'جمعية كنف للأطفال - غريان',
      'category': 'غذائي',
      'title': 'توفير سلات غذائية متوازنة للأطفال',
      'progress': 0.40,
      'raised': '1,600 د.ل',
      'target': '4,000 د.ل',
      'remaining': '2,400 د.ل',
      'urgency': 'متوسط',
      'daysLeft': '12 يوم',
      'status': 'جديد',
      'description': 'احتياج يومي يساعد الفريق على تقديم وجبات صحية ومنتظمة.',
    },
    {
      'id': '3',
      'orphanage': 'بيت الأمل للبنين - غريان',
      'category': 'كسوة',
      'title': 'توفير كسوة مريحة للأطفال من عمر 4 إلى 10 سنوات',
      'progress': 0.85,
      'raised': '5,100 د.ل',
      'target': '6,000 د.ل',
      'remaining': '900 د.ل',
      'urgency': 'عاجل',
      'daysLeft': '5 أيام',
      'status': 'قيد التنفيذ',
      'description': 'ملابس وأحذية جديدة تحفظ كرامة الأطفال وتناسب الموسم.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredNeeds = _selectedCategory == 'الكل'
        ? _needs
        : _needs
            .where((need) => need['category'] == _selectedCategory)
            .toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: donorMobileAppBar(
          title: 'كنف العطاء',
          actions: [
            DonorCircleButton(
              icon: Icons.search_rounded,
              tooltip: 'البحث',
              onTap: () => Navigator.pushNamed(context, '/search_filter'),
            ),
            const SizedBox(width: 8),
            DonorCircleButton(
              icon: Icons.notifications_none_rounded,
              tooltip: 'الإشعارات',
              onTap: () => Navigator.pushNamed(context, '/notifications'),
            ),
            const SizedBox(width: 12),
          ],
        ),
        body: Stack(
          children: [
            const Positioned.fill(child: DonorBackground()),
            SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxWidth: donorMobileMaxWidth),
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(child: _buildWelcomeCard()),
                      SliverToBoxAdapter(child: _buildCategoryBar()),
                      SliverToBoxAdapter(
                        child: _buildSectionHeader(filteredNeeds.length),
                      ),
                      if (filteredNeeds.isEmpty)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: DonorEmptyState(
                            icon: Icons.volunteer_activism_outlined,
                            title: 'لا توجد احتياجات ضمن هذا التصنيف',
                            message:
                                'غيّر التصنيف أو استخدم البحث للوصول إلى احتياج مناسب.',
                            actionLabel: 'فتح البحث',
                            onAction: () =>
                                Navigator.pushNamed(context, '/search_filter'),
                          ),
                        )
                      else
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                          sliver: SliverList.separated(
                            itemCount: filteredNeeds.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              return _NeedCard(need: filteredNeeds[index]);
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar:
            donorMobileBottomBar(child: _buildBottomNavigation()),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 18),
      child: DonorCard(
        padding: EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DonorIconBox(
              icon: Icons.volunteer_activism_outlined,
              color: AppColors.brandOrange,
              size: 52,
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ساهم في احتياج حقيقي اليوم',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textDarkPrimary,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'اختر احتياجًا موثقًا، وتابع أثر مساهمتك حتى تصل إلى دار الرعاية.',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 14,
                      height: 1.55,
                      color: AppColors.textDarkSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBar() {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category['title'];

          return ChoiceChip(
            avatar: Icon(
              category['icon'] as IconData,
              size: 17,
              color: isSelected ? Colors.white : AppColors.textDarkSecondary,
            ),
            label: Text(category['title'] as String),
            selected: isSelected,
            showCheckmark: false,
            selectedColor: AppColors.brandOrange,
            backgroundColor: Colors.white,
            side: BorderSide(
              color: isSelected ? AppColors.brandOrange : AppColors.innerBorder,
            ),
            labelStyle: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w800,
              fontSize: 12.5,
              color: isSelected ? Colors.white : AppColors.textDarkSecondary,
            ),
            onSelected: (_) {
              setState(() => _selectedCategory = category['title'] as String);
            },
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 12),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'احتياجات يمكن دعمها الآن',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: AppColors.textDarkPrimary,
              ),
            ),
          ),
          DonorBadge(
            label: '$count حالة',
            color: AppColors.brandOrangeDark,
            icon: Icons.list_alt_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return NavigationBar(
      selectedIndex: 0,
      height: 72,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      indicatorColor: AppColors.brandOrangeLight,
      onDestinationSelected: (index) {
        if (index == 1) {
          Navigator.pushNamed(context, '/donation_history');
        } else if (index == 2) {
          Navigator.pushNamed(context, '/profile');
        }
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_rounded, color: AppColors.brandOrange),
          label: 'الرئيسية',
        ),
        NavigationDestination(
          icon: Icon(Icons.receipt_long_outlined),
          selectedIcon:
              Icon(Icons.receipt_long_rounded, color: AppColors.brandOrange),
          label: 'السجل',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline_rounded),
          selectedIcon:
              Icon(Icons.person_rounded, color: AppColors.brandOrange),
          label: 'حسابي',
        ),
      ],
    );
  }
}

class _NeedCard extends StatelessWidget {
  const _NeedCard({required this.need});

  final Map<String, dynamic> need;

  @override
  Widget build(BuildContext context) {
    final progress = (need['progress'] as num).toDouble().clamp(0.0, 1.0);
    final percentage = (progress * 100).round();
    final urgency = need['urgency'] as String;
    final status = need['status'] as String;
    final statusColor = donorStatusColor(status);
    final isUrgent = urgency == 'عاجل';

    return DonorCard(
      onTap: () =>
          Navigator.pushNamed(context, '/need_details', arguments: need),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              DonorBadge(
                label: urgency,
                color: isUrgent
                    ? AppColors.brandOrangeDark
                    : AppColors.skyBlueDark,
                icon: isUrgent
                    ? Icons.priority_high_rounded
                    : Icons.flag_outlined,
              ),
              DonorBadge(
                label: status,
                color: statusColor,
                icon: status == 'جديد'
                    ? Icons.fiber_new_outlined
                    : Icons.timelapse_outlined,
              ),
              DonorBadge(
                label: need['category'] as String,
                color: AppColors.textDarkSecondary,
                icon: Icons.category_outlined,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            need['title'] as String,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 15.5,
              height: 1.45,
              fontWeight: FontWeight.w900,
              color: AppColors.textDarkPrimary,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            need['description'] as String,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 13.5,
              height: 1.45,
              color: AppColors.textDarkSecondary,
            ),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () => Navigator.pushNamed(context, '/orphanage_profile'),
            borderRadius: BorderRadius.circular(12),
            child: Row(
              children: [
                const Icon(Icons.home_work_outlined,
                    color: AppColors.textDarkMuted, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    need['orphanage'] as String,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDarkSecondary,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_left_rounded,
                    color: AppColors.textDarkMuted),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  'جُمع ${need['raised']}',
                  style: const TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.brandOrangeDark,
                  ),
                ),
              ),
              Text(
                '$percentage%',
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textDarkPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              minHeight: 8,
              value: progress,
              backgroundColor: AppColors.surfaceLight,
              valueColor: AlwaysStoppedAnimation<Color>(
                isUrgent ? AppColors.brandOrange : AppColors.skyBlueDark,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(Icons.timer_outlined,
                  color: AppColors.textDarkMuted, size: 17),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'متبقي ${need['daysLeft']} • ${need['remaining']}',
                  style: const TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 13,
                    color: AppColors.textDarkSecondary,
                  ),
                ),
              ),
              FilledButton.icon(
                onPressed: () => Navigator.pushNamed(
                  context,
                  '/need_details',
                  arguments: need,
                ),
                icon: const Icon(Icons.favorite_rounded, size: 17),
                label: const Text('ادعم الآن'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.brandOrange,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12.5,
                    fontWeight: FontWeight.w900,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
