import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import 'volunteer_ui.dart';

const Color _primaryOrange = Color(0xFFFF8C42);
const Color _volunteerMetaColor = Color(0xFF6B7280);
const Color _softBorder = Color(0xFFEAEAEA);

class SearchFilterView extends StatefulWidget {
  const SearchFilterView({super.key});

  @override
  State<SearchFilterView> createState() => _SearchFilterViewState();
}

class _SearchFilterViewState extends State<SearchFilterView> {
  final _searchController = TextEditingController();
  String _selectedFilter = 'الكل';

  static const List<String> _filters = [
    'الكل',
    'تعليم',
    'أنشطة',
    'إغاثة',
  ];

  // TODO: Replace with AppProvider opportunities when available.
  static const List<Map<String, dynamic>> _results = [
    {
      'title': 'دعم تعليمي في أساسيات الحاسوب',
      'city': 'غريان',
      'skill': 'تعليم وتقنية',
      'date': 'الإثنين 1 يوليو',
      'seats': '10 متطوعين مطلوبين',
      'image': 'assets/images/image4.png',
    },
    {
      'title': 'تنظيم يوم أنشطة للأطفال',
      'city': 'غريان',
      'skill': 'أنشطة أطفال',
      'date': 'الجمعة 5 يوليو',
      'seats': '5 متطوعين مطلوبين',
      'image': 'assets/images/image5.png',
      'summary':
          'ساهم في تنظيم يوم ترفيهي مليء بالألعاب والأنشطة الهادفة، بهدف إدخال السرور على الأطفال وتنمية روح التعاون والثقة لديهم في بيئة آمنة وممتعة.',
      'tasks': [
        'تنظيم الألعاب والأنشطة الجماعية للأطفال.',
        'الإشراف على سلامة الأطفال أثناء الفعالية.',
        'تشجيع الأطفال على المشاركة والتفاعل الإيجابي.',
        'التعاون مع فريق التنظيم وتجهيز الأدوات قبل وبعد النشاط.',
      ],
      'skillsList': [
        'حب التعامل مع الأطفال والصبر عليهم.',
        'القدرة على العمل ضمن فريق.',
        'مهارات التواصل والابتكار في الأنشطة الترفيهية.',
        'الالتزام بالمواعيد وتحمل المسؤولية.',
      ],
    },
    {
      'title': 'فرز التبرعات وتجهيز السلال',
      'city': 'طرابلس',
      'skill': 'تنظيم ومتابعة',
      'date': 'الأحد 7 يوليو',
      'seats': '15 متطوعاً مطلوباً',
      'image': 'assets/images/image6.png',
      'summary':
          'المساهمة في فرز وترتيب وتجهيز التبرعات العينية، والتأكد من جاهزيتها لتوزيعها على دور رعاية الأيتام بطريقة منظمة وسريعة.',
      'tasks': [
        'فرز التبرعات حسب النوع والاستخدام.',
        'تغليف وترتيب المواد داخل الصناديق.',
        'إعداد قوائم بالمحتويات للمساعدة في عملية التوزيع.',
        'التعاون مع فريق العمل في تحميل وتجهيز المواد.',
      ],
      'skillsList': [
        'الدقة والتنظيم في ترتيب المواد.',
        'القدرة على العمل الجماعي.',
        'تحمل العمل البدني الخفيف عند الحاجة.',
        'الالتزام بالتعليمات والمحافظة على الممتلكات.',
      ],
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredResults {
    if (_selectedFilter == 'تعليم') {
      return _results
          .where((item) =>
              item['title']!.contains('تعليمي') ||
              item['skill']!.contains('تعليم'))
          .toList();
    }
    if (_selectedFilter == 'أنشطة') {
      return _results
          .where((item) =>
              item['title']!.contains('أنشطة') ||
              item['skill']!.contains('أنشطة'))
          .toList();
    }
    if (_selectedFilter == 'إغاثة') {
      return _results
          .where((item) =>
              item['title']!.contains('تبرعات') ||
              item['title']!.contains('سلال') ||
              item['skill']!.contains('إغاثة'))
          .toList();
    }
    return _results;
  }

  @override
  Widget build(BuildContext context) {
    return VolunteerAppScaffold(
      title: 'البحث عن فرص التطوع',
      showBack: false,
      body: SafeArea(
        top: false,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            volunteerHorizontalPadding,
            10,
            volunteerHorizontalPadding,
            24,
          ),
          children: [
            _SearchField(controller: _searchController),
            const SizedBox(height: 14),
            _InlineFilterRow(
              filters: _filters,
              selectedFilter: _selectedFilter,
              onSelected: (item) => setState(() => _selectedFilter = item),
            ),
            const SizedBox(height: 22),
            const VolunteerSectionTitle(title: 'نتائج مقترحة'),
            const SizedBox(height: 10),
            ..._filteredResults.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ResultCard(item: item),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;

  const _SearchField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: TextField(
        controller: controller,
        style: const TextStyle(
          fontFamily: 'Vazirmatn',
          color: AppColors.textDarkPrimary,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          hintText: 'ابحث عن فرصة',
          hintStyle: volunteerMutedStyle,
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: _volunteerMetaColor,
            size: 22,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 48,
            minHeight: 48,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 15,
          ),
          border: _border(_softBorder),
          enabledBorder: _border(_softBorder),
          focusedBorder: _border(_primaryOrange),
        ),
      ),
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(color: color),
    );
  }
}

class _InlineFilterRow extends StatelessWidget {
  final List<String> filters;
  final String selectedFilter;
  final ValueChanged<String> onSelected;

  const _InlineFilterRow({
    required this.filters,
    required this.selectedFilter,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  for (int i = 0; i < filters.length; i++) ...[
                    _ChoicePill(
                      label: filters[i],
                      selected: selectedFilter == filters[i],
                      onTap: () => onSelected(filters[i]),
                    ),
                    if (i != filters.length - 1) const SizedBox(width: 8),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onSelected('الكل'),
              borderRadius: BorderRadius.circular(12),
              child: const SizedBox(
                width: 32,
                height: 40,
                child: Icon(
                  Icons.filter_alt_outlined,
                  color: Color(0xFF374151),
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChoicePill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ChoicePill({
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
        hoverColor: AppColors.brandOrangeLight.withOpacity(0.32),
        splashColor: AppColors.brandOrangeLight,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: selected ? _primaryOrange : Colors.white,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected ? _primaryOrange : _softBorder,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selected) ...[
                const Icon(Icons.check_rounded, color: Colors.white, size: 15),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Vazirmatn',
                  color: selected ? Colors.white : _volunteerMetaColor,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const _ResultCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return VolunteerCard(
      onTap: () => Navigator.of(context).pushNamed(
        '/volunteer_opportunity_details',
        arguments: {
          'opportunity': item,
          'imagePath': item['image']!,
        },
      ),
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title']!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Vazirmatn',
                    color: AppColors.textDarkPrimary,
                    fontSize: 15.5,
                    height: 1.35,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _ResultMetaItem(
                      icon: Icons.location_on_outlined,
                      label: item['city']!,
                    ),
                    _ResultMetaItem(
                      icon: Icons.calendar_month_outlined,
                      label: item['date']!,
                    ),
                    _ResultMetaItem(
                      icon: Icons.psychology_alt_outlined,
                      label: item['skill']!,
                    ),
                    _ResultMetaItem(
                      icon: Icons.groups_2_outlined,
                      label: item['seats']!,
                      wide: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              item['image']!,
              width: 124,
              height: 110,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultMetaItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool wide;

  const _ResultMetaItem({
    required this.icon,
    required this.label,
    this.wide = false,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: wide ? 190 : 150),
      child: SizedBox(
        height: 28,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: _volunteerMetaColor, size: 15),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Vazirmatn',
                  color: _volunteerMetaColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
