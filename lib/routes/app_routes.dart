import 'package:flutter/material.dart';
import '../presentation/screens/news/news_screen.dart';
import '../presentation/screens/news_details/news_details_screen.dart';
import '../presentation/screens/wishes/wishes_screen.dart';
import '../presentation/screens/membership/membership_screen.dart';
import '../presentation/screens/settings/settings_screen.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/auth/register_screen.dart';

import '../presentation/screens/onboarding/onboarding_screen.dart';

class AppRoutes {
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const news = '/news';
  static const newsDetails = '/news-details';
  static const wishes = '/wishes';
  static const membership = '/membership';
  static const settings = '/settings';

  static Map<String, WidgetBuilder> routes = {
    onboarding: (context) => const OnboardingScreen(),
    login: (context) => const LoginScreen(),
    news: (context) => const NewsScreen(),
    newsDetails: (context) => const NewsDetailsScreen(),
    wishes: (context) => const WishesScreen(),
    membership: (context) => const MembershipScreen(),
    settings: (context) => const SettingsScreen(),
  };
}
