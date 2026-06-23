import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import 'donor_mobile_chrome.dart';

class OrphanageProfileScreen extends StatelessWidget {
  const OrphanageProfileScreen({super.key});

  final List<Map<String, dynamic>> _needs = const [
    {
      'orphanage': 'دار رعاية الأيتام - غريان',
      'title': 'توفير مواد تموينية للمطبخ الداخلي',
      'raised': '1,800 د.ل',
      'target': '3,000 د.ل',
      'progress': 0.60,
      'daysLeft': '7 أيام',
      'category': 'غذائي',
      'urgency': 'عاجل',
      'description': 'مواد أساسية تساعد في تجهيز وجبات يومية متوازنة للأطفال.',
    },
    {
      'orphanage': 'دار رعاية الأيتام - غريان',
      'title': 'شراء كسوة صيفية للأطفال',
      'raised': '2,200 د.ل',
      'target': '4,500 د.ل',
      'progress': 0.49,
      'daysLeft': '10 أيام',
      'category': 'كساء',
      'urgency': 'متوسط',
      'description': 'ملابس وأحذية جديدة تناسب أعمار الأطفال وتحفظ كرامتهم.',
    },
  ];

  final Map<String, String> _orphanage = const {
    'name': 'دار رعاية الأيتام - غريان',
    'status': 'موثقة في كنف',
    'about':
        'تعمل الدار على توفير رعاية يومية آمنة للأطفال، مع متابعة تعليمية وصحية تساعدهم على النمو في بيئة مستقرة.',
    'location': 'غريان - بالقرب من المجمع الصحي',
    'phone': '091-XXXXXXX / 092-XXXXXXX',
  };

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: donorMobileAppBar(
          title: 'ملف دار الرعاية',
          leading: IconButton(
            tooltip: 'رجوع',
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.textDarkPrimary, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                children: [
                  _buildHeader(_orphanage),
                  const SizedBox(height: 14),
                  _buildStats(),
                  const SizedBox(height: 18),
                  const _SectionTitle('نبذة عن الدار'),
                  const SizedBox(height: 10),
                  _InfoCard(
                    icon: Icons.favorite_rounded,
                    text: _orphanage['about']!,
                  ),
                  const SizedBox(height: 18),
                  const _SectionTitle('التواصل والموقع'),
                  const SizedBox(height: 10),
                  _buildContactCard(_orphanage),
                  const SizedBox(height: 18),
                  const _SectionTitle('احتياجات الدار الحالية'),
                  const SizedBox(height: 10),
                  ..._needs.map((need) => _NeedTile(need: need)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Map<String, String> orphanage) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.innerBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.brandOrangeLight,
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(Icons.apartment_rounded,
                size: 34, color: AppColors.brandOrange),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  orphanage['name']!,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 18,
                    height: 1.35,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textDarkPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const _VerificationBadge(),
                const SizedBox(height: 6),
                Text(
                  orphanage['status']!,
                  style: const TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 13.5,
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

  Widget _buildStats() {
    return const Row(
      children: [
        Expanded(child: _StatCard(value: '45', label: 'طفل')),
        SizedBox(width: 10),
        Expanded(child: _StatCard(value: '12', label: 'احتياج')),
        SizedBox(width: 10),
        Expanded(child: _StatCard(value: '88%', label: 'تغطية')),
      ],
    );
  }

  Widget _buildContactCard(Map<String, String> orphanage) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.innerBorder),
      ),
      child: Column(
        children: [
          _ContactRow(
            icon: Icons.location_on_rounded,
            text: orphanage['location']!,
          ),
          const Divider(height: 22, color: AppColors.divider),
          _ContactRow(
            icon: Icons.phone_rounded,
            text: orphanage['phone']!,
          ),
        ],
      ),
    );
  }
}

class _VerificationBadge extends StatelessWidget {
  const _VerificationBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.successGreenLight,
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_rounded, color: AppColors.successGreen, size: 15),
          SizedBox(width: 5),
          Text(
            'دار موثقة',
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppColors.successGreen,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Cairo',
        fontSize: 15,
        fontWeight: FontWeight.w800,
        color: AppColors.textDarkPrimary,
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.innerBorder),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: AppColors.brandOrangeDark,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 12,
              color: AppColors.textDarkSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.innerBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.brandOrange),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 14,
                height: 1.55,
                color: AppColors.textDarkSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.brandOrange, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            textDirection:
                text.contains('X') ? TextDirection.ltr : TextDirection.rtl,
            style: const TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 13.5,
              color: AppColors.textDarkSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

class _NeedTile extends StatelessWidget {
  const _NeedTile({required this.need});

  final Map<String, dynamic> need;

  @override
  Widget build(BuildContext context) {
    final progress = (need['progress'] as num).toDouble().clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () =>
              Navigator.pushNamed(context, '/need_details', arguments: need),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.innerBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.brandOrangeLight,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.favorite_rounded,
                          color: AppColors.brandOrange),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        need['title'] as String,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14.5,
                          height: 1.35,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDarkPrimary,
                        ),
                      ),
                    ),
                    const Icon(Icons.chevron_left_rounded,
                        color: AppColors.textDarkMuted),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 7,
                    backgroundColor: AppColors.surfaceLight,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.brandOrange),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
