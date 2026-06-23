import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import 'care_home_light_widgets.dart';

/// [RateVolunteersScreen] - الواجهة رقم 34: تقييم وتكريم المتطوعين لدار الرعاية لعام 2026.
/// تتيح للمشرفين تقييم أداء المتطوعين بنظام النجوم المتوهجة وإسناد أوسمة تميز تفاعلية وواضحة.
class RateVolunteersScreen extends StatefulWidget {
  const RateVolunteersScreen({super.key});

  @override
  State<RateVolunteersScreen> createState() => _RateVolunteersScreenState();
}

class _RateVolunteersScreenState extends State<RateVolunteersScreen> {
  int _ratingScore = 5; // التقييم الافتراضي بالنجوم
  String _selectedBadge = 'متميز لغوياً'; // الوسام المختار افتراضياً
  final TextEditingController _notesController = TextEditingController();

  // بيانات المتطوع المستهدف بالتقييم إلى حين تمرير بيانات حقيقية من شاشة الإدارة.
  final Map<String, dynamic> _targetVolunteer = {
    'id': 'v1',
    'name': 'أحمد علي الساعدي',
    'role': 'تعليمي',
    'sub_role': 'مدرس لغة إنجليزية ودعم دراسي للأطفال',
    'duration': '3 أشهر تطوع مستمر',
  };

  // قائمة الأوسمة التقديرية واضحة والمناسبة لطبيعة دور الرعاية
  final List<Map<String, dynamic>> _appreciationBadges = [
    {
      'name': 'متميز لغوياً',
      'icon': Icons.g_translate_rounded,
      'color': const Color(0xFF3B82F6)
    },
    {
      'name': 'قائد مؤثر',
      'icon': Icons.auto_awesome_rounded,
      'color': Colors.amber
    },
    {
      'name': 'صديق الطفولة',
      'icon': Icons.child_care_rounded,
      'color': const Color(0xFF10B981)
    },
    {
      'name': 'ملتزم ومثالي',
      'icon': Icons.verified_user_rounded,
      'color': const Color(0xFF8B5CF6)
    },
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWebOrDesktop = size.width > 600;
    final containerWidth = isWebOrDesktop ? 420.0 : double.infinity;

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
                          blurRadius: 45,
                          spreadRadius: 8)
                    ]
                  : [],
            ),
            child: Stack(
              children: [
                // خلفية بيضاء هادئة الموحدة لتطبيق كَنَفْ
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
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white,
                          Colors.white,
                        ],
                      ),
                    ),
                  ),
                ),

                // محتوى صفحة التقييم الموزع باحترافية لإراحة العين
                SafeArea(
                  child: Column(
                    children: [
                      _buildAppBar(),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 22.0, vertical: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildVolunteerHeaderCard(),
                              const SizedBox(height: 24),
                              _buildSectionTitle(
                                  'التقييم العام بالأداء الميداني'),
                              const SizedBox(height: 14),
                              _buildStarsRatingBar(),
                              const SizedBox(height: 24),
                              _buildSectionTitle('منح وسام التميز السنوي'),
                              const SizedBox(height: 14),
                              _buildBadgesGrid(),
                              const SizedBox(height: 24),
                              _buildSectionTitle(
                                  'ملاحظات وتوصيات إضافية لوثيقته'),
                              const SizedBox(height: 14),
                              _buildNotesInputField(),
                              const SizedBox(height: 35),
                              _buildSubmitButton(),
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

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.innerBorder),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: AppColors.textDarkPrimary, size: 18),
            ),
          ),
          const Text(
            'تقييم أداء المتطوع',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDarkPrimary,
            ),
          ),
          const SizedBox(width: 40), // لضمان التوازن البصري التام في الـ AppBar
        ],
      ),
    );
  }

  Widget _buildVolunteerHeaderCard() {
    return CareHomeCard(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.brandOrange.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(
                  color: AppColors.brandOrange.withOpacity(0.3), width: 1.5),
            ),
            child: const Icon(Icons.person_outline_rounded,
                color: AppColors.brandOrange, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _targetVolunteer['name'],
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDarkPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${_targetVolunteer['sub_role']} • ${_targetVolunteer['duration']}',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
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

  Widget _buildStarsRatingBar() {
    return CareHomeCard(
      padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 12.0),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            int starValue = 5 -
                index; // ليعمل نظام النجوم من اليمين إلى اليسار بشكل لائق مع لغتنا العربية
            bool isSelected = starValue <= _ratingScore;

            return GestureDetector(
              onTap: () => setState(() => _ratingScore = starValue),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 6),
                transform: isSelected
                    ? Matrix4.identity().scaled(1.1)
                    : Matrix4.identity(),
                child: Icon(
                  isSelected ? Icons.star_rounded : Icons.star_border_rounded,
                  color: isSelected ? Colors.amber : AppColors.innerBorder,
                  size: 38,
                  shadows: isSelected
                      ? [const Shadow(color: Colors.amber, blurRadius: 10)]
                      : [],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildBadgesGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.3,
      ),
      itemCount: _appreciationBadges.length,
      itemBuilder: (context, index) {
        final badge = _appreciationBadges[index];
        final bool isSelected = _selectedBadge == badge['name'];

        return GestureDetector(
          onTap: () => setState(() => _selectedBadge = badge['name']),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            decoration: BoxDecoration(
              color: isSelected
                  ? badge['color'].withOpacity(0.18)
                  : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? badge['color'] : AppColors.cardBackground,
                width: isSelected ? 1.5 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                          color: badge['color'].withOpacity(0.1), blurRadius: 8)
                    ]
                  : [],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(badge['icon'],
                    color: isSelected
                        ? badge['color']
                        : AppColors.textDarkSecondary,
                    size: 20),
                const SizedBox(width: 8),
                Text(
                  badge['name'],
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12.5,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    color: isSelected
                        ? AppColors.textDarkPrimary
                        : AppColors.textDarkSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotesInputField() {
    return CareHomeCard(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: TextField(
        controller: _notesController,
        maxLines: 3,
        style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 13.5,
            color: AppColors.textDarkPrimary),
        decoration: InputDecoration(
          hintText: 'اكتبي هنا ثناءً خاصاً أو ملاحظات تضاف لملفه الشخصي...',
          hintStyle: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 12.5,
              color: AppColors.textDarkMuted),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return GestureDetector(
      onTap: () {
        // تفاعل الحفظ الفوري وبناء الـ SnackBar المتناسق وخالي الأخطاء
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم اعتماد التقييم ومنح وسام التميز بنجاح ✅',
                style: TextStyle(fontFamily: 'Cairo')),
            backgroundColor:
                Color(0xFF10B981), // الزمردي الصريح والآمن للكومبايلر
          ),
        );
        Navigator.of(context)
            .pop(); // العودة التلقائية لواجهة إدارة المتطوعين المربوطة بها
      },
      child: Container(
        height: 52,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.brandOrange,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: AppColors.brandOrange.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 4)),
          ],
        ),
        child: const Center(
          child: Text(
            'حفظ واعتماد التقييم التكريمي',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Cairo',
        fontSize: 14,
        fontWeight: FontWeight.w800,
        color: AppColors.textDarkPrimary,
      ),
    );
  }
}
