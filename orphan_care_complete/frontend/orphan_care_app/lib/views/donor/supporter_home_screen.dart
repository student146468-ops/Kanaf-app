import 'package:flutter/material.dart';
import '../../utils/app_colors.dart'; // تأكدي من صحة المسار لملف الألوان الخاص بكِ

class SupporterHomeScreen extends StatefulWidget {
  const SupporterHomeScreen({super.key});

  @override
  State<SupporterHomeScreen> createState() => _SupporterHomeScreenState();
}

class _SupporterHomeScreenState extends State<SupporterHomeScreen> {
  String _selectedCategory = 'الكل';

  // قائمة الفئات المودرن مع الأيقونات المتوافقة مع طبيعة كنف
  final List<Map<String, dynamic>> _categories = [
    {'title': 'الكل', 'icon': Icons.grid_view_rounded},
    {'title': 'مالي', 'icon': Icons.account_balance_wallet_rounded},
    {'title': 'غذائي', 'icon': Icons.restaurant_rounded},
    {'title': 'كساء', 'icon': Icons.checkroom_rounded},
    {'title': 'صحي', 'icon': Icons.volunteer_activism_rounded},
  ];

  // بيانات الحالات التجريبية الاحترافية المليئة بالهوية الليبية المحلية
  final List<Map<String, dynamic>> _needsData = [
    {
      'id': '1',
      'orphanage': 'دار رعاية الأيتام - غريان',
      'category': 'مالي',
      'title': 'تأمين المصاريف الدراسية والجامعية لـ 5 طلاب متميزين من أيتام الدار لفصل الخريف',
      'progress': 0.65,
      'raised': '3,250 د.ل',
      'target': '5,000 د.ل',
      'urgency': 'عاجل جداً',
      'daysLeft': '3 أيام',
    },
    {
      'id': '2',
      'orphanage': 'جمعية كَنَفْ للأطفال - غريان',
      'category': 'غذائي',
      'title': 'توفير السلات الغذائية الرمضانية المتكاملة لـ 30 عائلة من عائلات الأيتام المكفولة',
      'progress': 0.40,
      'raised': '1,600 د.ل',
      'target': '4,000 د.ل',
      'urgency': 'متوسط',
      'daysLeft': '12 يوم',
    },
    {
      'id': '3',
      'orphanage': 'بيت الأمل للبنين - غريان',
      'category': 'كساء',
      'title': 'توفير ملابس العيد والكسوة الشتوية لـ 25 طفلاً من المقيمين داخل الدار',
      'progress': 0.85,
      'raised': '5,100 د.ل',
      'target': '6,000 د.ل',
      'urgency': 'عاجل',
      'daysLeft': '5 أيام',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // تصفية الحالات تلقائياً بناءً على الفرز المختيار
    final filteredNeeds = _selectedCategory == 'الكل'
        ? _needsData
        : _needsData.where((need) => need['category'] == _selectedCategory).toList();

    return Directionality(
      textDirection: TextDirection.rtl, // المحاذاة الشاملة لليمين لمنع عيوب الاتجاه
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: _buildPremiumAppBar(),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeroWelcome(),
              _buildModernFilterBar(),
              _buildSectionTitle(filteredNeeds.length),
              Expanded(
                child: filteredNeeds.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        itemCount: filteredNeeds.length,
                        itemBuilder: (context, index) {
                          return _buildPremiumNeedCard(filteredNeeds[index]);
                        },
                      ),
              ),
            ],
          ),
        ),
        // 💎 هـ) إضافة شريط التنقل السفلي لربط الانتقال إلى الحساب الشخصي
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0, // الصفحة الحالية هي الرئيسية (الرقم 0)
          selectedItemColor: AppColors.brandOrange,
          unselectedItemColor: AppColors.textDarkSecondary,
          selectedLabelStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 12),
          onTap: (index) {
            if (index == 1) {
              // عند الضغط على الأيقونة الثانية ينتقل لصفحة الملف الشخصي
              Navigator.pushNamed(context, '/profile');
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'الحساب الشخصي',
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildPremiumAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      title: const Row(
        children: [
          Icon(Icons.volunteer_activism_rounded, color: AppColors.brandOrange, size: 24),
          SizedBox(width: 8),
          Text(
            'رئيسية العطاء',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: AppColors.textDarkPrimary,
            ),
          ),
        ],
      ),
      actions: [
        // 💎 ب) ربط أيقونة البحث بواجهة الفلترة والبحث المتقدم
        IconButton(
          icon: const Icon(Icons.search_rounded, color: AppColors.textDarkSecondary),
          onPressed: () {
            Navigator.pushNamed(context, '/search_filter');
          },
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            // 💎 أ) ربط أيقونة الجرس بواجهة الإشعارات المركزية
            IconButton(
              icon: const Icon(Icons.notifications_none_rounded, color: AppColors.textDarkSecondary),
              onPressed: () {
                Navigator.pushNamed(context, '/notifications');
              },
            ),
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(color: AppColors.brandOrange, shape: BoxShape.circle),
              ),
            )
          ],
        ),
        const SizedBox(width: 10),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(color: AppColors.innerBorder, height: 1.0),
      ),
    );
  }

  Widget _buildHeroWelcome() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.orangeGradient,
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.brandOrange.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'مرحباً بك في كَنَفْ يا باغي الخير 👋',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'مساهمتك الإنسانية اليوم تصنع فارقاً حقيقياً ومستداماً في حياة أطفالنا وتدعم مسيرتهم نحو مستقبل أفضل.',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.glassTextSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernFilterBar() {
    return SizedBox(
      height: 46,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final bool isSelected = _selectedCategory == category['title'];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: InkWell(
              onTap: () => setState(() => _selectedCategory = category['title']),
              borderRadius: BorderRadius.circular(16),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.brandOrange : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? AppColors.brandOrange : AppColors.innerBorder,
                    width: 1.2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      category['icon'],
                      size: 16,
                      color: isSelected ? Colors.white : AppColors.textDarkSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      category['title'],
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                        color: isSelected ? Colors.white : AppColors.textDarkSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'الاحتياجات الحالية القائمة',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 15.5,
              fontWeight: FontWeight.bold,
              color: AppColors.textDarkPrimary,
            ),
          ),
          Text(
            '($count حالة)',
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.brandOrange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumNeedCard(Map<String, dynamic> need) {
    bool isUrgent = need['urgency'] == 'عاجل جداً' || need['urgency'] == 'عاجل';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.innerBorder, width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 💎 ج) ربط اسم الدار ليتفاعل وينتقل لصفحة بروفايل دار الرعاية
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/orphanage_profile');
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                    child: Row(
                      children: [
                        const Icon(Icons.home_work_rounded, color: AppColors.brandOrange, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          need['orphanage'],
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDarkSecondary,
                            decoration: TextDecoration.underline, // إشارة للمستخدم أنه كرت قابل للضغط
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isUrgent ? const Color(0xFFFDF0EA) : AppColors.innerBorder,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    need['urgency'],
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isUrgent ? AppColors.brandOrange : AppColors.textDarkSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              need['title'],
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textDarkPrimary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('تم جمع: ${need['raised']}', style: const TextStyle(fontFamily: 'Cairo', fontSize: 12, color: AppColors.textDarkSecondary)),
                Text('الهدف: ${need['target']}', style: const TextStyle(fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.brandOrangeDark)),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: need['progress'],
              backgroundColor: AppColors.innerBorder,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.brandOrange),
              minHeight: 6,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded, color: AppColors.textDarkMuted, size: 14),
                    const SizedBox(width: 4),
                    Text('متبقي: ${need['daysLeft']}', style: const TextStyle(fontFamily: 'Cairo', fontSize: 11.5, color: AppColors.textDarkMuted)),
                  ],
                ),
                // 💎 د) ربط زر "تفاصيل الحالة" لينتقل بالمسار المعتمد في الـ main.dart
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandOrange,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  onPressed: () {
                    // تم تعديلها هنا لتطابق المسار المعتمد بالاسم داخل الـ main.dart لرحلة تصفح متكاملة
                    Navigator.pushNamed(context, '/need_details');
                  },
                  child: const Text(
                    'تفاصيل الحالة',
                    style: TextStyle(fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.volunteer_activism_outlined, size: 48, color: AppColors.textDarkMuted),
          SizedBox(height: 12),
          Text(
            'لا توجد احتياجات قائمة حالياً في هذه الفئة.',
            style: TextStyle(fontFamily: 'Cairo', fontSize: 14, color: AppColors.textDarkSecondary),
          ),
        ],
      ),
    );
  }
}
