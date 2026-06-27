import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../data/repositories/app_repository.dart';
import '../presentation/screens/news_details/news_details_screen.dart';
import '../presentation/screens/wishes/wish_details_screen.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<void> initialize() async {
    // 1. Request permissions (especially for iOS)
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    }

    // 2. Initialize Local Notifications for Foreground messages
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          _handleNotificationClick(response.payload!);
        }
      },
    );

    // 3. Handle Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'High Importance Notifications',
              importance: Importance.max,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
            ),
          ),
          payload: _serializePayload(message.data),
        );
      }
    });

    // 4. Handle Background/Terminated messages (when clicked)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationClick(_serializePayload(message.data));
    });

    // Check if app was opened from a terminated state via a notification
    RemoteMessage? initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationClick(_serializePayload(initialMessage.data));
    }

    // 5. Save Token and listen for refreshes
    _saveToken();
    _fcm.onTokenRefresh.listen((newToken) {
      _saveToken(newToken);
    });

    // 6. Subscribe to topics
    await _fcm.subscribeToTopic('all_users');
    await _fcm.subscribeToTopic('announcements');
    await _fcm.subscribeToTopic('news');
    await _fcm.subscribeToTopic('advertisements');
    await _fcm.subscribeToTopic('institutes');
  }

  String _serializePayload(Map<String, dynamic> data) {
    return "${data['type']}|${data['id']}";
  }

  void _handleNotificationClick(String payload) async {
    final parts = payload.split('|');
    if (parts.length < 2) return;

    final type = parts[0];
    final id = parts[1];

    if (type == 'news') {
      try {
        final newsItem = await AppRepository.instance.getNewsDetails(id);
        navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (context) => NewsDetailsScreen(news: newsItem)),
        );
      } catch (e) {
        print('Error fetching news for deep link: $e');
      }
    } else if (type == 'wishes') {
      try {
        final wishes = await AppRepository.instance.getWishes();
        final wish = wishes.firstWhere((w) => w.id == id);
        navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (context) => WishDetailsScreen(wish: wish)),
        );
      } catch (e) {
        print('Error fetching wish for deep link: $e');
      }
    } else if (type == 'announcement') {
      navigatorKey.currentState?.pushNamed(AppRoutes.announcements);
    } else if (type == 'advertisement') {
      navigatorKey.currentState?.pushNamed(AppRoutes.advertisements);
    } else if (type == 'institute') {
      navigatorKey.currentState?.pushNamed(AppRoutes.institutes);
    }
  }

  Future<void> _saveToken([String? token]) async {
    try {
      token ??= await _fcm.getToken();
      if (token != null) {
        await FirebaseFirestore.instance.collection('user_tokens').doc(token).set({
          'token': token,
          'createdAt': FieldValue.serverTimestamp(),
          'platform': Platform.isAndroid ? 'android' : 'ios',
        }, SetOptions(merge: true));
        print('FCM Token saved successfully');
      }
    } catch (e) {
      print('Error saving FCM token: $e');
    }
  }
}
