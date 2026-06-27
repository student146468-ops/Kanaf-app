import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

/// [RoleSelectionScreen] - واجهة اختيار نوع الحساب لـ "تطبيق كَنَفْ".
class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  int? _selectedRoleIndex;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _rolesData = [
    {
      'role_key': 'care_home',
      'title': 'دار الرعاية',
      'subtitle': 'ننتظر احتياجاتنا ونلتقي بالدعم المناسب لمؤسستنا.',
      'imagePath': 'assets/images/care_home_3d.png',
      'fallbackIcon': Icons.home_work_outlined,
    },
    {
      'role_key': 'volunteer',
      'title': 'متطوع',
      'subtitle': 'اختر كيف تساهم بوقتك، مهاراتك وجهدك الإنساني.',
      'imagePath': 'assets/images/volunteer_3d.png',
      'fallbackIcon': Icons.volunteer_activism_outlined,
    },
    {
      'role_key': 'donor',
      'title': 'متبرع',
      'subtitle': 'ابحث عن الاحتياجات وتبرع واكفل ما تستطيع كنفاً لهم.',
      'imagePath': 'assets/images/donor_3d.png',
      'fallbackIcon': Icons.favorite_border_rounded,
    },
  ];

  void _onRoleTap(int index) {
    setState(() => _selectedRoleIndex = index);
  }

  Future<void> _handleProceed() async {
    if (_selectedRoleIndex == null) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 350));

    if (!mounted) return;
    setState(() => _isLoading = false);

    final selectedRoleKey = _rolesData[_selectedRoleIndex!]['role_key'];
    Navigator.of(context).pushReplacementNamed(
      '/login',
      arguments: selectedRoleKey,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final containerWidth = size.width > 600 ? 430.0 : double.infinity;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F8F8),
        body: Center(
          child: SizedBox(
            width: containerWidth,
            height: double.infinity,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                child: Column(
                  children: [
                    const Text(
                      'اختر دورك لنبدأ معك',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E1E1E),
                      ),
                    ),
                    const SizedBox(height: 34),
                    Expanded(
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemCount: _rolesData.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 18),
                        itemBuilder: (context, index) {
                          final role = _rolesData[index];
                          return _RoleCard(
                            role: role,
                            selected: _selectedRoleIndex == index,
                            onTap: () => _onRoleTap(index),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _selectedRoleIndex == null || _isLoading
                            ? null
                            : _handleProceed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.brandOrange,
                          disabledBackgroundColor: const Color(0xFFE5E7EB),
                          foregroundColor: Colors.white,
                          disabledForegroundColor: const Color(0xFF9CA3AF),
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          textStyle: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.4,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('متابعة'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final Map<String, dynamic> role;
  final bool selected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.role,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(26),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          constraints: const BoxConstraints(minHeight: 118),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.brandOrange.withOpacity(0.07)
                : Colors.white,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: selected ? AppColors.brandOrange : const Color(0xFFE4E4E7),
              width: selected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(selected ? 0.11 : 0.045),
                blurRadius: selected ? 24 : 14,
                offset: Offset(0, selected ? 12 : 7),
              ),
            ],
          ),
          child: Row(
            children: [
              _RoleIconBox(
                imagePath: role['imagePath'] as String,
                fallbackIcon: role['fallbackIcon'] as IconData,
                selected: selected,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      role['title'] as String,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E1E1E),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      role['subtitle'] as String,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 13.5,
                        height: 1.35,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 32,
                height: 32,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: selected
                      ? Container(
                          key: const ValueKey('selected'),
                          decoration: const BoxDecoration(
                            color: AppColors.brandOrange,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 21,
                          ),
                        )
                      : const SizedBox(key: ValueKey('empty')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleIconBox extends StatelessWidget {
  final String imagePath;
  final IconData fallbackIcon;
  final bool selected;

  const _RoleIconBox({
    required this.imagePath,
    required this.fallbackIcon,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 62,
      height: 62,
      decoration: BoxDecoration(
        color: selected
            ? AppColors.brandOrange.withOpacity(0.12)
            : const Color(0xFFF4F4F5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected
              ? AppColors.brandOrange.withOpacity(0.28)
              : const Color(0xFFEDEDED),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(9),
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) {
            return Icon(
              fallbackIcon,
              color: selected ? AppColors.brandOrange : const Color(0xFF6B7280),
              size: 28,
            );
          },
        ),
      ),
    );
  }
}
