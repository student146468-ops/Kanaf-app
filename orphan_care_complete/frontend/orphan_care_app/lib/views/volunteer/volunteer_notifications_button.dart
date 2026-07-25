import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

class VolunteerNotificationsButton extends StatelessWidget {
  const VolunteerNotificationsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 44,
      child: IconButton(
        tooltip: 'الإشعارات',
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints.tightFor(width: 44, height: 44),
        splashRadius: 22,
        icon: const Icon(
          Icons.notifications_none_rounded,
          color: AppColors.textDarkPrimary,
          size: 23,
        ),
        onPressed: () {
          if (ModalRoute.of(context)?.settings.name ==
              '/volunteer_notifications') {
            return;
          }
          Navigator.of(context).pushNamed('/volunteer_notifications');
        },
      ),
    );
  }
}
