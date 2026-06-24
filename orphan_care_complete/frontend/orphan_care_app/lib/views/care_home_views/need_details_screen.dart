import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import 'care_home_light_widgets.dart';

/// [NeedDetailsScreen] - ط§ظ„ظˆط§ط¬ظ‡ط© ط±ظ‚ظ… 30: طھظپط§طµظٹظ„ ط§ط­طھظٹط§ط¬ + طھطھط¨ط¹ ط­ط§ظ„طھظ‡ ظ„ط¯ط§ط± ط§ظ„ط±ط¹ط§ظٹط© ظ„ط¹ط§ظ… 2026.
/// طھط­طھظˆظٹ ط¹ظ„ظ‰ ط´ط±ظٹط· طھطھط¨ط¹ ط§ظ†ط³ظٹط§ط¨ظٹ ظ„ظ„ظ…ط±ط§ط­ظ„ ط§ظ„ظ„ظˆط¬ط³طھظٹط© ظˆط¨ط·ط§ظ‚ط© طھظپطµظٹظ„ظٹط© ط¹ظ† ط­ط§ظ„ط© ط§ظ„ظƒظپط§ظ„ط©.
class NeedDetailsScreen extends StatefulWidget {
  const NeedDetailsScreen({super.key});

  @override
  State<NeedDetailsScreen> createState() => _NeedDetailsScreenState();
}

// طھظ… طھطµط­ظٹط­ ط§ظ„ط³ط·ط± ظ‡ظ†ط§ ظ„ظٹظƒظˆظ† ظ…طھظˆط§ظپظ‚ط§ظ‹ طھظ…ط§ظ…ط§ظ‹ ظ…ط¹ ط§ط³ظ… ط§ظ„ظˆط§ط¬ظ‡ط© ط§ظ„ط£ط³ط§ط³ظٹط©
class _NeedDetailsScreenState extends State<NeedDetailsScreen> {
  // TODO: Replace mock need details with selected AppProvider/backend need data.
  final Map<String, dynamic> _needDetails = {
    'id': '1',
    'title': 'حليب أطفال ومكملات غذائية',
    'category': 'غذائي',
    'quantity': '40 صندوق',
    'priority': 'عاجل',
    'current_step':
        2, // ط§ظ„ط®ط·ظˆط© ط§ظ„ط­ط§ظ„ظٹط©: 0 = طھظ… ط§ظ„ظ†ط´ط±طŒ 1 = طھظ… ط§ظ„طھظƒظپظ„طŒ 2 = ظ‚ظٹط¯ ط§ظ„طھظˆطµظٹظ„طŒ 3 = طھظ… ط§ظ„ط§ط³طھظ„ط§ظ…
    'date_published': '2026-06-01',
    'details':
        'نحتاج إلى توفير كمية مناسبة من حليب الأطفال لتغطية النقص الحالي داخل الدار، مع إعطاء الأولوية للأعمار الصغيرة.',
    'sponsor_name': 'فاعل خير دائم',
    'sponsor_phone': '091-XXXXXXX',
  };

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWebOrDesktop = size.width > 600;
    final containerWidth = isWebOrDesktop ? 430.0 : double.infinity;
    final routeNeedId = ModalRoute.of(context)?.settings.arguments;
    final needDetails = {
      ..._needDetails,
      if (routeNeedId != null) 'id': routeNeedId.toString(),
    };

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
                // ط®ظ„ظپظٹط© ط¨ظٹط¶ط§ط، ظ‡ط§ط¯ط¦ط© ظ„ظ„طھط·ط¨ظٹظ‚
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

