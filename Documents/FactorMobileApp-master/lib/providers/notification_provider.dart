// import 'dart:convert';

// import 'package:factor_mobile_app/entities/NotificationUser.dart';
// import 'package:factor_mobile_app/service/websocket_service.dart';
// import 'package:factor_mobile_app/utlis/notification_helper.dart';
// import 'package:flutter/foundation.dart';

// class NotificationProvider with ChangeNotifier {
//   List<NotificationModel> _notifications = [];
//   WebSocketService? _webSocketService;

//   List<NotificationModel> get notifications => _notifications;

//   void initializeWebSocket(String userId, String token) {
//     _webSocketService?.disconnect();
//     _webSocketService = WebSocketService(
//       userId: userId,
//       token: token,
//       onNotificationReceived: _handleNotification,
//     );
//     _webSocketService?.connect();
//   }

//   void _handleNotification(NotificationModel notif) {
//     _notifications.insert(0, notif);
//     notifyListeners();
//     showNotification(
//       notif.notificationTitle ?? 'no title',
//       notif.notificationMessage ?? 'NO message',
//     );
//   }

//   void disconnectWebSocket() {
//     _webSocketService?.disconnect();
//     _webSocketService = null;
//   }

//   void clearNotifications() {
//     _notifications.clear();
//     notifyListeners();
//   }
// }
import 'package:factor_mobile_app/entities/NotificationUser.dart';
import 'package:factor_mobile_app/service/websocket_service.dart';
import 'package:factor_mobile_app/utlis/notification_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationProvider with ChangeNotifier {
  List<NotificationModel> _notifications = [];
  WebSocketService? _webSocketService;
  String? _token;
  String? _userId;

  List<NotificationModel> get notifications =>
      _notifications.where((n) => !n.notificationBoolUtil).toList()
        ..sort((a, b) => b.notificationDate!.compareTo(a.notificationDate!));

  int get unreadCount =>
      _notifications.where((n) => !n.notificationRead).length;

  Future<void> initializeWebSocket(String userId, String token) async {
    _userId = userId;
    _token = token;
    _connectWebSocket();
    await fetchInitialNotifications();
  }

  Future<void> fetchInitialNotifications() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://10.0.2.2:8083/factoring/contrat/api/notifications-all'),
        headers: {'Cookie': 'JWT_TOKEN=$_token'},
      );

      if (response.statusCode == 200) {
        final responseBody = response.body;
        print('Raw response: $responseBody'); // Debug logging

        final List<dynamic> data = json.decode(responseBody);
        print('Parsed data: $data'); // Debug logging

        _notifications = data
            .map((json) {
              try {
                return NotificationModel.fromJson(json);
              } catch (e) {
                print('Error parsing notification item: $e');
                print('Problematic JSON: $json');
                return null;
              }
            })
            .whereType<NotificationModel>()
            .toList();

        notifyListeners();
      } else {
        print(
            'Failed to fetch notifications. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error fetching notifications: $e');
    }
  }

  void _connectWebSocket() {
    if (_userId == null || _token == null) return;

    _webSocketService = WebSocketService(
      userId: _userId!,
      token: _token!,
      onNotificationReceived: _handleWebSocketNotification,
    );
    _webSocketService?.connect();
  }

  void _handleWebSocketNotification(NotificationModel notif) {
    final exists = _notifications.any((n) => n.id == notif.id);
    if (!exists) {
      _notifications.insert(0, notif);
      notifyListeners();
      showNotification(
        notif.notificationTitle ?? 'New Notification',
        notif.notificationMessage ?? 'You have a new notification',
      );
    }
  }

  Future<void> markAsRead(int id) async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://10.0.2.2:8083/factoring/contrat/api/notifications-read/$id'),
        headers: {'Cookie': 'JWT_TOKEN=$_token'},
      );

      if (response.statusCode == 200) {
        _notifications = _notifications.map((n) {
          return n.id == id ? n.copyWith(notificationRead: true) : n;
        }).toList();
        notifyListeners();
      }
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  void disconnectWebSocket() {
    _webSocketService?.disconnect();
    _webSocketService = null;
  }

  @override
  void dispose() {
    _webSocketService?.disconnect();
    super.dispose();
  }
}
