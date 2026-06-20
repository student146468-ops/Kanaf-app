import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../widgets/glass_container.dart';

/// [IncomingDonationsScreen] - الواجهة رقم 33: إدارة وتدقيق التبرعات الواردة لدار الرعاية لعام 2026.
/// مصممة بنقاء هيكلي فخم لعرض وتتبع التبرعات المالية والعينية الواردة لفرع غريان وفحصها فورياً.
class IncomingDonationsScreen extends StatefulWidget {
  const IncomingDonationsScreen({super.key});

  @override
  State<IncomingDonationsScreen> createState() => _IncomingDonationsScreenState();
}

class _IncomingDonationsScreenState extends State<IncomingDonationsScreen> {
  String _selectedTypeFilter = 'الكل'; // الفلتر المختار: الكل، مالي، عيني

  // بيانات محاكاة تفصيلية ومقنعة لعمليات دعم حقيقية داخل تطبيق "كَنَفْ" لإبهار المناقشين والمهندسة رحاب
  final List<Map<String, dynamic>> _donations = [
    {
      'id': 'd1',
      'donor': 'مؤسسة غريان الخيرية',
      'type': 'مالي',
      'amount': '2,500 د.ل',
      'details': 'دعم مالي مخصص لتغطية مصاريف الرعاية الطبية الدورية للأطفال',
      'date': '2026-06-02',
      'is_received': true,
    },
    {
      'id': 'd2',
      'donor': 'أهل الخير - بريد غريان',
      'type': 'عيني',
      'amount': '30 طقم ملابس',
      'details': 'كسوة وأحذية مودرن مخصصة لأعمار الروضة والابتدائي للدار',
      'date': '2026-06-01',
      'is_received': true,
    },
    {
      'id': 'd3',
      'donor': 'شركة النماء للمواد الغذائية',
      'type': 'عيني',
      'amount': '50 صندوق سلع',
      'details': 'مواد تموينية أساسية وحليب أطفال قيد الفرز والتحقق بالمخزن',
      'date': '2026-05-30',
      'is_received': false, // قيد التحقق والفرز الفوري
    },
    {
      'id': 'd4',
      'donor': 'فاعل خير مستقل',
      'type': 'مالي',
      'amount': '1,750 د.ل',
      'details': 'زكاة مال مخصصة لكفالة المصاريف الدراسية والكتب للأيتام',
      'date': '2026-05-28',
      'is_received': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWebOrDesktop = size.width > 600;
    final containerWidth = isWebOrDesktop ? 420.0 : double.infinity;

    // فلترة التبرعات ديناميكياً وفق التخصص المختار لمنع التشتت البصري للمشرف
    final filteredDonations = _donations.where((d) {
      if (_selectedTypeFilter == 'الكل') return true;
      return d['type'] == _selectedTypeFilter;
    }).toList();

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
                // الخلفية الكريستالية الحية المستقرة للتطبيق
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

                // توزيع المحتوى والهيكل البرمجي المريح للعين والمضاد للتشتت
                SafeArea(
                  child: Column(
                    children: [
                      _buildAppBar(),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                          child: Column(
                            // تم إصلاح السطر 120 هنا بحذف كلمة cross الزائدة
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSummaryCard(),
                              const SizedBox(height: 24),
                              _buildFilterTabs(),
                              const SizedBox(height: 14),
                              filteredDonations.isEmpty
                                  ? _buildEmptyState()
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: filteredDonations.length,
                                      itemBuilder: (context, index) {
                                        final donation = filteredDonations[index];
                                        return _buildDonationCard(donation);
                                      },
                                    ),
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
            'سجل التبرعات الواردة',
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

  Widget _buildSummaryCard() {
    return GlassContainer(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.brandOrange.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.account_balance_wallet_rounded, color: AppColors.brandOrange, size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'إجمالي الدعم المالي المستلم',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: AppColors.glassTextSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '4,250 د.ل',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: AppColors.glassTextPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'بالإضافة إلى شحنات الدعم العيني الموثقة بالمخازن.',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11,
                    color: const Color(0xFF10B981).withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    final tabs = ['الكل', 'مالي', 'عيني'];
    return Row(
      children: tabs.map((tab) {
        final isSelected = _selectedTypeFilter == tab;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedTypeFilter = tab),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 38,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.brandOrange.withOpacity(0.18) : Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppColors.brandOrange : Colors.white.withOpacity(0.08),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  tab,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12.5,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    color: isSelected ? AppColors.brandOrange : AppColors.glassTextPrimary,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDonationCard(Map<String, dynamic> donation) {
    final bool isMoney = donation['type'] == 'مالي';
    final Color badgeColor = donation['is_received'] ? const Color(0xFF10B981) : Colors.orangeAccent;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GlassContainer(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      isMoney ? Icons.monetization_on_rounded : Icons.inventory_2_rounded,
                      color: isMoney ? Colors.amber : Colors.tealAccent,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      donation['donor'],
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.glassTextPrimary,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: badgeColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: badgeColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    donation['is_received'] ? 'تم الاستلام' : 'قيد الفرز والتحقق',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: badgeColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'مقدار الدعم: ${donation['amount']}',
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.brandOrange,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              donation['details'],
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12.5,
                color: AppColors.glassTextSecondary,
              ),
            ),
            const Divider(color: Colors.white12, height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'تاريخ العملية: ${donation['date']}',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
                if (!donation['is_received'])
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        donation['is_received'] = true;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('تم تأكيد الفحص اليدوي وإضافتها للمخازن بنجاح', style: TextStyle(fontFamily: 'Cairo')),
                          backgroundColor: Color(0xFF10B981),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.brandOrange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'تأكيد الفرز والقبول',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.brandOrangeDark,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          Icon(Icons.receipt_long_rounded, size: 50, color: Colors.white.withOpacity(0.15)),
          const SizedBox(height: 12),
          Text(
            'لا توجد عمليات دعم مسجلة تحت هذا التصنيف',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13.5,
              color: AppColors.glassTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
