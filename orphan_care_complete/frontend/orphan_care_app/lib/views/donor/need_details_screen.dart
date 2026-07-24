import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import 'donor_mobile_chrome.dart';

class NeedDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> needData;

  const NeedDetailsScreen({super.key, required this.needData});

  static const Color _primaryOrange = Color(0xFFFF8C42);
  static const Color _screenBackground = Color(0xFFFFFDF9);
  static const Color _trackColor = Color(0xFFECECEC);
  static const Color _softUrgent = Color(0xFFE36F25);

  @override
  Widget build(BuildContext context) {
    final progress = _progressValue;
    final percentage = (progress * 100).round();
    final category = _text('category', 'عام');
    final urgency = _text('urgency', 'متوسط');
    final title = _text('title', 'احتياج إنساني قابل للدعم');
    final orphanage = _text('orphanage', 'دار رعاية الأيتام');
    final city = _city;
    final description = _text(
      'description',
      'يساعد هذا الدعم في تغطية احتياج أساسي للأطفال داخل الدار مع متابعة واضحة لحالة التبرع.',
    );
    final raised = _text('raised', '0 د.ل');
    final target = _text('target', '0 د.ل');
    final remaining = _text('remaining', 'غير محدد');
    final daysLeft = _text('daysLeft', 'غير محدد');
    final imagePath = _imagePath(category, title);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _screenBackground,
        appBar: DonorAppBar(
          title: 'تفاصيل الاحتياج',
          leading: donorBackButton(context),
          actions: const [
            Padding(
              padding: EdgeInsetsDirectional.only(end: DonorSpacing.md),
              child: _FavoriteIndicator(),
            ),
          ],
        ),
        body: SafeArea(
          top: false,
          child: DonorMobileFrame(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                    children: [
                      _HeroSection(
                        imagePath: imagePath,
                        title: title,
                        orphanage: orphanage,
                        city: city,
                        description: description,
                        urgency: urgency,
                      ),
                      const SizedBox(height: 16),
                      _QuickInfoRow(
                        target: target,
                        raised: raised,
                        remaining: remaining,
                        daysLeft: daysLeft,
                      ),
                      const SizedBox(height: 16),
                      _ProgressCard(
                        raised: raised,
                        target: target,
                        remaining: remaining,
                        progress: progress,
                        percentage: percentage,
                      ),
                      const SizedBox(height: 16),
                      _TextCard(
                        title: 'عن الاحتياج',
                        body: description,
                      ),
                      const SizedBox(height: 16),
                      _TextCard(
                        title: 'الأثر المتوقع',
                        body: _impactBody(category),
                      ),
                    ],
                  ),
                ),
                const _ActionBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _text(String key, String fallback) {
    final value = needData[key];
    if (value == null) return fallback;
    final text = value.toString().trim();
    return text.isEmpty ? fallback : text;
  }

  String get _city {
    final location = _text('location', '');
    if (location.isNotEmpty) return location;
    final city = _text('city', '');
    if (city.isNotEmpty) return city;
    return 'غريان';
  }

  double get _progressValue {
    final value = needData['progress'];
    if (value is num) return value.toDouble().clamp(0.0, 1.0);
    return 0;
  }

  String _imagePath(String category, String title) {
    final image = _text('image', '');
    if (image.isNotEmpty) return image;
    if (category.contains('غذ') || title.contains('سلات')) {
      return 'assets/images/c.png';
    }
    if (category.contains('كس') || title.contains('كسوة')) {
      return 'assets/images/a.png';
    }
    return 'assets/images/b.png';
  }

  String _impactBody(String category) {
    if (category.contains('غذ')) {
      return 'يساعد تبرعك في تأمين وجبات مستقرة ومواد غذائية أساسية للأطفال داخل الدار.';
    }
    if (category.contains('كس')) {
      return 'يساهم دعمك في توفير ملابس وأحذية مناسبة تحفظ راحة الأطفال وكرامتهم.';
    }
    if (category.contains('صح')) {
      return 'يساعد تبرعك في تغطية مستلزمات الرعاية الصحية والاحتياجات الأساسية بسرعة.';
    }
    return 'كل مساهمة تقرّب الاحتياج من الاكتمال وتمنح الأطفال رعاية أكثر استقرارًا وكرامة.';
  }
}