                // ظ…ط­طھظˆظ‰ طھظپط§طµظٹظ„ ط§ظ„ط·ظ„ط¨ ظˆط§ظ„طھطھط¨ط¹ ط§ظ„ظ„ظˆط¬ط³طھظٹ
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
                              _buildMainInfoCard(needDetails),
                              const SizedBox(height: 24),
                              _buildSectionTitle('مسار تلبية الاحتياج'),
                              const SizedBox(height: 14),
                              _buildTrackingTimeline(needDetails),
                              const SizedBox(height: 24),
                              _buildSectionTitle('بيانات جهة الدعم'),
                              const SizedBox(height: 14),
                              _buildSponsorCard(needDetails),
                              const SizedBox(height: 35),
                              _buildActionButtons(needDetails),
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
            'تفاصيل الاحتياج',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDarkPrimary,
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildMainInfoCard(Map<String, dynamic> needDetails) {
    return CareHomeCard(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
                ),
                child: Text(
                  needDetails['priority'],
                  style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent),
                ),
              ),
              Text(
                'تاريخ النشر: ${needDetails['date_published']}',
                style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11.5,
                    color: AppColors.textDarkSecondary),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            needDetails['title'],
            style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppColors.textDarkPrimary),
          ),
          const SizedBox(height: 6),
          Text(
            'الكمية المطلوبة: ${needDetails['quantity']}',
            style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.brandOrange),
          ),
          const Divider(color: AppColors.divider, height: 24),
          Text(
            needDetails['details'],
            style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13,
                color: AppColors.textDarkSecondary,
                height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingTimeline(Map<String, dynamic> needDetails) {
    final steps = ['تم النشر', 'تم التكفل', 'قيد التوصيل', 'تم الاستلام'];
    int currentStep = needDetails['current_step'];

    return CareHomeCard(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: List.generate(steps.length, (index) {
          bool isCompleted = index <= currentStep;
          bool isCurrent = index == currentStep;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ط¹ظ…ظˆط¯ ط§ظ„ط±ط³ظ… ط§ظ„ط¨ظٹط§ظ†ظٹ ط§ظ„ظ„ظˆط¬ط³طھظٹ ظ„ظ„طھطھط¨ط¹
              Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? AppColors.brandOrange
                          : AppColors.surfaceLight,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCompleted
                            ? AppColors.brandOrange
                            : AppColors.innerBorder,
                        width: 2,
                      ),
                      boxShadow: isCurrent
                          ? [
                              BoxShadow(
                                  color: AppColors.brandOrange.withOpacity(0.4),
                                  blurRadius: 8,
                                  spreadRadius: 1)
                            ]
                          : [],
                    ),
                    child: isCompleted
                        ? const Icon(Icons.check_rounded,
                            color: Colors.white, size: 14)
                        : null,
                  ),
                  if (index != steps.length - 1)
                    Container(
                      width: 2,
                      height: 36,
                      color: index < currentStep
                          ? AppColors.brandOrange
                          : AppColors.innerBorder,
                    ),
                ],
              ),
              const SizedBox(width: 16),
              // ظ†طµظˆطµ ط§ظ„ظ…ط±ط§ط­ظ„ ط§ظ„طھطھط¨ط¹ظٹط© ظ„ظ„ط¹ظ…ظ„ظٹط§طھ ط§ظ„ط®ظٹط±ظٹط©
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
                          fontWeight:
                              isCompleted ? FontWeight.bold : FontWeight.w500,
                          color: isCompleted
                              ? AppColors.textDarkPrimary
                              : AppColors.textDarkSecondary,
                        ),
                      ),
                      if (isCurrent)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            'تتم متابعة الحالة مع جهة الدعم والمندوب.',
                            style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 11,
                                color: AppColors.brandOrange.withOpacity(0.8)),
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

  Widget _buildSponsorCard(Map<String, dynamic> needDetails) {
    return CareHomeCard(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.volunteer_activism_rounded,
                color: Color(0xFF10B981), size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  needDetails['sponsor_name'],
                  style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDarkPrimary),
                ),
                const SizedBox(height: 2),
                Text(
                  'رقم التواصل: ${needDetails['sponsor_phone']}',
                  style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      color: AppColors.textDarkSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(Map<String, dynamic> needDetails) {
    return Row(
      children: [
        // ط²ط± ط§ظ„طھط¹ط¯ظٹظ„ ط§ظ„ظ…ط±ط¨ظˆط· ط¨ط±ظ…ط¬ظٹط§ظ‹ ط¨ط§ظ„ظˆط§ط¬ظ‡ط© ط±ظ‚ظ… 31
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pushNamed('/care_home_edit_need',
                arguments: needDetails['id']),
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.innerBorder),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.edit_note_rounded,
                      color: AppColors.textDarkPrimary, size: 20),
                  SizedBox(width: 8),
                  Text('تعديل البيانات',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDarkPrimary)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // ط²ط± طھط£ظƒظٹط¯ ط§ظ„ط§ط³طھظ„ط§ظ… ط§ظ„ظ†ظ‡ط§ط¦ظٹ ظˆط¥ط؛ظ„ط§ظ‚ ط§ظ„ط·ظ„ط¨
        Expanded(
          child: GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم تأكيد استلام الدعم وإغلاق الطلب بنجاح',
                      style: TextStyle(fontFamily: 'Cairo')),
                  backgroundColor: Color(0xFF10B981),
                ),
              );
              Navigator.of(context).pop();
            },
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.brandOrange,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.archive_rounded, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text('تأكيد الاستلام',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
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
      style: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 15,
          fontWeight: FontWeight.w800,
          color: AppColors.textDarkPrimary),
    );
  }
}
