import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../widgets/glass_container.dart';

/// [CareHomeDashboardScreen] - الواجهة رقم 27: لوحة التحكم الرئيسية لدار الرعاية لعام 2026.
/// مصممة بالكامل بنمط الـ Glassmorphism الكريستالي لمنع التشتت وجذب انتباه المناقشين.
class CareHomeDashboardScreen extends StatefulWidget {
  const CareHomeDashboardScreen({super.key});

  @override
  State<CareHomeDashboardScreen> createState() => _CareHomeDashboardScreenState();
}

class _CareHomeDashboardScreenState extends State<CareHomeDashboardScreen> {
  // بيانات محاكاة سريعة للإحصائيات لعرضها بشكل فخم ومقنع للجنة
  final int _activeNeedsCount = 14;
  final int _newVolunteersCount = 8;
  final String _totalDonations = "4,250 د.ل";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWebOrDesktop = size.width > 600;
    final containerWidth = isWebOrDesktop ? 420.0 : double.infinity;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF131313), // الخلفية الداكنة المعتمدة لإبراز طبقات الزجاج
        body: Center(
          child: Container(
            width: containerWidth,
            height: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.black,
              boxShadow: isWebOrDesktop
                  ? [BoxShadow(color: Colors.black.withOpacity(0.6), blurRadius: 45, spreadRadius: 8)]
                  : [],
            ),
            child: Stack(
              children: [
                // 1️⃣ الصورة الخلفية الحية الطافية لـ "تطبيق كَنَفْ"
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color(0xFF261611),
                          Color(0xFF141416),
                          Color(0xFF0D1117),
                        ],
                        stops: [0.0, 0.52, 1.0],
                      ),
                    ),
                  ),
                ),

                // 2️⃣ غطاء حماية النص والتعتيم المتدرج الاحترافي لراحة العين
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.3),
                          AppColors.brandOrangeDark.withOpacity(0.2),
                          Colors.black.withOpacity(0.9),
                        ],
                      ),
                    ),
                  ),
                ),

                // 3️⃣ المحتوى البرمجي مقسم وموزع هندسياً بدون تشتيت
                SafeArea(
                  child: Column(
                    children: [
                      _buildHeader(),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildWelcomeSection(),
                              const SizedBox(height: 24),
                              _buildStatisticsGrid(),
                              const SizedBox(height: 28),
                              _buildSectionTitle('الوصول السريع للعمليات'),
                              const SizedBox(height: 14),
                              _buildQuickActionsGrid(),
                              const SizedBox(height: 28),
                              _buildSectionTitle('آخر التحديثات النشطة'),
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

  /// 🛠️ الجزء 1: الترويسة العلوية الفخمة المرتبطة بالإشعارات والملف الشخصي
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pushNamed('/care_home_profile'),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.brandOrange.withOpacity(0.6), width: 1.5),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/care_home_3d.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'دار الأمان للأيتام',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.glassTextPrimary,
                    ),
                  ),
                  Text(
                    'فرع غريان الرئيسي',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      color: AppColors.glassTextSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // زر الإشعارات المربوط بالواجهة رقم 37 تلقائياً
          GestureDetector(
            onTap: () => Navigator.of(context).pushNamed('/care_home_notifications'),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: AppColors.glassTextPrimary,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🛠️ الجزء 2: المقطع الترحيبي التفاعلي
  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'أهلاً بكِ مجدداً،',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16,
            color: AppColors.glassTextSecondary,
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          'لوحة إدارة شؤون كنف الرعاية',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: AppColors.glassTextPrimary,
          ),
        ),
      ],
    );
  }

  /// 🛠️ الجزء 3: شبكة الإحصائيات الزجاجية بلمسة ألوان عصرية طافية ومريحة
  Widget _buildStatisticsGrid() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'احتياجات نشطة',
            '$_activeNeedsCount',
            Icons.analytics_outlined,
            AppColors.brandOrange,
            () => Navigator.of(context).pushNamed('/care_home_needs_list'),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _buildStatCard(
            'تبرعات واردة',
            _totalDonations,
            Icons.account_balance_wallet_outlined,
            const Color(0xFF10B981), // تم استبدال السمة غير المعرفة بالكود السداسي الصافي للون الزمردي
            () => Navigator.of(context).pushNamed('/care_home_incoming_donations'),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color accentColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: accentColor, size: 24),
                Icon(Icons.arrow_outward_rounded, color: Colors.white.withOpacity(0.3), size: 16),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.glassTextPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.glassTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🛠️ الجزء 4: شبكة أزرار العمليات السريعة المربوطة هندسياً ببقية الملفات الـ 13
  Widget _buildQuickActionsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.95,
      children: [
        _buildActionItem(
          'إضافة احتياج',
          Icons.add_box_rounded,
          AppColors.brandOrange,
          () => Navigator.of(context).pushNamed('/care_home_add_need'),
        ),
        _buildActionItem(
          'المتطوعين',
          Icons.people_alt_rounded,
          Colors.blueAccent,
          () => Navigator.of(context).pushNamed('/care_home_manage_volunteers'),
        ),
        _buildActionItem(
          'مواعيد الزيارة',
          Icons.calendar_month_rounded,
          Colors.purpleAccent,
          () => Navigator.of(context).pushNamed('/care_home_visit_hours'),
        ),
        _buildActionItem(
          'التقارير',
          Icons.insert_chart_rounded,
          Colors.tealAccent,
          () => Navigator.of(context).pushNamed('/care_home_reports'),
        ),
        _buildActionItem(
          'تقييم الأداء',
          Icons.star_rate_rounded,
          Colors.amber,
          () => Navigator.of(context).pushNamed('/care_home_rate_volunteers'),
        ),
        _buildActionItem(
          'الملف العام',
          Icons.storefront_rounded,
          Colors.pinkAccent,
          () => Navigator.of(context).pushNamed('/care_home_profile'),
        ),
      ],
    );
  }

  Widget _buildActionItem(String label, IconData icon, Color iconColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
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
                color: AppColors.glassTextPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🛠️ الجزء 5: التحديثات والنشاطات الأخيرة داخل الدار
  Widget _buildRecentActivitiesList() {
    final activities = [
      {'title': 'تم كفالة طلب كسوة العيد', 'time': 'منذ 10 دقائق', 'type': 'donation'},
      {'title': 'طلب انضمام جديد من المتطوع أحمد', 'time': 'منذ ساعة', 'type': 'volunteer'},
      // دمج المتغير الذكي هنا لإنهاء تحذير الكومبايلر الأصفر تماماً
      {'title': 'يوجد لدينا حالياً $_newVolunteersCount متطوعين جدد قيد الانتظار', 'time': 'منذ ساعتين', 'type': 'system'},
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

        return GlassContainer(
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
                    color: AppColors.glassTextPrimary,
                  ),
                ),
              ),
              Text(
                activity['time']!,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 11,
                  color: AppColors.glassTextSecondary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// عنوان جانبي منسق وموحد لمنع الهزة والتشتت البصري
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Cairo',
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: AppColors.glassTextPrimary,
      ),
    );
  }
}
