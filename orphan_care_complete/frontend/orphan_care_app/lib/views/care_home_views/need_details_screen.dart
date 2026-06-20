import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../widgets/glass_container.dart';

/// [NeedDetailsScreen] - الواجهة رقم 30: تفاصيل احتياج + تتبع حالته لدار الرعاية لعام 2026.
/// تحتوي على شريط تتبع انسيابي للمراحل اللوجستية وبطاقة تفصيلية عن حالة الكفالة.
class NeedDetailsScreen extends StatefulWidget {
  const NeedDetailsScreen({super.key});

  @override
  State<NeedDetailsScreen> createState() => _NeedDetailsScreenState();
}

// تم تصحيح السطر هنا ليكون متوافقاً تماماً مع اسم الواجهة الأساسية
class _NeedDetailsScreenState extends State<NeedDetailsScreen> {
  // بيانات محاكاة تفصيلية للطلب المختار لعرضها أمام لجنة التحكيم
  final Map<String, dynamic> _needDetails = {
    'id': '1',
    'title': 'حليب أطفال ومكملات غذائية (عمر 1-3)',
    'category': 'غذائي',
    'quantity': '40 صندوق متكامل',
    'priority': 'حرج جداً',
    'current_step': 2, // الخطوة الحالية: 0 = تم النشر، 1 = تم التكفل، 2 = قيد التوصيل، 3 = تم الاستلام
    'date_published': '2026-06-01',
    'details': 'نظراً لزيادة عدد الأطفال الرضع المسجلين حديثاً بالدار بفرع غريان، نحتاج بشكل عاجل لتوفير حليب من الأصناف المدعمة طبياً لتغطية النقص الحالي.',
    'sponsor_name': 'المهندس عبد الرحمن محمد (متبرع دائم)',
    'sponsor_phone': '091-XXXXXXX',
  };

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWebOrDesktop = size.width > 600;
    final containerWidth = isWebOrDesktop ? 420.0 : double.infinity;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF131313),
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
                // الخلفية الكريستالية الحية للتطبيق
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
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.black.withOpacity(0.92),
                        ],
                      ),
                    ),
                  ),
                ),

                // محتوى تفاصيل الطلب والتتبع اللوجستي
                SafeArea(
                  child: Column(
                    children: [
                      _buildAppBar(),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildMainInfoCard(),
                              const SizedBox(height: 24),
                              _buildSectionTitle('مسار تتبع حالة الاحتياج'),
                              const SizedBox(height: 14),
                              _buildTrackingTimeline(),
                              const SizedBox(height: 24),
                              _buildSectionTitle('بيانات جهة الكفالة والدعم'),
                              const SizedBox(height: 14),
                              _buildSponsorCard(),
                              const SizedBox(height: 35),
                              _buildActionButtons(),
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
                color: Colors.white.withOpacity(0.08),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.15)),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
            ),
          ),
          const Text(
            'تفاصيل الاحتياج والتتبع',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.glassTextPrimary,
            ),
          ),
          const SizedBox(width: 40), 
        ],
      ),
    );
  }

  Widget _buildMainInfoCard() {
    return GlassContainer(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
                ),
                child: Text(
                  _needDetails['priority'],
                  style: const TextStyle(fontFamily: 'Cairo', fontSize: 11, fontWeight: FontWeight.bold, color: Colors.redAccent),
                ),
              ),
              Text(
                'تاريخ النشر: ${_needDetails['date_published']}',
                style: TextStyle(fontFamily: 'Cairo', fontSize: 11.5, color: AppColors.glassTextSecondary),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            _needDetails['title'],
            style: const TextStyle(fontFamily: 'Cairo', fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.glassTextPrimary),
          ),
          const SizedBox(height: 6),
          Text(
            'الكمية المطلوبة: ${_needDetails['quantity']}',
            style: const TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.brandOrange),
          ),
          const Divider(color: Colors.white12, height: 24),
          Text(
            _needDetails['details'],
            style: TextStyle(fontFamily: 'Cairo', fontSize: 13, color: AppColors.glassTextSecondary, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingTimeline() {
    final steps = ['تم النشر', 'تم التكفل به', 'قيد التوصيل', 'تم الاستلام'];
    int currentStep = _needDetails['current_step'];

    return GlassContainer(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: List.generate(steps.length, (index) {
          bool isCompleted = index <= currentStep;
          bool isCurrent = index == currentStep;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // عمود الرسم البياني اللوجستي للتتبع
              Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isCompleted ? AppColors.brandOrange : Colors.white.withOpacity(0.05),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCompleted ? AppColors.brandOrange : Colors.white.withOpacity(0.2),
                        width: 2,
                      ),
                      boxShadow: isCurrent
                          ? [BoxShadow(color: AppColors.brandOrange.withOpacity(0.4), blurRadius: 8, spreadRadius: 1)]
                          : [],
                    ),
                    child: isCompleted
                        ? const Icon(Icons.check_rounded, color: AppColors.brandOrangeDark, size: 14)
                        : null,
                  ),
                  if (index != steps.length - 1)
                    Container(
                      width: 2,
                      height: 36,
                      color: index < currentStep ? AppColors.brandOrange : Colors.white.withOpacity(0.12),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              // نصوص المراحل التتبعية للعمليات الخيرية
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        steps[index],
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 13.5,
                          fontWeight: isCompleted ? FontWeight.bold : FontWeight.w500,
                          color: isCompleted ? AppColors.glassTextPrimary : AppColors.glassTextSecondary,
                        ),
                      ),
                      if (isCurrent)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            'يجري تحديث الحالة حالياً بواسطة الكفيل والمندوب.',
                            style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: AppColors.brandOrange.withOpacity(0.8)),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildSponsorCard() {
    return GlassContainer(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.15), 
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.volunteer_activism_rounded, color: Color(0xFF10B981), size: 22), 
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _needDetails['sponsor_name'],
                  style: const TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.glassTextPrimary),
                ),
                const SizedBox(height: 2),
                Text(
                  'رقم التواصل: ${_needDetails['sponsor_phone']}',
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 12, color: AppColors.glassTextSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        // زر التعديل المربوط برمجياً بالواجهة رقم 31
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pushNamed('/care_home_edit_need', arguments: _needDetails['id']),
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.15)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.edit_note_rounded, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text('تعديل البيانات', style: TextStyle(fontFamily: 'Cairo', fontSize: 14.5, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // زر تأكيد الاستلام النهائي وإغلاق الطلب
        Expanded(
          child: GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم تأكيد استلام الدعم وإغلاق الطلب بنجاح', style: TextStyle(fontFamily: 'Cairo')), 
                  backgroundColor: Color(0xFF10B981), 
                ),
              );
              Navigator.of(context).pop();
            },
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.glassBtnActive,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.archive_rounded, color: AppColors.brandOrangeDark, size: 20),
                  SizedBox(width: 8),
                  Text('تأكيد الاستلام', style: TextStyle(fontFamily: 'Cairo', fontSize: 14.5, fontWeight: FontWeight.bold, color: AppColors.brandOrangeDark)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontFamily: 'Cairo', fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.glassTextPrimary),
    );
  }
}
