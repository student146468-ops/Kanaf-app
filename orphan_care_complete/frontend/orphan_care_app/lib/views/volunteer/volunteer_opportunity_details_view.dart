import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import 'volunteer_ui.dart';

class VolunteerOpportunityDetailsView extends StatelessWidget {
  const VolunteerOpportunityDetailsView({super.key});

  // TODO: Receive the selected opportunity from AppProvider or route arguments.
  static const Map<String, String> _opportunity = {
    'title': 'دعم تعليمي في أساسيات الحاسوب',
    'organization': 'دار الأمان لرعاية الأيتام',
    'city': 'غريان',
    'skill': 'تعليم وتقنية',
    'date': 'الإثنين 1 يوليو',
    'time': '16:00 - 18:00',
    'duration': '4 ساعات أسبوعيًا',
    'seats': 'مقعدان متاحان',
    'status': 'متاحة',
    'summary':
        'فرصة قصيرة ومنظمة لمساعدة الأطفال على فهم مبادئ الحاسوب بطريقة بسيطة وآمنة، مع متابعة من مشرف الدار.',
  };

  @override
  Widget build(BuildContext context) {
    return VolunteerAppScaffold(
      title: 'تفاصيل الفرصة',
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            volunteerHorizontalPadding,
            10,
            volunteerHorizontalPadding,
            110,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _HeroDetailsCard(opportunity: _opportunity),
              const SizedBox(height: 12),
              const _ImportantInfoGrid(opportunity: _opportunity),
              const SizedBox(height: 18),
              const VolunteerSectionTitle(title: 'وصف الفرصة'),
              const SizedBox(height: 10),
              VolunteerCard(
                child: Text(
                  _opportunity['summary']!,
                  style: volunteerBodyStyle,
                ),
              ),
              const SizedBox(height: 18),
              const VolunteerSectionTitle(title: 'المهام المطلوبة'),
              const SizedBox(height: 10),
              const _BulletCard(
                items: [
                  'شرح مبادئ استخدام الحاسوب للأطفال بأسلوب مبسط.',
                  'متابعة التمارين القصيرة داخل القاعة التعليمية.',
                  'التنسيق مع مشرف الدار قبل وبعد كل جلسة.',
                ],
              ),
              const SizedBox(height: 18),
              const VolunteerSectionTitle(title: 'المهارات المناسبة'),
              const SizedBox(height: 10),
              const _BulletCard(
                items: [
                  'الصبر والقدرة على تبسيط المعلومة.',
                  'خبرة أساسية في الحاسوب أو التعليم.',
                  'الالتزام بالموعد واحترام خصوصية الأطفال.',
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _ApplyBar(
        seats: _opportunity['seats']!,
        onApply: () => Navigator.of(context).pushNamed('/apply_opportunity'),
      ),
    );
  }
}

class _HeroDetailsCard extends StatelessWidget {
  final Map<String, String> opportunity;

  const _HeroDetailsCard({required this.opportunity});

  @override
  Widget build(BuildContext context) {
    return VolunteerCard(
      padding: const EdgeInsets.all(18),
      color: AppColors.brandOrangeLight,
      borderColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              const VolunteerStatusBadge(
                label: 'متاحة',
                color: AppColors.successGreen,
                icon: Icons.check_circle_outline_rounded,
              ),
              VolunteerMetaChip(
                icon: Icons.location_on_outlined,
                label: opportunity['city']!,
                color: AppColors.brandOrange,
                prominent: true,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            opportunity['title']!,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 21,
              fontWeight: FontWeight.w900,
              color: AppColors.textDarkPrimary,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const VolunteerIconBox(
                icon: Icons.apartment_rounded,
                size: 36,
                iconSize: 19,
                backgroundColor: Colors.white,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  opportunity['organization']!,
                  style: volunteerBodyStyle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ImportantInfoGrid extends StatelessWidget {
  final Map<String, String> opportunity;

  const _ImportantInfoGrid({required this.opportunity});

  @override
  Widget build(BuildContext context) {
    final items = [
      _InfoItem(
        icon: Icons.calendar_month_outlined,
        label: 'التاريخ',
        value: opportunity['date']!,
        color: const Color(0xFF4A90E2),
      ),
      _InfoItem(
        icon: Icons.schedule_rounded,
        label: 'الوقت',
        value: opportunity['time']!,
        color: AppColors.brandOrange,
      ),
      _InfoItem(
        icon: Icons.psychology_alt_outlined,
        label: 'المهارة',
        value: opportunity['skill']!,
        color: const Color(0xFF7E57C2),
      ),
      _InfoItem(
        icon: Icons.event_seat_outlined,
        label: 'المقاعد',
        value: opportunity['seats']!,
        color: AppColors.successGreen,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 360;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: compact ? 1 : 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: compact ? 3.8 : 1.85,
          ),
          itemBuilder: (context, index) => _InfoTile(item: items[index]),
        );
      },
    );
  }
}

class _InfoItem {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
}

class _InfoTile extends StatelessWidget {
  final _InfoItem item;

  const _InfoTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return VolunteerCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          VolunteerIconBox(
            icon: item.icon,
            color: item.color,
            size: 38,
            iconSize: 20,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(item.label, style: volunteerMutedStyle),
                const SizedBox(height: 2),
                Text(
                  item.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Tajawal',
                    color: AppColors.textDarkPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BulletCard extends StatelessWidget {
  final List<String> items;

  const _BulletCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return VolunteerCard(
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.successGreen,
                  size: 19,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(items[i], style: volunteerBodyStyle),
                ),
              ],
            ),
            if (i != items.length - 1) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _ApplyBar extends StatelessWidget {
  final String seats;
  final VoidCallback onApply;

  const _ApplyBar({required this.seats, required this.onApply});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(top: BorderSide(color: AppColors.innerBorder)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: VolunteerMetaChip(
                icon: Icons.event_seat_outlined,
                label: seats,
                color: AppColors.successGreen,
                prominent: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: VolunteerPrimaryButton(
                label: 'تقديم طلب تطوع',
                icon: Icons.send_rounded,
                onPressed: onApply,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
