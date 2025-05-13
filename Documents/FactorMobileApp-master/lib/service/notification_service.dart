// import 'dart:convert';
// import 'package:factor_mobile_app/entities/NotificationUser.dart';
// import 'package:http/http.dart' as http;

// class NotificationService {
//   final String baseUrl;
//   final String token;

//   NotificationService({required this.baseUrl, required this.token});

//   Future<List<NotificationModel>> getAllNotifications() async {
//     final response = await http.get(
//       Uri.parse('$baseUrl/factoring/contrat/api/notifications-all'),
//       headers: {
//         'Cookie': 'JWT_TOKEN=$token',
//         'Content-Type': 'application/json',
//       },
//     );

//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body);
//       return data.map((json) => NotificationModel.fromApiJson(json)).toList();
//     } else {
//       throw Exception('Failed to load notifications');
//     }
//   }

//   Future<void> markAsRead(int id) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/factoring/contrat/api/notifications-read/$id'),
//       headers: {
//         'Cookie': 'JWT_TOKEN=$token',
//         'Content-Type': 'application/json',
//       },
//     );

//     if (response.statusCode != 200) {
//       throw Exception('Failed to mark notification as read');
//     }
//   }

//   Future<NotificationModel> getNotificationById(int id) async {
//     final response = await http.get(
//       Uri.parse('$baseUrl/factoring/contrat/api/notification/$id'),
//       headers: {
//         'Cookie': 'JWT_TOKEN=$token',
//         'Content-Type': 'application/json',
//       },
//     );

//     if (response.statusCode == 200) {
//       return NotificationModel.fromApiJson(json.decode(response.body));
//     } else {
//       throw Exception('Failed to load notification');
//     }
//   }

//   Future<NotificationModel> getNotificationByNotes(int id) async {
//     final response = await http.get(
//       Uri.parse('$baseUrl/factoring/contrat/api/notification-notes-by-id/$id'),
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       },
//     );

//     if (response.statusCode == 200) {
//       return NotificationModel.fromApiJson(json.decode(response.body));
//     } else {
//       throw Exception('Failed to load notification notes');
//     }
//   }
// }
