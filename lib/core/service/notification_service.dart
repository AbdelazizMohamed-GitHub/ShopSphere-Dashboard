import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:shop_sphere_dashboard/features/users/data/model/notification_model.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static const _scope = 'https://www.googleapis.com/auth/firebase.messaging';
  static const _projectId = 'shopsphere-b422e';
  static const _messagingUrl =
      'https://fcm.googleapis.com/v1/projects/$_projectId/messages:send';

  static Future<String?> getToken() async {
    await _messaging.requestPermission();
    final registeredToken = _messaging.onRegistered.first;
    await _messaging.register();
    return registeredToken;
  }

  static Future<ServiceAccountCredentials> _loadServiceAccount() async {
    final jsonString = await rootBundle.loadString(
      'assets/firebase_service_account.json',
    );
    return ServiceAccountCredentials.fromJson(
      jsonDecode(jsonString) as Map<String, dynamic>,
    );
  }

  static Future<void> sendNotification({
    required NotificationModel notification,
    required String token,
  }) async {
    final credentials = await _loadServiceAccount();
    final client = await clientViaServiceAccount(credentials, [_scope]);
    final imageUrl = notification.imageUrl;
    final message = {
      'message': {
        'token': token,
        'notification': {
          'title': notification.title,
          'body': notification.description,
          if (imageUrl case final String image) 'image': image,
        },
        'data': {
          'type': 'product_offer',
          'date': notification.date.toIso8601String(),
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          if (notification.productId case final String productId)
            'productId': productId,
          if (imageUrl case final String image) 'imageUrl': image,
        },
        if (imageUrl case final String image)
          'android': {
            'notification': {
              'image': image,
              'channel_id': 'high_importance_channel',
            },
          },
      },
    };

    try {
      final response = await client.post(
        Uri.parse(_messagingUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(message),
      );
      if (response.statusCode != 200) {
        throw StateError(
          'FCM send failed (${response.statusCode}): ${response.body}',
        );
      }
    } finally {
      client.close();
    }
  }
}
