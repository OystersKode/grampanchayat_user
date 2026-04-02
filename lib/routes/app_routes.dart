import 'package:flutter/material.dart';
import '../presentation/screens/news/news_screen.dart';
import '../presentation/screens/news_details/news_details_screen.dart';
import '../presentation/screens/wishes/wishes_screen.dart';
import '../presentation/screens/profile/profile_screen.dart';
import '../presentation/screens/auth/signup_screen.dart';
import '../presentation/screens/auth/signin_screen.dart';

class AppRoutes {
  static const news = '/news';
  static const newsDetails = '/news-details';
  static const wishes = '/wishes';
  static const profile = '/profile';
  static const signup = '/signup';
  static const signin = '/signin';

  static Map<String, WidgetBuilder> routes = {
    news: (context) => const NewsScreen(),
    newsDetails: (context) => const NewsDetailsScreen(),
    wishes: (context) => const WishesScreen(),
    profile: (context) => const ProfileScreen(),
    signup: (context) => const SignupScreen(),
    signin: (context) => const SignInScreen(),
  };
}
