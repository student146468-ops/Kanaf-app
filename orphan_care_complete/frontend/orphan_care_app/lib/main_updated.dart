import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'views/splash_screen.dart';
import 'views/onboarding_screen.dart';
import 'views/role_selection_screen.dart';
import 'views/login_screen.dart'; 
import 'views/register_screen.dart';
import 'views/forgot_password_screen.dart'; 
import 'views/reset_password_screen.dart';

// استيراد واجهات المتبرع (Donor)
import 'views/donor/supporter_home_screen.dart'; 
import 'views/donor/donation_success_screen.dart';
import 'views/donor/donation_history_screen.dart';
import 'views/donor/notifications_screen.dart';
import 'views/donor/search_filter_screen.dart';
import 'views/donor/profile_screen.dart';
import 'views/donor/orphanage_profile_screen.dart';
import 'views/donor/need_details_screen.dart';
import 'views/donor/financial_donation_screen.dart';
import 'views/donor/inkind_donation_screen.dart';

// استيراد واجهات المتطوع (Volunteer)
import 'views/volunteer/home_volunteer_view.dart';
import 'views/volunteer/volunteer_opportunity_details_view.dart';
import 'views/volunteer/apply_opportunity_view.dart';
import 'views/volunteer/my_schedule_view.dart';
import 'views/volunteer/my_volunteer_history_view.dart';
import 'views/volunteer/my_certificates_view.dart';
import 'views/volunteer/notifications_view.dart'; 
import 'views/volunteer/search_filter_view.dart';
import 'views/volunteer/profile_volunteer_view.dart';

// استيراد واجهات دار الرعاية (Care Home)
import 'views/care_home_views/dashboard_screen.dart'; 

// استيراد واجهات الإشعارات والتتبع
import 'views/notifications_tracking/notifications_center_screen.dart';
import 'views/notifications_tracking/track_need_status_screen.dart';
import 'views/notifications_tracking/notification_detail_screen.dart';

// استيراد الثيم والـ Providers
import 'utils/app_theme.dart';
import 'providers/app_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: MaterialApp(
        title: 'تطبيق كَــنَـــفْ',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,  // ✅ تطبيق الثيم الموحد
        initialRoute: '/', 
        
        onGenerateRoute: (settings) {
          Widget page;
          
          switch (settings.name) {
            // ================= المسارات الأساسية =================
            case '/':
              page = const SplashScreen();
              break;
            case '/onboarding':
              page = const OnboardingScreen();
              break;
            case '/role_selection':
              page = const RoleSelectionScreen();
              break;
            case '/login':
              page = const LoginScreen();
              break;
            case '/register':
              page = const RegisterScreen();
              break;
            case '/forgot_password':
              page = const ForgotPasswordScreen();
              break;
            case '/reset_password':
              page = const ResetPasswordScreen();
              break;
              
            // ================= 🏠 مسار دار الرعاية (Care Home) =================
            case '/care_home_home':
              page = const CareHomeDashboardScreen(); 
              break;

            // ================= مسارات المتبرع (Donor) =================
            case '/supporter_home':
              page = const SupporterHomeScreen();
              break;
            case '/donation_success':
              page = const DonationSuccessScreen();
              break;
            case '/donation_history':
              page = const DonationHistoryScreen();
              break;
            case '/notifications':
              page = const NotificationsScreen();
              break;
            case '/search_filter':
              page = const SearchFilterScreen();
              break;
            case '/profile':
              page = const ProfileScreen();
              break;
            case '/orphanage_profile':
              page = const OrphanageProfileScreen();
              break;
            case '/need_details':
              final args = settings.arguments as Map<String, dynamic>? ?? {
                'orphanage': 'دار رعاية الأيتام بغريان',
                'title': 'تأمين كسوة شتوية وأغطية دافئة لـ 25 طفلاً قبل بداية الفصل البارد',
                'raised': '1,200 د.ل',
                'target': '3,500 د.ل',
                'progress': 0.34,
                'daysLeft': '5 أيام',
              };
              page = NeedDetailsScreen(needData: args);
              break;
            case '/financial_donation':
              page = const FinancialDonationScreen();
              break;
            case '/inkind_donation':
              page = const InkindDonationScreen();
              break;
              
            // ================= مسارات المتطوع (Volunteer) =================
            case '/volunteer_home':
              page = const HomeVolunteerView();
              break;
            case '/volunteer_opportunity_details':
              page = const VolunteerOpportunityDetailsView();
              break;
            case '/apply_opportunity':
              page = const ApplyOpportunityView();
              break;
            case '/my_schedule':
              page = const MyScheduleView();
              break;
            case '/my_volunteer_history':
              page = const MyVolunteerHistoryView();
              break;
            case '/my_certificates':
              page = const MyCertificatesView();
              break;
            case '/volunteer_notifications':
              page = const NotificationsView();
              break;
            case '/volunteer_search':
              page = const SearchFilterView(); 
              break;
            case '/volunteer_profile':
              page = const ProfileVolunteerView();
              break;

            // ================= 🔔 مسارات الإشعارات والتتبع =================
            case '/notifications_center':
              page = const NotificationsCenterScreen();
              break;
            case '/track_need_status':
              page = const TrackNeedStatusScreen();
              break;
            case '/notification_detail':
              page = const NotificationDetailScreen();
              break;
              
            default:
              page = const SplashScreen();
          }

          return PageRouteBuilder(
            settings: settings,
            pageBuilder: (context, animation, secondaryAnimation) => page,
            transitionDuration: const Duration(milliseconds: 400),
            reverseTransitionDuration: const Duration(milliseconds: 350),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              final CurvedAnimation curvedAnimation = CurvedAnimation(
                parent: animation,
                curve: Curves.fastLinearToSlowEaseIn,
              );

              return FadeTransition(
                opacity: curvedAnimation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.97, end: 1.0).animate(curvedAnimation),
                  child: child,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
