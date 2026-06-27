import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import 'volunteer_ui.dart';

const Color _detailsTextSecondary = Color(0xFF6B7280);
const String _fallbackImagePath = 'assets/images/image4.png';
const String _volunteersNeededLabel = 'عدد المتطوعين المطلوبين';

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
    'seats': '10 متطوعين مطلوبين',
    'status': 'متاحة',
    'summary':
        'فرصة قصيرة ومنظمة لمساعدة الأطفال على فهم مبادئ الحاسوب بطريقة بسيطة وآمنة، مع متابعة من مشرف الدار.',
  };

  Map<String, String> _selectedOpportunity(BuildContext context) {
    final selected = Map<String, String>.from(_opportunity);
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is Map) {
      final opportunityArg = args['opportunity'];
      if (opportunityArg is Map) {
        opportunityArg.forEach((key, value) {
          if (key is String && value is String) {
            selected[key] = value;
          }
        });
      }
      final location = selected['location'];
      if (location != null && location.isNotEmpty) {
        selected['organization'] = location;
      }
    }

    return selected;
  }

  String _selectedImagePath(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args['imagePath'] is String) {
      return args['imagePath'] as String;
    }
    return _fallbackImagePath;
  }

  @override
  Widget build(BuildContext context) {
    final opportunity = _selectedOpportunity(context);
    final imagePath = _selectedImagePath(context);

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
              _HeroDetailsCard(
                opportunity: opportunity,
                imagePath: imagePath,
              ),
              const SizedBox(height: 16),
              _ImportantInfoGrid(opportunity: opportunity),
              const SizedBox(height: 18),
              const VolunteerSectionTitle(title: 'وصف الفرصة'),
              const SizedBox(height: 10),
              VolunteerCard(
                child: Text(
                  opportunity['summary']!,
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
        onApply: () => Navigator.of(context).pushNamed('/apply_opportunity'),
      ),
    );
  }
}

class _HeroDetailsCard extends StatelessWidget {
  final Map<String, String> opportunity;
  final String imagePath;

  const _HeroDetailsCard({
    required this.opportunity,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Image.asset(
            imagePath,
            width: double.infinity,
            height: 190,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          opportunity['title']!,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: AppColors.textDarkPrimary,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(
              Icons.apartment_rounded,
              color: _detailsTextSecondary,
              size: 18,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                opportunity['organization']!,
                style: const TextStyle(
                  fontFamily: 'Tajawal',
                  color: _detailsTextSecondary,
                  fontSize: 13.5,
                  height: 1.45,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DetailInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: _detailsTextSecondary, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '$label: $value',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Tajawal',
              color: _detailsTextSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w800,
              height: 1.25,
            ),
          ),
        ),
      ],
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
        icon: Icons.location_on_outlined,
        label: 'الموقع',
        value: opportunity['city']!,
      ),
      _InfoItem(
        icon: Icons.calendar_month_outlined,
        label: 'التاريخ',
        value: opportunity['date']!,
      ),
      _InfoItem(
        icon: Icons.schedule_rounded,
        label: 'التوقيت',
        value: opportunity['time']!,
      ),
      _InfoItem(
        icon: Icons.event_seat_outlined,
        label: _volunteersNeededLabel,
        value: opportunity['seats']!,
      ),
    ];

    return VolunteerCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            _DetailInfoRow(
              icon: items[i].icon,
              label: items[i].label,
              value: items[i].value,
            ),
            if (i != items.length - 1) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _InfoItem {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });
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
                  color: AppColors.brandOrange,
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
  final VoidCallback onApply;

  const _ApplyBar({required this.onApply});

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
        child: SizedBox(
          width: double.infinity,
          child: VolunteerPrimaryButton(
            label: 'تقديم طلب تطوع',
            icon: Icons.send_rounded,
            onPressed: onApply,
          ),
        ),
      ),
    );
  }
}
