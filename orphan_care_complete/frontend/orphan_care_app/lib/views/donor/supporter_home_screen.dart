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
    {'title': 'مالي', 'icon': Icons.savings_rounded},
    {'title': 'غذائي', 'icon': Icons.ramen_dining_rounded},
    {'title': 'كساء', 'icon': Icons.checkroom_rounded},
    {'title': 'صحي', 'icon': Icons.health_and_safety_rounded},
  ];

  final List<Map<String, dynamic>> _fallbackNeedsData = const [
    {
      'id': '1',
      'orphanage': 'دار رعاية الأيتام - غريان',
      'category': 'مالي',
      'title': 'تغطية المصاريف الدراسية لخمسة طلاب خلال الفصل القادم',
      'progress': 0.65,
      'raised': '3,250 د.ل',
      'target': '5,000 د.ل',
      'urgency': 'عاجل',
      'daysLeft': '3 أيام',
      'description': 'مساهمة تعليمية تحفظ انتظام الطلاب وتخفف العبء عن الدار.',
    },
    {
      'id': '2',
      'orphanage': 'جمعية كنف للأطفال - غريان',
      'category': 'غذائي',
      'title': 'توفير سلات غذائية متوازنة لأطفال الدار خلال الشهر',
      'progress': 0.40,
      'raised': '1,600 د.ل',
      'target': '4,000 د.ل',
      'urgency': 'متوسط',
      'daysLeft': '12 يوم',
      'description': 'احتياج يومي يساعد الفريق على تقديم وجبات صحية ومنتظمة.',
    },
    {
      'id': '3',
      'orphanage': 'بيت الأمل للبنين - غريان',
      'category': 'كساء',
      'title': 'توفير كسوة مريحة للأطفال من عمر 4 إلى 10 سنوات',
      'progress': 0.85,
      'raised': '5,100 د.ل',
      'target': '6,000 د.ل',
      'urgency': 'عاجل',
      'daysLeft': '5 أيام',
      'description': 'ملابس وأحذية جديدة تحفظ كرامة الأطفال وتلائم الموسم.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredNeeds = _selectedCategory == 'الكل'
        ? _fallbackNeedsData
        : _fallbackNeedsData
            .where((need) => need['category'] == _selectedCategory)
            .toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: _buildAppBar(),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(child: _buildWelcomeCard()),
                  SliverToBoxAdapter(child: _buildCategoryBar()),
                  SliverToBoxAdapter(
                      child: _buildSectionHeader(filteredNeeds.length)),
                  if (filteredNeeds.isEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: _EmptyState(),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      sliver: SliverList.separated(
                        itemCount: filteredNeeds.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
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
        bottomNavigationBar: donorMobileBottomBar(
          child: _buildBottomNavigation(),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: donorMobileMaxWidth),
          child: AppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            elevation: 0,
            titleSpacing: 20,
            title: const Text(
              'كنف العطاء',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textDarkPrimary,
              ),
            ),
            actions: [
              IconButton(
                tooltip: 'البحث',
                icon: const Icon(Icons.manage_search_rounded,
                    color: AppColors.textDarkSecondary),
                onPressed: () => Navigator.pushNamed(context, '/search_filter'),
              ),
              IconButton(
                tooltip: 'الإشعارات',
                icon: const Icon(Icons.notifications_active_outlined,
                    color: AppColors.textDarkSecondary),
                onPressed: () => Navigator.pushNamed(context, '/notifications'),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 18),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.innerBorder),
        boxShadow: const [
          BoxShadow(
            color: AppColors.innerShadow,
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.brandOrangeLight,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.volunteer_activism_rounded,
                color: AppColors.brandOrange),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مرحبًا بك في كنف',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDarkPrimary,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'هنا تصل مساهمتك إلى احتياج واضح، موثق، وقابل للمتابعة بهدوء وثقة.',
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
    );
  }

  Widget _buildCategoryBar() {
    return SizedBox(
      height: 46,
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
              fontWeight: FontWeight.w700,
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
                fontWeight: FontWeight.w800,
                color: AppColors.textDarkPrimary,
              ),
            ),
          ),
          Text(
            '$count حالة',
            style: const TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.brandOrangeDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return NavigationBar(
      selectedIndex: 0,
      height: 68,
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
    final isUrgent = need['urgency'] == 'عاجل';
    final isCompact = MediaQuery.sizeOf(context).width < 360;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () =>
            Navigator.pushNamed(context, '/need_details', arguments: need),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.innerBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _StatusPill(
                    label: need['category'] as String,
                    icon: Icons.category_rounded,
                    color: AppColors.skyBlueDark,
                    background: AppColors.skyBlueLight,
                  ),
                  _StatusPill(
                    label: need['urgency'] as String,
                    icon: isUrgent
                        ? Icons.priority_high_rounded
                        : Icons.schedule_rounded,
                    color: isUrgent
                        ? AppColors.brandOrangeDark
                        : AppColors.textDarkSecondary,
                    background: isUrgent
                        ? AppColors.brandOrangeLight
                        : AppColors.surfaceLight,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                need['title'] as String,
                maxLines: isCompact ? 2 : 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 15.5,
                  height: 1.45,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDarkPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                need['description'] as String,
                maxLines: isCompact ? 1 : 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 13.5,
                  height: 1.45,
                  color: AppColors.textDarkSecondary,
                ),
              ),
              const SizedBox(height: 14),
              InkWell(
                onTap: () => Navigator.pushNamed(context, '/orphanage_profile'),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.apartment_rounded,
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
                        fontWeight: FontWeight.w700,
                        color: AppColors.brandOrangeDark,
                      ),
                    ),
                  ),
                  Text(
                    'الهدف ${need['target']}',
                    style: const TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 13,
                      color: AppColors.textDarkMuted,
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
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.brandOrange),
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
                      'متبقي ${need['daysLeft']}',
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
                    label: Text(isCompact ? 'ادعم' : 'ادعم الآن'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.brandOrange,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.label,
    required this.icon,
    required this.color,
    required this.background,
  });

  final String label;
  final IconData icon;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 15),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.volunteer_activism_outlined,
                size: 48, color: AppColors.textDarkMuted),
            SizedBox(height: 12),
            Text(
              'لا توجد احتياجات ضمن هذا التصنيف الآن.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 14,
                color: AppColors.textDarkSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
