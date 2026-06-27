import 'package:flutter/material.dart';

const Color _onboardingOrange = Color(0xFFFF7A00);
const Color _onboardingText = Color(0xFF1E1E1E);
const Color _onboardingMuted = Color(0xFF5F6368);
const Color _dotInactive = Color(0xFFE5E7EB);

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const List<_OnboardingSlideData> _slides = [
    _OnboardingSlideData(
      titleLineOne: 'تبرعك...',
      titleLineTwo: 'يصل لمن يحتاجه',
      description:
          'ساهم بما تستطيع من غذاء أو ملابس أو مستلزمات أو تبرعات مالية، وساعد دور رعاية الأيتام على تلبية احتياجاتها الحقيقية بكل سهولة وشفافية.',
      imagePath: 'assets/images/image11.png',
    ),
    _OnboardingSlideData(
      titleLineOne: 'شارك بوقتك...',
      titleLineTwo: 'واصنع أثرًا',
      description:
          'قدّم مهاراتك في التعليم أو الترفيه أو الإرشاد أو أي مجال تستطيع المساهمة فيه، وكن سببًا في رسم الابتسامة على وجوه الأطفال.',
      imagePath: 'assets/images/image12.png',
    ),
    _OnboardingSlideData(
      titleLineOne: 'سجّل',
      titleLineTwo: 'دار الرعاية',
      description: 'سجّل دار رعاية الأيتام\nبك، وأدر احتياجات الأيتام المسجلين لديك بسهولة،\nوانشر طلبات الدعم لتصل إلى الداعمين والمتطوعين بكل شفافية.',
      imagePath: 'assets/images/image13.png',
    ),
    _OnboardingSlideData(
      titleLineOne: 'ابدأ رحلتك',
      titleLineTwo: 'الإنسانية',
      description: 'كل خطوة صغيرة\nتحدث فرقًا كبيرًا\nفي حياة شخص ما.',
      imagePath: 'assets/images/image14.png',
    ),
  ];

  bool get _isLastPage => _currentPage == _slides.length - 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goNext() {
    if (_isLastPage) {
      Navigator.of(context).pushReplacementNamed('/role_selection');
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
  }

  void _skip() {
    Navigator.of(context).pushReplacementNamed('/role_selection');
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final containerWidth = width > 600 ? 430.0 : double.infinity;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SizedBox(
            width: containerWidth,
            height: double.infinity,
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      physics: const BouncingScrollPhysics(),
                      onPageChanged: (index) {
                        setState(() => _currentPage = index);
                      },
                      itemCount: _slides.length,
                      itemBuilder: (context, index) {
                        return _OnboardingSlide(slide: _slides[index]);
                      },
                    ),
                  ),
                  _PageDots(currentPage: _currentPage, count: _slides.length),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(28, 0, 28, 30),
                    child: _isLastPage
                        ? Center(
                            child: SizedBox(
                              width: double.infinity,
                              child: _PrimaryButton(
                                label: 'ابدأ الآن',
                                onTap: _goNext,
                              ),
                            ),
                          )
                        : Row(
                            children: [
                              _TextActionButton(label: 'تخطي', onTap: _skip),
                              const Spacer(),
                              SizedBox(
                                width: 154,
                                child: _PrimaryButton(
                                  label: 'التالي',
                                  onTap: _goNext,
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
      ),
    );
  }
}

class _OnboardingSlideData {
  final String titleLineOne;
  final String titleLineTwo;
  final String description;
  final String imagePath;

  const _OnboardingSlideData({
    required this.titleLineOne,
    required this.titleLineTwo,
    required this.description,
    required this.imagePath,
  });
}

class _OnboardingSlide extends StatelessWidget {
  final _OnboardingSlideData slide;

  const _OnboardingSlide({required this.slide});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          const SizedBox(height: 34),
          Text(
            slide.titleLineOne,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Cairo',
              color: _onboardingText,
              fontSize: 31,
              height: 1.18,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            slide.titleLineTwo,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Cairo',
              color: _onboardingOrange,
              fontSize: 31,
              height: 1.18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            slide.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Tajawal',
              color: _onboardingMuted,
              fontSize: 17,
              height: 1.55,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: Image.asset(
                slide.imagePath,
                fit: BoxFit.contain,
                width: double.infinity,
                errorBuilder: (_, __, ___) {
                  return const Icon(
                    Icons.image_not_supported_outlined,
                    color: _onboardingOrange,
                    size: 58,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  final int currentPage;
  final int count;

  const _PageDots({required this.currentPage, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      textDirection: TextDirection.rtl,
      children: List.generate(
        count,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOut,
          width: currentPage == index ? 22 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: currentPage == index ? _onboardingOrange : _dotInactive,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PrimaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _onboardingOrange,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: _onboardingOrange.withOpacity(0.20),
                blurRadius: 18,
                offset: const Offset(0, 9),
              ),
            ],
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Cairo',
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _TextActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _TextActionButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: _onboardingOrange,
        minimumSize: const Size(74, 48),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        textStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 15.5,
          fontWeight: FontWeight.w900,
        ),
      ),
      child: Text(label),
    );
  }
}
