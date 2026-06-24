import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import 'care_home_light_widgets.dart';

class RateVolunteersScreen extends StatefulWidget {
  const RateVolunteersScreen({super.key});

  @override
  State<RateVolunteersScreen> createState() => _RateVolunteersScreenState();
}

class _RateVolunteersScreenState extends State<RateVolunteersScreen> {
  int _ratingScore = 5;
  String _selectedBadge = 'متميز تعليميًا';
  final TextEditingController _notesController = TextEditingController();

  // TODO: Receive selected volunteer from manage volunteers when backend flow is ready.
  final Map<String, dynamic> _targetVolunteer = {
    'name': 'أحمد علي الساعدي',
    'role': 'دعم تعليمي',
    'summary': 'مدرس لغة إنجليزية ودعم دراسي للأطفال',
    'duration': '3 أشهر تطوع مستمر',
  };

  final List<Map<String, dynamic>> _badges = [
    {
      'name': 'متميز تعليميًا',
      'icon': Icons.school_outlined,
      'color': const Color(0xFF3B82F6),
    },
    {
      'name': 'قائد مؤثر',
      'icon': Icons.auto_awesome_outlined,
      'color': Colors.amber,
    },
    {
      'name': 'صديق الطفولة',
      'icon': Icons.child_care_outlined,
      'color': const Color(0xFF10B981),
    },
    {
      'name': 'ملتزم ومثالي',
      'icon': Icons.verified_user_outlined,
      'color': const Color(0xFF8B5CF6),
    },
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWebOrDesktop = size.width > 600;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: Center(
          child: Container(
            width: isWebOrDesktop ? 430 : double.infinity,
            height: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: AppColors.scaffoldBackground,
              boxShadow: isWebOrDesktop
                  ? [
                      BoxShadow(
                        color: AppColors.innerShadow,
                        blurRadius: 24,
                        spreadRadius: 0,
                      )
                    ]
                  : [],
            ),
            child: Stack(
              children: [
                const Positioned.fill(child: _CareHomeBackground()),
                SafeArea(
                  child: Column(
                    children: [
                      _HeaderBar(
                        title: 'تقييم المتطوع',
                        onBack: () => Navigator.of(context).pop(),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _VolunteerCard(volunteer: _targetVolunteer),
                              const SizedBox(height: 20),
                              const _SectionTitle('التقييم العام'),
                              const SizedBox(height: 12),
                              _StarsRating(
                                rating: _ratingScore,
                                onChanged: (value) =>
                                    setState(() => _ratingScore = value),
                              ),
                              const SizedBox(height: 20),
                              const _SectionTitle('وسام التقدير'),
                              const SizedBox(height: 12),
                              _BadgesGrid(
                                badges: _badges,
                                selected: _selectedBadge,
                                onChanged: (value) =>
                                    setState(() => _selectedBadge = value),
                              ),
                              const SizedBox(height: 20),
                              const _SectionTitle('ملاحظات إضافية'),
                              const SizedBox(height: 12),
                              _NotesField(controller: _notesController),
                              const SizedBox(height: 28),
                              _SubmitButton(onTap: _submitRating),
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

  void _submitRating() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'تم اعتماد تقييم المتطوع بنجاح',
          style: TextStyle(fontFamily: 'Tajawal'),
        ),
        backgroundColor: Color(0xFF10B981),
      ),
    );
    Navigator.of(context).pop();
  }
}

class _CareHomeBackground extends StatelessWidget {
  const _CareHomeBackground();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.white, AppColors.scaffoldBackground],
        ),
      ),
    );
  }
}

class _HeaderBar extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const _HeaderBar({required this.title, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          _CircleButton(icon: Icons.arrow_back_ios_new_rounded, onTap: onBack),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppColors.textDarkPrimary,
              ),
            ),
          ),
          const SizedBox(width: 42),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.innerBorder),
        ),
        child: Icon(icon, color: AppColors.textDarkPrimary, size: 19),
      ),
    );
  }
}

class _VolunteerCard extends StatelessWidget {
  final Map<String, dynamic> volunteer;

  const _VolunteerCard({required this.volunteer});

  @override
  Widget build(BuildContext context) {
    return CareHomeCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.brandOrange.withOpacity(0.12),
              shape: BoxShape.circle,
              border:
                  Border.all(color: AppColors.brandOrange.withOpacity(0.28)),
            ),
            child: const Icon(Icons.person_outline_rounded,
                color: AppColors.brandOrange, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  volunteer['name'],
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textDarkPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${volunteer['summary']} • ${volunteer['duration']}',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 12.5,
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
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Cairo',
        fontSize: 14,
        fontWeight: FontWeight.w900,
        color: AppColors.textDarkPrimary,
      ),
    );
  }
}

class _StarsRating extends StatelessWidget {
  final int rating;
  final ValueChanged<int> onChanged;

  const _StarsRating({required this.rating, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return CareHomeCard(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index) {
          final starValue = 5 - index;
          final isSelected = starValue <= rating;
          return InkWell(
            onTap: () => onChanged(starValue),
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Icon(
                isSelected ? Icons.star_rounded : Icons.star_border_rounded,
                color: isSelected ? Colors.amber : AppColors.innerBorder,
                size: 36,
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _BadgesGrid extends StatelessWidget {
  final List<Map<String, dynamic>> badges;
  final String selected;
  final ValueChanged<String> onChanged;

  const _BadgesGrid({
    required this.badges,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.35,
      ),
      itemCount: badges.length,
      itemBuilder: (context, index) {
        final badge = badges[index];
        final isSelected = selected == badge['name'];
        final color = badge['color'] as Color;

        return InkWell(
          onTap: () => onChanged(badge['name']),
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            decoration: BoxDecoration(
              color:
                  isSelected ? color.withOpacity(0.14) : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? color : AppColors.innerBorder,
                width: isSelected ? 1.4 : 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  badge['icon'],
                  color: isSelected ? color : AppColors.textDarkSecondary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  badge['name'],
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: isSelected
                        ? AppColors.textDarkPrimary
                        : AppColors.textDarkSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _NotesField extends StatelessWidget {
  final TextEditingController controller;

  const _NotesField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return CareHomeCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: TextField(
        controller: controller,
        maxLines: 3,
        style: const TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 14,
          color: AppColors.textDarkPrimary,
        ),
        decoration: InputDecoration(
          hintText: 'أضف ملاحظة قصيرة تساعد في تطوير تجربة المتطوع...',
          hintStyle: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 13,
            color: AppColors.textDarkMuted,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final VoidCallback onTap;

  const _SubmitButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 52,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.brandOrange,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.brandOrange.withOpacity(0.18),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'حفظ التقييم',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