class _FavoriteIndicator extends StatelessWidget {
  const _FavoriteIndicator();

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'المفضلة',
      child: Container(
        width: 42,
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.045),
              blurRadius: 14,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: const Icon(
          Icons.favorite_border_rounded,
          color: AppColors.textDarkPrimary,
          size: 20,
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({
    required this.imagePath,
    required this.title,
    required this.orphanage,
    required this.city,
    required this.description,
    required this.urgency,
  });

  final String imagePath;
  final String title;
  final String orphanage;
  final String city;
  final String description;
  final String urgency;

  @override
  Widget build(BuildContext context) {
    final isUrgent = urgency.contains('عاجل');

    return _SoftCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  imagePath,
                  height: 190,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              if (isUrgent)
                PositionedDirectional(
                  top: 12,
                  start: 12,
                  child: _UrgentBadge(label: urgency),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: DonorTextStyles.title.copyWith(
              fontSize: 20,
              height: 1.35,
              color: AppColors.textDarkPrimary,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => Navigator.pushNamed(context, '/orphanage_profile'),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                orphanage,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: DonorTextStyles.muted.copyWith(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDarkSecondary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            city,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: DonorTextStyles.muted.copyWith(
              fontSize: 12.8,
              color: AppColors.textDarkMuted,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: DonorTextStyles.body.copyWith(
              fontSize: 13.8,
              height: 1.55,
              color: AppColors.textDarkSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickInfoRow extends StatelessWidget {
  const _QuickInfoRow({
    required this.target,
    required this.raised,
    required this.remaining,
    required this.daysLeft,
  });

  final String target;
  final String raised;
  final String remaining;
  final String daysLeft;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _QuickInfoTile(label: 'المطلوب', value: target)),
        const SizedBox(width: 8),
        Expanded(child: _QuickInfoTile(label: 'المجمع', value: raised)),
        const SizedBox(width: 8),
        Expanded(child: _QuickInfoTile(label: 'المتبقي', value: remaining)),
        const SizedBox(width: 8),
        Expanded(child: _QuickInfoTile(label: 'المدة', value: daysLeft)),
      ],
    );
  }
}

class _QuickInfoTile extends StatelessWidget {
  const _QuickInfoTile({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Column(
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: DonorTextStyles.muted.copyWith(
              fontSize: 11,
              color: AppColors.textDarkMuted,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: DonorTextStyles.button.copyWith(
              fontSize: 12,
              color: AppColors.textDarkPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({
    required this.raised,
    required this.target,
    required this.remaining,
    required this.progress,
    required this.percentage,
  });

  final String raised;
  final String target;
  final String remaining;
  final double progress;
  final int percentage;

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'نسبة الإنجاز',
                style: DonorTextStyles.sectionTitle.copyWith(fontSize: 15),
              ),
              const Spacer(),
              Text(
                '$percentage%',
                textDirection: TextDirection.ltr,
                style: DonorTextStyles.title.copyWith(
                  fontSize: 20,
                  color: AppColors.textDarkPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _RtlProgressBar(value: progress),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _AmountStat(label: 'تم جمع', value: raised)),
              Expanded(child: _AmountStat(label: 'المستهدف', value: target)),
              Expanded(child: _AmountStat(label: 'المتبقي', value: remaining)),
            ],
          ),
        ],
      ),
    );
  }
}

class _AmountStat extends StatelessWidget {
  const _AmountStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: DonorTextStyles.muted.copyWith(
            fontSize: 11.5,
            color: AppColors.textDarkMuted,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: DonorTextStyles.button.copyWith(
            fontSize: 12.5,
            color: AppColors.textDarkPrimary,
          ),
        ),
      ],
    );
  }
}

class _TextCard extends StatelessWidget {
  const _TextCard({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: DonorTextStyles.sectionTitle.copyWith(fontSize: 15),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: DonorTextStyles.body.copyWith(
              fontSize: 13.8,
              height: 1.6,
              color: AppColors.textDarkSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar();

  @override
  Widget build(BuildContext context) {
    return donorMobileBottomBar(
      height: 98,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.045),
              blurRadius: 18,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 124,
              child: OutlinedButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/inkind_donation'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  foregroundColor: NeedDetailsScreen._primaryOrange,
                  side: const BorderSide(
                    color: NeedDetailsScreen._primaryOrange,
                    width: 1.2,
                  ),
                  textStyle: DonorTextStyles.button.copyWith(fontSize: 13.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                child: const Text('تبرع عيني'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: FilledButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/financial_donation'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  backgroundColor: NeedDetailsScreen._primaryOrange,
                  foregroundColor: Colors.white,
                  textStyle: DonorTextStyles.button.copyWith(fontSize: 14.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                  elevation: 0,
                ),
                child: const Text('ادعم الآن'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SoftCard extends StatelessWidget {
  const _SoftCard({
    required this.child,
    this.padding = const EdgeInsets.all(14),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _UrgentBadge extends StatelessWidget {
  const _UrgentBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: NeedDetailsScreen._softUrgent,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: DonorTextStyles.badge.copyWith(
          color: Colors.white,
          fontSize: 11,
        ),
      ),
    );
  }
}

class _RtlProgressBar extends StatelessWidget {
  const _RtlProgressBar({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 9,
        color: NeedDetailsScreen._trackColor,
        alignment: Alignment.centerRight,
        child: FractionallySizedBox(
          alignment: Alignment.centerRight,
          widthFactor: value,
          child: Container(
            decoration: const BoxDecoration(
              color: NeedDetailsScreen._primaryOrange,
            ),
          ),
        ),
      ),
    );
  }
}
