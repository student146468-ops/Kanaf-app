import 'package:flutter/material.dart';
import 'volunteer_opportunity_details_view.dart';
import 'notifications_view.dart';
import 'search_filter_view.dart';
import 'profile_volunteer_view.dart';
import 'my_schedule_view.dart';
import '../../utils/app_colors.dart';

class HomeVolunteerView extends StatefulWidget {
  const HomeVolunteerView({super.key});

  @override
  State<HomeVolunteerView> createState() => _HomeVolunteerViewState();
}

class _HomeVolunteerViewState extends State<HomeVolunteerView> {
  int _currentIndex = 0;

  final List<Map<String, String>> _opportunities = const [
    {
      'title': 'تدريس أساسيات الحاسوب والبرمجة للأيتام',
      'location': 'دار رعاية الأيتام المركزية - غريان',
      'duration': '4 ساعات / أسبوعياً',
      'tag': 'تعليم وتطوير',
      'seats': 'متبقي مقعدان فقط ⚠️'
    },
    {
      'title': 'تنظيم يوم ترفيهي ودعم نفسي للأطفال',
      'location': 'جمعية كَنَفْ لرعاية الطفل - غريان',
      'duration': 'الجمعة القادمة (يوم كامل)',
      'tag': 'أنشطة وترفيه',
      'seats': 'متبقي 5 مقاعد'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 250,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: AppColors.orangeGradient,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('مرحباً بكِ في كَنَفْ،', style: TextStyle(color: AppColors.glassTextSecondary, fontSize: 13, fontFamily: 'Tajawal', fontWeight: FontWeight.w500)),
                              SizedBox(height: 5),
                              Text('أماني عادل أحمد 👋', style: TextStyle(color: AppColors.glassTextPrimary, fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsView())),
                            child: Container(
                              padding: const EdgeInsets.all(11),
                              decoration: BoxDecoration(color: AppColors.glassBgNormal, shape: BoxShape.circle, border: Border.all(color: AppColors.glassBorderNormal, width: 1.2)),
                              child: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 24),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
                      child: Container(
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(color: AppColors.glassBgSelected.withOpacity(0.35), borderRadius: BorderRadius.circular(26), border: Border.all(color: AppColors.glassBorderSelected.withOpacity(0.4), width: 1.5)),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text('صنّاع الأثر في غريان 🌟', style: TextStyle(color: AppColors.glassTextPrimary, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
                                  SizedBox(height: 8),
                                  Text('لقد أكملتِ 24 ساعة تطوعية هذا الشهر! رصيدكِ الإنساني ينمو.', style: TextStyle(color: AppColors.glassTextSecondary, fontSize: 12.5, height: 1.6, fontFamily: 'Tajawal')),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                              child: const Icon(Icons.volunteer_activism_rounded, color: AppColors.brandOrange, size: 30),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 24.0, left: 20, right: 20),
                      child: GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchFilterView())),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                          decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.innerBorder, width: 1)),
                          child: Row(
                            children: const [
                              Icon(Icons.search_rounded, color: AppColors.textDarkMuted, size: 22),
                              SizedBox(width: 12),
                              Text('ابحث عن فرص تطوعية...', style: TextStyle(color: AppColors.textDarkMuted, fontSize: 13.5, fontFamily: 'Tajawal')),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = _opportunities[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 9),
                          child: GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const VolunteerOpportunityDetailsView())),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(24), border: Border.all(color: AppColors.innerBorder, width: 1)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
                                  const SizedBox(height: 10),
                                  Text(item['location']!, style: const TextStyle(color: AppColors.textDarkSecondary, fontSize: 13, fontFamily: 'Tajawal')),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: _opportunities.length,
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 110)),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() => _currentIndex = index);
            if (index == 1) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const MyScheduleView()));
            } else if (index == 2) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileVolunteerView()));
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.explore_rounded), label: 'الرئيسية'),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_today_rounded), label: 'مواعيدي'),
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'حسابي'),
          ],
        ),
      ),
    );
  }
}
