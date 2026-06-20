import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class OrphanageProfileScreen extends StatelessWidget {
  const OrphanageProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildSliverAppBar(context),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildQuickStatsRow(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('نبذة عن الدار'),
                    const SizedBox(height: 8),
                    _buildAboutCard(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('معلومات التواصل والموقع'),
                    const SizedBox(height: 8),
                    _buildContactCard(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('الاحتياجات الحالية للدار'),
                  ],
                ),
              ),
            ),
            _buildOrphanageNeedsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      backgroundColor: AppColors.brandOrange,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: const EdgeInsets.only(right: 20, bottom: 16),
        title: const Text(
          'دار رعاية الأيتام - غريان',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: AppColors.orangeGradient,
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Positioned(
              bottom: -20,
              left: -20,
              child: Icon(Icons.home_work_rounded, size: 180, color: Colors.white.withOpacity(0.08)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStatsRow() {
    return Row(
      children: [
        _buildStatItem('45 طفل', 'مقيم بالدار', Icons.child_care_rounded),
        const SizedBox(width: 12),
        _buildStatItem('12 حالة', 'مستعجلة', Icons.gavel_rounded),
        const SizedBox(width: 12),
        _buildStatItem('%88', 'نسبة الكفالة', Icons.star_rounded),
      ],
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.innerBorder, width: 1.2),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.brandOrange, size: 20),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDarkPrimary)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontFamily: 'Cairo', fontSize: 11, color: AppColors.textDarkMuted)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontFamily: 'Cairo', fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDarkPrimary),
    );
  }

  Widget _buildAboutCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.innerBorder, width: 1.2),
      ),
      child: const Text(
        'تأسست دار رعاية الأيتام بغريان لتقديم الرعاية الشاملة للأطفال فاقدي السند الأسري، حيث تسعى لتوفير بيئة أسرية دافئة، ورعاية صحية، وتعليمية ممتازة لتنشئة جيل صالح وقادر على العطاء في المجتمع الليبي.',
        style: TextStyle(fontFamily: 'Cairo', fontSize: 13, color: AppColors.textDarkSecondary, height: 1.6),
      ),
    );
  }

  Widget _buildContactCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.innerBorder, width: 1.2),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.location_on_rounded, color: AppColors.brandOrange, size: 18),
              SizedBox(width: 12),
              Text('غريان - بالقرب من المجمع الصحي', style: TextStyle(fontFamily: 'Cairo', fontSize: 13, color: AppColors.textDarkSecondary)),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(color: AppColors.innerBorder),
          ),
          Row(
            children: [
              const Icon(Icons.phone_rounded, color: AppColors.brandOrange, size: 18),
              const SizedBox(width: 12),
              Text(
                '091-XXXXXXX / 092-XXXXXXX',
                textDirection: TextDirection.ltr, 
                style: const TextStyle(
                  fontFamily: 'Cairo', 
                  fontSize: 13, 
                  color: AppColors.textDarkSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrphanageNeedsList() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            // 💎 تم تغليف الـ Container بـ InkWell لتفعيل الضغط والانتقال لصفحة تفاصيل الاحتياج
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/need_details');
                },
                borderRadius: BorderRadius.circular(16), // متوافق مع زوايا الكرت تماماً
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.innerBorder),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(color: AppColors.brandOrangeLight, shape: BoxShape.circle),
                        child: Icon(index == 0 ? Icons.restaurant_rounded : Icons.checkroom_rounded, color: AppColors.brandOrange, size: 18),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              index == 0 ? 'توفير مواد تموينية أساسية للمطبخ الداخلي' : 'شراء كسوة الصيف للأطفال من عمر 4 إلى 10 سنوات',
                              style: const TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.bold, color: AppColors.textDarkPrimary),
                            ),
                            const SizedBox(height: 4),
                            const Text('نسبة الإنجاز: %60', style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: AppColors.textDarkMuted)),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.textDarkMuted),
                    ],
                  ),
                ),
              ),
            );
          },
          childCount: 2,
        ),
      ),
    );
  }
}