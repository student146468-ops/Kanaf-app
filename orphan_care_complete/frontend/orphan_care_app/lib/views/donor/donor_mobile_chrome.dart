import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

const double donorMobileMaxWidth = 480;

PreferredSizeWidget donorMobileAppBar({
  required String title,
  Widget? leading,
  List<Widget>? actions,
}) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(kToolbarHeight),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: donorMobileMaxWidth),
        child: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          leading: leading,
          title: Text(
            title,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppColors.textDarkPrimary,
            ),
          ),
          actions: actions,
        ),
      ),
    ),
  );
}

Widget donorMobileBottomBar({
  required Widget child,
  double height = 68,
}) {
  return SizedBox(
    height: height,
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: donorMobileMaxWidth),
        child: child,
      ),
    ),
  );
}
