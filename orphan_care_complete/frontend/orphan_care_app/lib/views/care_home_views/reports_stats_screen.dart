import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../widgets/glass_container.dart';

/// [ReportsStatsScreen] - الواجهة رقم 35: لوحة التقارير والتحليلات الذكية لدار الرعاية لعام 2026.
/// تعرض إحصائيات التبرعات المستلمة، ونسب تلبية الاحتياجات، ومستوى تفاعل المتطوعين برسوم بيانية وبطاقات زجاجية ثلاثية الأبعاد.
class ReportsStatsScreen extends StatefulWidget {
  const ReportsStatsScreen({super.key});

  @override
  State<ReportsStatsScreen> createState() => _ReportsStatsScreenState();
}

class _ReportsStatsScreenState extends State<ReportsStatsScreen> {
  String _selectedPeriod = 'هذا الشهر'; // هذا الشهر، هذا العام، الكلي

  // بيانات دقيقة ومحاكاة قوية لـ "تطبيق كَنَفْ" لإبهار المهندسة رحاب والمناقشين
  final Map<String, dynamic> _statsData = {
    'total_donations': '45,230 د.ل',
    'needs_fulfilled_rate': 88, // نسبة مئوية لطلب مخصص
    'active_volunteers': '34 متطوع',
    'children_sponsored': '112 طفل',
  };

  // توزيع نسب الاحتياجات الملبّاة لبناء رسم بياني شريطي نيون ومودرن
  final List<Map<String, dynamic>> _chartData = [
    {'label': 'غذائية', 'percentage': 0.95, 'color': const Color(0xFF10B981)},
    {'label': 'طبية', 'percentage': 0.82, 'color': const Color(0xFF3B82F6)},
    {'label': 'كسوة', 'percentage': 0.70, 'color': AppColors.brandOrange},
    {'label': 'تعليمية', 'percentage': 0.90, 'color': Colors.purpleAccent},
  ];

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
                // الخلفية الكريستالية الحية لتعزيز الهوية البصرية الموحدة
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
                          Colors.black.withOpacity(0.35),
                          Colors.black.withOpacity(0.94),
                        ],
                      ),
                    ),
                  ),
                ),

                // محتوى الإحصائيات والتقارير المنظم باحترافية
                SafeArea(
                  child: Column(
                    children: [
                      _buildAppBar(),
                      _buildPeriodFilter(),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildMainGridCards(),
                              const SizedBox(height: 24),
                              _buildSectionTitle('نسبة تلبية الاحتياجات حسب الفئة'),
                              const SizedBox(height: 14),
                              _buildNeonProgressBarChart(),
                              const SizedBox(height: 24),
                              _buildSectionTitle('تحميل التقارير الرسمية المعتمدة'),
                              const SizedBox(height: 14),
                              _buildDownloadReportCard('تقرير التبرعات الربع سنوي لعام 2026.pdf', 'تم التحديث منذ يومين'),
                              _buildDownloadReportCard('تقرير المستودع والاحتياجات اللوجستية.pdf', 'تم التحديث اليوم'),
                              const SizedBox(height: 25),
                              _buildNavigateToDashboardButton(),
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
            'التقارير والإحصائيات الحية',
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

  Widget _buildPeriodFilter() {
    final periods = ['هذا الشهر', 'هذا العام', 'الكلي'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
      child: Container(
        height: 42,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
        ),
        child: Row(
          children: periods.map((per) {
            final isSelected = _selectedPeriod == per;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedPeriod = per),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white.withOpacity(0.1) : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      per,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12.5,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                        color: isSelected ? AppColors.brandOrange : AppColors.glassTextSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMainGridCards() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.35,
      children: [
        _buildStatCard('إجمالي التبرعات', _statsData['total_donations'], Icons.account_balance_wallet_rounded, AppColors.brandOrange),
        _buildStatCard('تلبية الاحتياجات', '${_statsData['needs_fulfilled_rate']}%', Icons.analytics_rounded, const Color(0xFF10B981)),
        _buildStatCard('المتطوعين النشطين', _statsData['active_volunteers'], Icons.people_alt_rounded, const Color(0xFF3B82F6)),
        _buildStatCard('الأطفال المكفولين', _statsData['children_sponsored'], Icons.child_friendly_rounded, Colors.purpleAccent),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return GlassContainer(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 22),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              )
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 11.5,
              color: AppColors.glassTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNeonProgressBarChart() {
    return GlassContainer(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: _chartData.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item['label'],
                      style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.glassTextPrimary),
                    ),
                    Text(
                      '${(item['percentage'] * 100).toInt()}%',
                      style: TextStyle(fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.w800, color: item['color']),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Stack(
                  children: [
                    Container(
                      height: 7,
                      width: double.infinity,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.06), borderRadius: BorderRadius.circular(10)),
                    ),
                    FractionallySizedBox(
                      widthFactor: item['percentage'],
                      child: Container(
                        height: 7,
                        decoration: BoxDecoration(
                          color: item['color'],
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(color: item['color'].withOpacity(0.4), blurRadius: 6, spreadRadius: 1),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDownloadReportCard(String reportName, String updateTime) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.picture_as_pdf_rounded, color: Colors.redAccent, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reportName,
                    style: const TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.bold, color: AppColors.glassTextPrimary),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    updateTime,
                    style: TextStyle(fontFamily: 'Cairo', fontSize: 10.5, color: AppColors.glassTextSecondary.withOpacity(0.6)),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.file_download_rounded, color: AppColors.brandOrange, size: 22),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('جاري تحميل $reportName لفرع غريان...', style: const TextStyle(fontFamily: 'Cairo')),
                    backgroundColor: const Color(0xFF10B981),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigateToDashboardButton() {
    return GestureDetector(
      onTap: () {
        // الربط المباشر مع واجهة الـ Dashboard الرئيسية لتسهيل التصفح اللوجستي الفوري
        Navigator.of(context).pushNamed('/care_home_dashboard');
      },
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.dashboard_customize_rounded, color: AppColors.glassTextPrimary, size: 18),
              SizedBox(width: 8),
              Text(
                'العودة للوحة التحكم الرئيسية',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.glassTextPrimary,
                ),
              ),
            ],
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
        color: AppColors.glassTextPrimary,
      ),
    );
  }
}
