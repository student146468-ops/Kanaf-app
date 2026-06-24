import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../settings/shared_mobile_ui.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const KanafPage(
      title: 'عن تطبيق كنف',
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            kanafHorizontalPadding,
            8,
            kanafHorizontalPadding,
            28,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _IntroCard(),
              SizedBox(height: 18),
              _SectionTitle('فكرة المشروع'),
              SizedBox(height: 10),
              KanafCard(
                child: Text(
                  'كنف منصة تساعد على تنظيم دعم دور رعاية الأيتام وربط الاحتياجات الحقيقية بالمتبرعين والمتطوعين بطريقة واضحة وقابلة للمتابعة.',
                  style: kanafBodyStyle,
                ),
              ),
              SizedBox(height: 18),
              _SectionTitle('ما الذي يقدمه كنف؟'),
              SizedBox(height: 10),
              KanafCard(
                child: Column(
                  children: [
                    _GoalRow(
                      icon: Icons.fact_check_outlined,
                      title: 'احتياجات موثقة',
                      text:
                          'عرض الاحتياجات العينية والمالية والتطوعية بصورة منظمة وسهلة القراءة.',
                    ),
                    Divider(height: 22, color: AppColors.divider),
                    _GoalRow(
                      icon: Icons.volunteer_activism_outlined,
                      title: 'تنظيم العطاء',
                      text:
                          'تسهيل وصول المتبرعين والمتطوعين للفرص المناسبة دون ازدحام أو خطوات معقدة.',
                    ),
                    Divider(height: 22, color: AppColors.divider),
                    _GoalRow(
                      icon: Icons.timeline_rounded,
                      title: 'متابعة الأثر',
                      text:
                          'إظهار حالة الاحتياج ومراحل تنفيذه بشكل واضح من بداية الدعم حتى الإغلاق.',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18),
              _SectionTitle('التواصل'),
              SizedBox(height: 10),
              KanafCard(
                child: Column(
                  children: [
                    _ContactRow(
                      icon: Icons.location_on_outlined,
                      title: 'النطاق الجغرافي',
                      value: 'ليبيا - مدينة غريان',
                    ),
                    Divider(height: 22, color: AppColors.divider),
                    _ContactRow(
                      icon: Icons.email_outlined,
                      title: 'البريد الإلكتروني',
                      value: 'support@kanaf.ly',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 26),
              Center(
                child: Text('الإصدار v1.0.0', style: kanafMutedStyle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard();

  @override
  Widget build(BuildContext context) {
    return const KanafCard(
      color: AppColors.brandOrangeLight,
      borderColor: Colors.white,
      child: Row(
        children: [
          KanafIconBox(
            icon: Icons.handshake_outlined,
            backgroundColor: Colors.white,
            size: 56,
            iconSize: 30,
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'نظم العطاء ليصل إلى مكانه الصحيح',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: AppColors.textDarkPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    height: 1.35,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'تجربة إنسانية بسيطة تربط الدعم بالاحتياج الحقيقي.',
                  style: kanafBodyStyle,
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
    return Text(title, style: kanafSectionTitleStyle);
  }
}

class _GoalRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;

  const _GoalRow({
    required this.icon,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        KanafIconBox(icon: icon, size: 40, iconSize: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.textDarkPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 3),
              Text(text, style: kanafBodyStyle),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _ContactRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        KanafIconBox(icon: icon, size: 40, iconSize: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: kanafMutedStyle),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Tajawal',
                  color: AppColors.textDarkPrimary,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
