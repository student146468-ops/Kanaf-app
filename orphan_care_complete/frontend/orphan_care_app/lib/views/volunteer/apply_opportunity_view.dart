import 'dart:ui';
import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class ApplyOpportunityView extends StatefulWidget {
  const ApplyOpportunityView({super.key});

  @override
  State<ApplyOpportunityView> createState() => _ApplyOpportunityViewState();
}

class _ApplyOpportunityViewState extends State<ApplyOpportunityView> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  final _skillsController = TextEditingController();
  bool _isFileUploaded = false;
  bool _isSubmitting = false;

  final FocusNode _reasonFocusNode = FocusNode();
  final FocusNode _skillsFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _reasonFocusNode.addListener(() => setState(() {}));
    _skillsFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _skillsController.dispose();
    _reasonFocusNode.dispose();
    _skillsFocusNode.dispose();
    super.dispose();
  }

  // 💎 نافذة النجاح الكريستالية الفاخرة المحدثة لعام 2026 بربط فوري آمن
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: AppColors.glassBorderSelected.withOpacity(0.3), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.brandOrange.withOpacity(0.12),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ⚡ أيقونة نجاح مجسمة ثلاثية الأبعاد متوهجة بنظام الطبقات والنيون اللطيف
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF1E9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.brandOrange.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                        const BoxShadow(
                          color: Colors.white,
                          blurRadius: 10,
                          spreadRadius: -4,
                        )
                      ],
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.brandOrange,
                      size: 56,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'تم إرسال طلبكِ بنجاح! 🎉',
                    style: TextStyle(
                      color: AppColors.textDarkPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'شكراً لعطائكِ أماني. تلقت إدارة "كَنَفْ" طلب التطوع لتدريس البرمجة للأيتام، وسيتم مراجعته والتواصل معكِ عبر الإشعارات خلال 24 ساعة.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textDarkSecondary,
                      fontSize: 13.5,
                      height: 1.6,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 28),
                  // زر العودة التفاعلي المربوط بـ Stack الأمان للرئيسية
                  Container(
                    height: 54,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: AppColors.orangeGradient,
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.brandOrangeDark.withOpacity(0.35),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        )
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () {
                        Navigator.pop(context); // إغلاق الـ Dialog
                        // 💎 الربط الفوري المباشر بصفحة المتطوع الرئيسية المعتمدة لديكِ لتصفير المكدس وأمان التطبيق
                        Navigator.pushNamedAndRemoveUntil(context, '/home_volunteer', (route) => false);
                      },
                      child: const Text(
                        'العودة للرئيسية',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.innerBorder, width: 1),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6, offset: const Offset(0, 3))
                ]
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textDarkPrimary, size: 14),
            ),
          ),
          title: const Text(
            'تقديم طلب تطوع',
            style: TextStyle(color: AppColors.textDarkPrimary, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 14.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✨ بطاقة علوية زجاجية فخمة ثلاثية الأبعاد لتعزيز حماس المتطوعة
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.brandOrangeLight.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: AppColors.glassBorderNormal, width: 1.2),
                    ),
                    child: Row(
                      children: [
                        // أيقونة بريق ثلاثي أبعاد مجسم
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: AppColors.innerShadow, blurRadius: 8, offset: Offset(0, 3))
                            ]
                          ),
                          child: const Icon(Icons.volunteer_activism_rounded, color: AppColors.brandOrange, size: 24),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'أنتِ تقدمين على فرصة:',
                                style: TextStyle(color: AppColors.brandOrangeDark, fontSize: 11.5, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'تدريس أساسيات الحاسوب والبرمجة للأيتام',
                                style: TextStyle(color: AppColors.textDarkPrimary, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 28),

                  // ✍️ الحقل الأول: سبب الرغبة في التطوع بتصميم ناعم ومودرن وعميق
                  const Text(
                    'لماذا ترغبين في الانضمام لهذه الفرصة التطوعية؟ *',
                    style: TextStyle(color: AppColors.textDarkPrimary, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
                  ),
                  const SizedBox(height: 10),
                  _buildGlassInputField(
                    controller: _reasonController,
                    focusNode: _reasonFocusNode,
                    hintText: 'اكتبي دافعكِ الإنساني باختصار، كيف سيساهم شغفكِ في إحداث فارق للأطفال...',
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'يرجى كتابة سبب الرغبة في التطوع لضمان قبول طلبكِ';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 26),

                  // ✍️ الحقل الثاني: المهارات والخبرات السابقة
                  const Text(
                    'الخبرات أو المهارات السابقة ذات الصلة *',
                    style: TextStyle(color: AppColors.textDarkPrimary, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
                  ),
                  const SizedBox(height: 10),
                  _buildGlassInputField(
                    controller: _skillsController,
                    focusNode: _skillsFocusNode,
                    hintText: 'مثال: طالبة هندسة برمجيات، مهارة ممتازة في لغة Dart وFlutter، القدرة على تبسيط الشرح...',
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'يرجى كتابة المهارات لمساعدة المشرفين على تقييم طلبكِ';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 26),

                  // 📁 القسم الثالث: منطقة رفع السيرة الذاتية التفاعلية المجسمة الفخمة
                  const Text(
                    'السيرة الذاتية أو إثبات الهوية البرمجية (اختياري)',
                    style: TextStyle(color: AppColors.textDarkPrimary, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isFileUploaded = !_isFileUploaded;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                      decoration: BoxDecoration(
                        color: _isFileUploaded ? const Color(0x0CE25E14) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _isFileUploaded ? AppColors.brandOrange : AppColors.innerBorder,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _isFileUploaded ? AppColors.brandOrange.withOpacity(0.05) : Colors.black.withOpacity(0.01),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ]
                      ),
                      child: Column(
                        children: [
                          // أيقونة مرفقات بتأثير مجسم أنيق ثلاثي أبعاد
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: _isFileUploaded ? AppColors.brandOrange.withOpacity(0.1) : AppColors.scaffoldBackground,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: _isFileUploaded ? AppColors.brandOrange.withOpacity(0.1) : Colors.transparent,
                                  blurRadius: 8,
                                )
                              ]
                            ),
                            child: Icon(
                              _isFileUploaded ? Icons.file_present_rounded : Icons.cloud_upload_outlined,
                              color: _isFileUploaded ? AppColors.brandOrange : AppColors.textDarkMuted,
                              size: 34,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            _isFileUploaded ? 'تم إرفاق ملفكِ بنجاح: CV_Amany_Ahmed.pdf' : 'اضغطي هنا لرفع السيرة الذاتية أو وثيقة التخصص',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _isFileUploaded ? AppColors.brandOrangeDark : AppColors.textDarkSecondary,
                              fontSize: 13.5,
                              fontWeight: _isFileUploaded ? FontWeight.bold : FontWeight.normal,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (!_isFileUploaded)
                            const Text(
                              'الصيغ المقبولة: PDF, DOCX (الحد الأقصى 5 ميجابايت)',
                              style: TextStyle(color: AppColors.textDarkMuted, fontSize: 11, fontFamily: 'Tajawal'),
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 38),

                  // 🚀 زر تأكيد وإرسال طلب التطوع النيوني المتوهج والخلاب عالي التفاعل
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: AppColors.orangeGradient,
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.brandOrange.withOpacity(0.35),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        )
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      ),
                      onPressed: _isSubmitting ? null : () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => _isSubmitting = true);
                          // محاكاة استجابة السيرفر بشكل احترافي وسلس
                          await Future.delayed(const Duration(milliseconds: 800));
                          if (mounted) {
                            setState(() => _isSubmitting = false);
                            _showSuccessDialog();
                          }
                        }
                      },
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                            )
                          : const Text(
                              'تأكيد وإرسال طلب التطوع الآن',
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // دالة مساعدة لإنشاء حقول الإدخال بهندسة معاصرة متناسقة مع الأنيميشن وتغيير الـ Focus
  Widget _buildGlassInputField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hintText,
    required int maxLines,
    required FormFieldValidator<String> validator,
  }) {
    final bool isFocused = focusNode.hasFocus;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isFocused ? AppColors.brandOrange : AppColors.innerBorder,
          width: isFocused ? 1.6 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isFocused ? AppColors.brandOrange.withOpacity(0.04) : Colors.black.withOpacity(0.005),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        maxLines: maxLines,
        validator: validator,
        cursorColor: AppColors.brandOrange,
        style: const TextStyle(fontFamily: 'Tajawal', fontSize: 14, color: AppColors.textDarkPrimary, height: 1.4),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: AppColors.textDarkMuted, fontSize: 13, fontFamily: 'Tajawal'),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          errorStyle: const TextStyle(fontFamily: 'Tajawal', fontSize: 11.5, height: 0.8),
        ),
      ),
    );
  }
}