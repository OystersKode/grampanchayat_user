import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import '../data/repositories/app_repository.dart';
import '../presentation/screens/news_details/news_details_screen.dart';
import '../presentation/screens/wishes/wish_details_screen.dart';
import 'notification_service.dart';

class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  Future<void> initialize() async {
    _appLinks = AppLinks();

    // 1. Handle links when app is in background or terminated
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      _handleDeepLink(initialUri);
    }

    // 2. Handle links when app is in foreground
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      _handleDeepLink(uri);
    });
  }

  void _handleDeepLink(Uri uri) async {
    debugPrint('Received Deep Link: $uri');
    
    // Path structure expected: /news/ID or /wishes/ID
    final pathSegments = uri.pathSegments;
    if (pathSegments.length < 2) return;

    final type = pathSegments[0];
    final id = pathSegments[1];

    final navigator = NotificationService.navigatorKey.currentState;
    if (navigator == null) {
      debugPrint('Navigator state is null, cannot navigate');
      return;
    }

    if (type == 'news') {
      try {
        final newsItem = await AppRepository.instance.getNewsDetails(id);
        navigator.push(
          MaterialPageRoute(builder: (context) => NewsDetailsScreen(news: newsItem)),
        );
      } catch (e) {
        debugPrint('Error fetching news for deep link: $e');
      }
    } else if (type == 'wishes') {
      try {
        final wishes = await AppRepository.instance.getWishes();
        final wish = wishes.firstWhere((w) => w.id == id);
        navigator.push(
          MaterialPageRoute(builder: (context) => WishDetailsScreen(wish: wish)),
        );
      } catch (e) {
        debugPrint('Error fetching wish for deep link: $e');
      }
    }
  }

  void dispose() {
    _linkSubscription?.cancel();
  }
}
