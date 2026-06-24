import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../settings/shared_mobile_ui.dart';

class ExploreOrphanagesScreen extends StatefulWidget {
  const ExploreOrphanagesScreen({super.key});

  @override
  State<ExploreOrphanagesScreen> createState() =>
      _ExploreOrphanagesScreenState();
}

class _ExploreOrphanagesScreenState extends State<ExploreOrphanagesScreen> {
  String _selectedCity = 'غريان';
  final List<String> _cities = const [
    'غريان',
    'طرابلس',
    'بنغازي',
    'مصراتة',
    'الزاوية',
  ];

  // TODO: Replace with AppProvider orphanage/discovery data when available.
  final List<Map<String, dynamic>> _orphanages = const [
    {
      'name': 'دار الأمان لرعاية الأيتام',
      'location': 'غريان - وسط المدينة',
      'childrenCount': 35,
      'needsCount': 3,
      'status': 'احتياجات نشطة',
      'summary': 'دار تقدم رعاية يومية وتعليمًا أساسيًا للأطفال.',
    },
    {
      'name': 'مؤسسة كنف الطفولة الإنسانية',
      'location': 'غريان - الهيرة',
      'childrenCount': 22,
      'needsCount': 5,
      'status': 'تحتاج دعم',
      'summary': 'تعمل على توفير احتياجات موسمية وتعليمية عاجلة.',
    },
    {
      'name': 'جمعية غريان الخيرية للأطفال',
      'location': 'غريان - القواسم',
      'childrenCount': 18,
      'needsCount': 2,
      'status': 'متابعة مستمرة',
      'summary': 'تركز على المتابعة الصحية والدعم المدرسي للأطفال.',
    },
  ];

  List<Map<String, dynamic>> get _visibleOrphanages {
    return _orphanages.where((item) {
      return (item['location'] as String).contains(_selectedCity);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visibleOrphanages;
    return KanafPage(
      title: 'استكشاف دور الرعاية',
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            kanafHorizontalPadding,
            8,
            kanafHorizontalPadding,
            28,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SearchEntry(
                onTap: () => Navigator.of(context).pushNamed(
                  '/search_filter_results',
                ),
              ),
              const SizedBox(height: 18),
              const Text('استكشاف حسب المدينة', style: kanafSectionTitleStyle),
              const SizedBox(height: 12),
              SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _cities.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final city = _cities[index];
                    return _CityChip(
                      label: city,
                      selected: city == _selectedCity,
                      onTap: () => setState(() => _selectedCity = city),
                    );
                  },
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'دور الرعاية في $_selectedCity',
                      style: kanafSectionTitleStyle,
                    ),
                  ),
                  KanafBadge(
                    label: '${visible.length} دار',
                    color: AppColors.brandOrange,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (visible.isEmpty)
                KanafEmptyState(
                  icon: Icons.apartment_rounded,
                  title: 'لا توجد دور مسجلة',
                  message: 'جرّب اختيار مدينة أخرى أو البحث باسم دار الرعاية.',
                  actionLabel: 'فتح البحث',
                  onAction: () =>
                      Navigator.of(context).pushNamed('/search_filter_results'),
                )
              else
                ...visible.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _OrphanageCard(item: item),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchEntry extends StatelessWidget {
  final VoidCallback onTap;

  const _SearchEntry({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return KanafCard(
      onTap: onTap,
      child: const Row(
        children: [
          KanafIconBox(icon: Icons.manage_search_rounded, size: 42),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'ابحث عن دار رعاية أو احتياج محدد',
              style: kanafBodyStyle,
            ),
          ),
          Icon(Icons.tune_rounded, color: AppColors.textDarkMuted, size: 20),
        ],
      ),
    );
  }
}

class _CityChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CityChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          decoration: BoxDecoration(
            color: selected ? AppColors.brandOrange : Colors.white,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected ? AppColors.brandOrange : AppColors.innerBorder,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Tajawal',
              color: selected ? Colors.white : AppColors.textDarkSecondary,
              fontSize: 12.5,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _OrphanageCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const _OrphanageCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return KanafCard(
      onTap: () => Navigator.of(context).pushNamed('/orphanage_profile'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const KanafIconBox(
                icon: Icons.apartment_rounded,
                size: 46,
                iconSize: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name'] as String,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        color: AppColors.textDarkPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(item['location'] as String, style: kanafBodyStyle),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(item['summary'] as String, style: kanafMutedStyle),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              KanafBadge(
                label: item['status'] as String,
                color: AppColors.successGreen,
                icon: Icons.verified_outlined,
              ),
              KanafMetaChip(
                icon: Icons.child_care_rounded,
                label: '${item['childrenCount']} طفل',
                color: AppColors.brandOrange,
              ),
              KanafMetaChip(
                icon: Icons.priority_high_rounded,
                label: '${item['needsCount']} احتياجات نشطة',
                color: AppColors.skyBlueDark,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
