import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class WelcomeProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const WelcomeProgressIndicator({
    super.key,
    required this.currentStep,
    this.totalSteps = 7,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Welcome progress $currentStep of $totalSteps',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(totalSteps, (index) {
          final isActive = index + 1 == currentStep;
          final isPassed = index + 1 < currentStep;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            width: isActive ? 22 : 7,
            height: 7,
            margin: const EdgeInsets.symmetric(horizontal: 3.5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(99),
              color: isActive
                  ? AppColors.brandOrange
                  : isPassed
                      ? Colors.white.withOpacity(0.55)
                      : Colors.white.withOpacity(0.25),
              border: Border.all(
                color: Colors.white.withOpacity(isActive ? 0.42 : 0.16),
                width: 0.8,
              ),
            ),
          );
        }),
      ),
    );
  }
}
