import 'package:flutter/material.dart';

import 'providers/app_provider.dart';
import 'providers/app_provider_scope.dart';
import 'views/about/about_app_screen.dart';
import 'views/care_home_views/add_need_screen.dart';
import 'views/care_home_views/care_home_profile_screen.dart';
import 'views/care_home_views/dashboard_screen.dart';
import 'views/care_home_views/edit_need_screen.dart';
import 'views/care_home_views/edit_profile_screen.dart';
import 'views/care_home_views/incoming_donations_screen.dart';
import 'views/care_home_views/manage_volunteers_screen.dart';
import 'views/care_home_views/need_details_screen.dart' as care_home_need;
import 'views/care_home_views/needs_list_screen.dart';
import 'views/care_home_views/notifications_screen.dart'
    as care_home_notifications;
import 'views/care_home_views/rate_volunteers_screen.dart';
import 'views/care_home_views/reports_stats_screen.dart';
import 'views/care_home_views/visit_hours_screen.dart';
import 'views/discovery_search/explore_orphanages_screen.dart';
import 'views/discovery_search/search_filter_results_screen.dart';
import 'views/donor/donation_history_screen.dart';
import 'views/donor/donation_success_screen.dart';
import 'views/donor/financial_donation_screen.dart';
import 'views/donor/inkind_donation_screen.dart';
import 'views/donor/need_details_screen.dart';
import 'views/donor/notifications_screen.dart';
import 'views/donor/orphanage_profile_screen.dart';
import 'views/donor/profile_screen.dart';
import 'views/donor/search_filter_screen.dart';
import 'views/donor/supporter_home_screen.dart';
import 'views/forgot_password_screen.dart';
import 'views/login_screen.dart';
import 'views/notifications_tracking/notification_detail_screen.dart';
import 'views/notifications_tracking/notifications_center_screen.dart';
import 'views/notifications_tracking/track_need_status_screen.dart';
import 'views/onboarding_screen.dart';
import 'views/register_screen.dart';
import 'views/reset_password_screen.dart';
import 'views/role_selection_screen.dart';
import 'views/settings/change_password_screen.dart';
import 'views/settings/settings_screen.dart';
import 'views/splash_screen.dart';
import 'views/volunteer/apply_opportunity_view.dart';
import 'views/volunteer/home_volunteer_view.dart';
import 'views/volunteer/my_certificates_view.dart';
import 'views/volunteer/my_schedule_view.dart';
import 'views/volunteer/my_volunteer_history_view.dart';
import 'views/volunteer/notifications_view.dart';
import 'views/volunteer/profile_volunteer_view.dart';
import 'views/volunteer/search_filter_view.dart';
import 'views/volunteer/volunteer_opportunity_details_view.dart';

void main() {
  runApp(
    AppProviderScope(
      provider: AppProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تطبيق كنف',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        final page = _buildPage(settings);

        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 400),
          reverseTransitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.fastLinearToSlowEaseIn,
            );

            return FadeTransition(
              opacity: curvedAnimation,
              child: ScaleTransition(
                scale: Tween<double>(
                  begin: 0.97,
                  end: 1,
                ).animate(curvedAnimation),
                child: child,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPage(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return const SplashScreen();
      case '/onboarding':
        return const OnboardingScreen();
      case '/role_selection':
        return const RoleSelectionScreen();
      case '/login':
        return const LoginScreen();
      case '/register':
        return const RegisterScreen();
      case '/forgot_password':
        return const ForgotPasswordScreen();
      case '/reset_password':
      case '/otp':
        return const ResetPasswordScreen();

      case '/care_home_home':
      case '/care_home_dashboard':
        return const CareHomeDashboardScreen();
      case '/care_home_add_need':
        return const AddNeedScreen();
      case '/care_home_needs_list':
        return const NeedsListScreen();
      case '/care_home_need_details':
        return const care_home_need.NeedDetailsScreen();
      case '/care_home_edit_need':
        return const EditNeedScreen();
      case '/care_home_incoming_donations':
        return const IncomingDonationsScreen();
      case '/care_home_manage_volunteers':
        return const ManageVolunteersScreen();
      case '/care_home_visit_hours':
        return const VisitHoursScreen();
      case '/care_home_reports':
        return const ReportsStatsScreen();
      case '/care_home_rate_volunteers':
        return const RateVolunteersScreen();
      case '/care_home_profile':
        return const CareHomeProfileScreen();
      case '/care_home_edit_profile':
        return const EditProfileScreen();
      case '/care_home_notifications':
        return const care_home_notifications.NotificationsScreen();

      case '/home':
      case '/supporter_home':
        return const SupporterHomeScreen();
      case '/donation_success':
        return const DonationSuccessScreen();
      case '/donation_history':
        return const DonationHistoryScreen();
      case '/notifications':
        return const NotificationsScreen();
      case '/search_filter':
        return const SearchFilterScreen();
      case '/profile':
        return const ProfileScreen();
      case '/orphanage_profile':
        return const OrphanageProfileScreen();
      case '/need_details':
        final args = settings.arguments as Map<String, dynamic>? ??
            {
              'orphanage': 'دار رعاية الأيتام بغريان',
              'title':
                  'تأمين كسوة شتوية وأغطية دافئة لـ 25 طفلًا قبل بداية الفصل البارد',
              'raised': '1,200 د.ل',
              'target': '3,500 د.ل',
              'progress': 0.34,
              'daysLeft': '5 أيام',
            };
        return NeedDetailsScreen(needData: args);
      case '/financial_donation':
        return const FinancialDonationScreen();
      case '/inkind_donation':
        return const InkindDonationScreen();

      case '/volunteer_home':
      case '/home_volunteer':
        return const HomeVolunteerView();
      case '/volunteer_opportunity_details':
        return const VolunteerOpportunityDetailsView();
      case '/apply_opportunity':
        return const ApplyOpportunityView();
      case '/my_schedule':
        return const MyScheduleView();
      case '/my_volunteer_history':
        return const MyVolunteerHistoryView();
      case '/my_certificates':
        return const MyCertificatesView();
      case '/volunteer_notifications':
        return const NotificationsView();
      case '/volunteer_search':
        return const SearchFilterView();
      case '/volunteer_profile':
        return const ProfileVolunteerView();

      case '/explore_orphanages':
        return const ExploreOrphanagesScreen();
      case '/search_filter_results':
        return const SearchFilterResultsScreen();
      case '/settings':
        return const SettingsScreen();
      case '/change_password':
        return const ChangePasswordScreen();
      case '/about_app':
        return const AboutAppScreen();

      case '/notifications_center':
        return const NotificationsCenterScreen();
      case '/track_need_status':
        return const TrackNeedStatusScreen();
      case '/notification_detail':
        return const NotificationDetailScreen();
      default:
        return const SplashScreen();
    }
  }
}
