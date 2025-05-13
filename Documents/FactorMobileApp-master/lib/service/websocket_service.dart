// import 'dart:convert';
// import 'package:factor_mobile_app/entities/NotificationUser.dart';
// import 'package:stomp_dart_client/stomp.dart';
// import 'package:stomp_dart_client/stomp_config.dart';
// import 'package:stomp_dart_client/stomp_frame.dart';

// class WebSocketService {
//   final String userId;
//   final Function(NotificationModel) onNotificationReceived;
//   late StompClient stompClient;
//   final String token;

//   WebSocketService({
//     required this.userId,
//     required this.onNotificationReceived,
//     required this.token,
//   });

//   void connect() {
//     stompClient = StompClient(
//       config: StompConfig.SockJS(
//         url: 'http://10.0.2.2:8083/factoring/contrat/ws',
//         onConnect: onConnect,
//         onWebSocketError: (error) => print('WebSocket Error: $error'),
//         stompConnectHeaders: {
//           'Cookie': 'JWT_TOKEN=$token',
//         },
//         webSocketConnectHeaders: {
//           'Cookie': 'JWT_TOKEN=$token',
//         },
//       ),
//     );
//     stompClient.activate();
//   }

//   void onConnect(StompFrame frame) {
//     print('✅ Connected to WebSocket');

//     stompClient.subscribe(
//       destination: '/user/queue/task-events',
//       callback: (frame) {
//         if (frame.body != null) {
//           final jsonData = json.decode(frame.body!);
//           print(jsonData);
//           final notif = NotificationModel.fromJson(jsonData);
//           print(notif);
//           onNotificationReceived(notif);
//         }
//       },
//     );
//   }

//   void disconnect() {
//     stompClient.deactivate();
//   }
// }
import 'dart:convert';
import 'package:factor_mobile_app/entities/NotificationUser.dart';
import 'package:factor_mobile_app/utlis/notification_helper.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class WebSocketService {
  final String userId;
  final Function(NotificationModel) onNotificationReceived;
  late StompClient stompClient;
  final String token;

  WebSocketService({
    required this.userId,
    required this.onNotificationReceived,
    required this.token,
  });

  void connect() {
    stompClient = StompClient(
      config: StompConfig.SockJS(
        url: 'http://10.0.2.2:8083/factoring/contrat/ws',
        onConnect: onConnect,
        onWebSocketError: (error) => print('WebSocket Error: $error'),
        stompConnectHeaders: {'Cookie': 'JWT_TOKEN=$token'},
        webSocketConnectHeaders: {'Cookie': 'JWT_TOKEN=$token'},
        onStompError: (error) => print('STOMP Error: $error'),
        onDisconnect: (frame) => print('Disconnected from WebSocket'),
      ),
    );
    stompClient.activate();
  }

  void onConnect(StompFrame frame) {
    stompClient.subscribe(
      destination: '/user/queue/task-events',
      callback: (frame) {
        if (frame.body != null) {
          try {
            final jsonData = json.decode(frame.body!);
            final notif = NotificationModel.fromSocket(jsonData);
            onNotificationReceived(notif);
          } catch (e) {
            print('Error processing notification: $e');
          }
        }
      },
    );
  }

  void disconnect() {
    if (stompClient.connected) {
      stompClient.deactivate();
    }
  }
}
