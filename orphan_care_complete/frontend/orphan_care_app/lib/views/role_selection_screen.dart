import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/glass_container.dart'; // 💎 استيراد القالب الزجاجي الموحد لضمان وحدة الهوية البصرية
import '../widgets/welcome_progress_indicator.dart';

/// [RoleSelectionScreen] - واجهة اختيار نوع الحساب لـ "تطبيق كَنَفْ".
/// تم تحديثها هندسياً بالاعتماد على [GlassContainer] لمنع الهزة البصرية وتوحيد الشفافية.
class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> with SingleTickerProviderStateMixin {
  int? _selectedRoleIndex;
  bool _isLoading = false;
  late AnimationController _pulseController;

  final List<Map<String, dynamic>> _rolesData = [
    {
      'role_key': 'care_home',
      'title': 'دار الرعاية',
      'subtitle': 'ننتظر احتياجاتنا ونلتقي بالدعم المناسب لمؤسستنا.',
      'imagePath': 'assets/images/care_home_3d.png',
    },
    {
      'role_key': 'volunteer',
      'title': 'متطوع',
      'subtitle': 'اختر كيف تساهم بوقتك، مهاراتك وجهدك الإنساني.',
      'imagePath': 'assets/images/volunteer_3d.png',
    },
    {
      'role_key': 'donor',
      'title': 'داعم / متبرع',
      'subtitle': 'ابحث عن الاحتياجات وتبرع واكفل ما تستطيع كنفاً لهم.',
      'imagePath': 'assets/images/donor_3d.png',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _onRoleTap(int index) {
    setState(() {
      _selectedRoleIndex = index;
    });
  }

  // ✨ تم تعديل الدالة لتمرير الدور المختار بدقة كـ arguments لصفحة تسجيل الدخول
  Future<void> _handleProceed() async {
    if (_selectedRoleIndex == null) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      setState(() => _isLoading = false);
      
      final selectedRoleKey = _rolesData[_selectedRoleIndex!]['role_key'];
      
      // التوجه لصفحة تسجيل الدخول مع تمرير المعطيات
      Navigator.of(context).pushReplacementNamed('/login', arguments: selectedRoleKey); 
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWebOrDesktop = size.width > 600;
    final containerWidth = isWebOrDesktop ? 420.0 : double.infinity;

    return Directionality(
      textDirection: TextDirection.rtl, // توجيه المحتوى باللغة العربية
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
                  ? [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 40, spreadRadius: 10)]
                  : [],
            ),
            child: Stack(
              children: [
                // 1️⃣ الصورة الخلفية كاملة بألوانها الأصلية الحية الطافية
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/child.png',
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),

                // 2️⃣ طبقة التباين المتدرجة المعتمدة لحماية النصوص من الحواف الخلفية
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.10),
                          AppColors.brandOrangeDark.withOpacity(0.24),
                          Colors.black.withOpacity(0.72), // تعتيم مثالي في الأسفل لبروز العناصر والأزرار
                        ],
                      ),
                    ),
                  ),
                ),

                // 3️⃣ المحتوى والبطاقات الزجاجية الموزعة بذكاء اتزان هندسي
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        const WelcomeProgressIndicator(currentStep: 3),
                        const SizedBox(height: 20),
                        Center(
                          child: Text(
                            'اختر دورك لنبدأ معك',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppColors.glassTextPrimary,
                              letterSpacing: 0,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 35),

                        // قائمة البطاقات الموحدة المانعة للهزة البصرية
                        Expanded(
                          child: ListView.builder(
                            itemCount: _rolesData.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              final role = _rolesData[index];
                              final isSelected = _selectedRoleIndex == index;
                              final isAnySelected = _selectedRoleIndex != null;
                              
                              double cardOpacity = 1.0;
                              if (isAnySelected && !isSelected) {
                                cardOpacity = 0.40; // تخفيف شفافية الكروت غير المحددة لزيادة التركيز البصري
                              }

                              return AnimatedOpacity(
                                duration: const Duration(milliseconds: 300),
                                opacity: cardOpacity,
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 20.0),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () => _onRoleTap(index),
                                      borderRadius: BorderRadius.circular(28),
                                      splashColor: Colors.white.withOpacity(0.08),
                                      highlightColor: Colors.transparent,
                                      child: GlassContainer(
                                        // 💎 استخدام قالب التصميم الزجاجي الموحد مباشرة لإلغاء تكرار الكود وحل الأخطاء
                                        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 18.0),
                                        child: Row(
                                          children: [
                                            // الأيقونة ثلاثية الأبعاد الفخمة الموحدة هندسياً
                                            Container(
                                              width: 56,
                                              height: 56,
                                              decoration: BoxDecoration(
                                                color: isSelected 
                                                    ? Colors.white.withOpacity(0.25)
                                                    : Colors.white.withOpacity(0.08),
                                                borderRadius: BorderRadius.circular(16),
                                                border: Border.all(
                                                  color: Colors.white.withOpacity(0.15), 
                                                  width: 1,
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Image.asset(
                                                  role['imagePath'],
                                                  fit: BoxFit.contain,
                                                  errorBuilder: (context, error, stackTrace) => 
                                                      const Icon(Icons.volunteer_activism, color: Colors.white70),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 16),

                                            // النصوص والبيانات التوضيحية للدور التبرعي
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    role['title'],
                                                    style: const TextStyle(
                                                      fontFamily: 'Cairo', 
                                                      fontSize: 18, 
                                                      fontWeight: FontWeight.w800, 
                                                      color: AppColors.glassTextPrimary,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    role['subtitle'],
                                                    style: const TextStyle(
                                                      fontFamily: 'Cairo', 
                                                      fontSize: 13, 
                                                      color: AppColors.glassTextSecondary, 
                                                      height: 1.4,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 12),

                                            // التفاعل البصري الذكي والتحول الانسيابي لعلامة الاختيار
                                            AnimatedSwitcher(
                                              duration: const Duration(milliseconds: 350),
                                              transitionBuilder: (child, animation) => 
                                                  ScaleTransition(scale: animation, child: child),
                                              child: isSelected
                                                  ? Container(
                                                      key: const ValueKey('check_circle'),
                                                      width: 26, 
                                                      height: 26,
                                                      decoration: const BoxDecoration(
                                                        color: Colors.white, 
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: const Icon(
                                                        Icons.check_rounded, 
                                                        color: AppColors.brandOrangeDark, 
                                                        size: 18,
                                                      ),
                                                    )
                                                  : Icon(
                                                      Icons.arrow_forward_ios_rounded, 
                                                      key: const ValueKey('arrow_icon'), 
                                                      color: Colors.white.withOpacity(0.55), 
                                                      size: 16,
                                                    ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        // 4️⃣ زر المتابعة التفاعلي المتناغم مع الهوية البصرية الكريستالية لـ كَنَفْ
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0, top: 15.0),
                          child: AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              final isEnabled = _selectedRoleIndex != null;
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: double.infinity,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: isEnabled ? AppColors.glassBtnActive : AppColors.glassBtnDisabled,
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: isEnabled && !_isLoading
                                      ? [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.45),
                                            blurRadius: 20,
                                            spreadRadius: 1,
                                            offset: const Offset(0, 10), 
                                          ),
                                          BoxShadow(
                                            color: AppColors.brandOrangeDark.withOpacity(0.25),
                                            blurRadius: 12,
                                            spreadRadius: _pulseController.value * 2.0,
                                            offset: const Offset(0, 3),
                                          ),
                                        ]
                                      : [],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: (isEnabled && !_isLoading) ? _handleProceed : null,
                                    borderRadius: BorderRadius.circular(18),
                                    child: Center(
                                      child: _isLoading
                                          ? const SizedBox(
                                              width: 24, 
                                              height: 24, 
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.5, 
                                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                              ),
                                            )
                                          : Text(
                                              'متابعة',
                                              style: TextStyle(
                                                fontFamily: 'Cairo', 
                                                fontSize: 17, 
                                                fontWeight: FontWeight.bold,
                                                color: isEnabled ? Colors.white : AppColors.glassTextDisabled,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
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
