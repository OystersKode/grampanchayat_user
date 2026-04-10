import 'package:flutter/material.dart';
import '../presentation/screens/news/news_screen.dart';
import '../presentation/screens/news_details/news_details_screen.dart';
import '../presentation/screens/wishes/wishes_screen.dart';
import '../presentation/screens/membership/membership_screen.dart';
import '../presentation/screens/settings/settings_screen.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/auth/register_screen.dart';
import '../presentation/screens/feedback/feedback_screen.dart';
import '../presentation/screens/announcements/announcements_screen.dart';
import '../presentation/screens/villages/villages_screen.dart';
import '../presentation/screens/vehicles/vehicles_screen.dart';
import '../presentation/screens/onboarding/onboarding_screen.dart';

class AppRoutes {
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const news = '/news';
  static const newsDetails = '/news-details';
  static const wishes = '/wishes';
  static const membership = '/membership';
  static const settings = '/settings';
  static const feedback = '/feedback';
  static const announcements = '/announcements';
  static const villages = '/villages';
  static const vehicles = '/vehicles';

  static Map<String, WidgetBuilder> routes = {
    onboarding: (context) => const OnboardingScreen(),
    login: (context) => const LoginScreen(),
    news: (context) => const NewsScreen(),
    newsDetails: (context) => const NewsDetailsScreen(),
    wishes: (context) => const WishesScreen(),
    membership: (context) => const MembershipScreen(),
    settings: (context) => const SettingsScreen(),
    feedback: (context) => const FeedbackScreen(),
    announcements: (context) => const AnnouncementsScreen(),
    villages: (context) => const VillagesScreen(),
    vehicles: (context) => const VehiclesScreen(),
  };
}
