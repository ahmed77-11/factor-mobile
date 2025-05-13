import 'package:intl/intl.dart';

class NotificationModel {
  final int? id;
  final int? userId;
  final String? notificationType;
  final String? notificationTitle;
  final String? notificationMessage;
  final DateTime? notificationDate;
  final bool notificationRead;
  final DateTime? notificationReadDate;
  final String? notificationTaskId;
  final String? notificationContratNo;
  final int? notificationContratId;
  final bool notificationBoolUtil;

  NotificationModel({
    this.id,
    this.userId,
    this.notificationType,
    this.notificationTitle,
    this.notificationMessage,
    this.notificationDate,
    this.notificationRead = false,
    this.notificationReadDate,
    this.notificationTaskId,
    this.notificationContratNo,
    this.notificationContratId,
    this.notificationBoolUtil = false,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    try {
      return NotificationModel(
        id: _parseInt(json['id']),
        userId: _parseInt(json['userId']),
        notificationType: json['notificationType']?.toString(),
        notificationTitle: json['notificationTitle']?.toString(),
        notificationMessage: json['notificationMessage']?.toString(),
        notificationDate: json['notificationDate'] != null
            ? DateTime.tryParse(json['notificationDate'].toString())
            : null,
        notificationRead: json['notificationRead'] ?? false,
        notificationReadDate: json['notificationReadDate'] != null
            ? DateTime.tryParse(json['notificationReadDate'].toString())
            : null,
        notificationTaskId: json['notificationTaskId']?.toString(),
        notificationContratNo: json['notificationContratNo']?.toString(),
        notificationContratId: _parseInt(json['notificationContratId']),
        notificationBoolUtil: json['notificationBoolUtil'] ?? false,
      );
    } catch (e) {
      print('Error creating NotificationModel from JSON: $e');
      print('Problematic JSON: $json');
      rethrow;
    }
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  factory NotificationModel.fromSocket(Map<String, dynamic> json) {
    final payload = json['payload'] as Map<String, dynamic>;
    return NotificationModel(
      id: payload['id'],
      userId: payload['userId'],
      notificationType: json['eventType'],
      notificationTitle: payload['title'],
      notificationMessage: payload['message'],
      notificationDate: DateTime.fromMillisecondsSinceEpoch(
        int.parse(
          payload['createdAt'].toString(),
        ),
      ),
      notificationRead: payload['read'] ?? false,
      notificationTaskId: json['taskId'],
      notificationContratNo: payload['contratNo'],
      notificationContratId: payload['contratId'],
    );
  }

  NotificationModel copyWith({
    int? id,
    int? userId,
    String? notificationType,
    String? notificationTitle,
    String? notificationMessage,
    DateTime? notificationDate,
    bool? notificationRead,
    DateTime? notificationReadDate,
    String? notificationTaskId,
    String? notificationContratNo,
    int? notificationContratId,
    bool? notificationBoolUtil,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      notificationType: notificationType ?? this.notificationType,
      notificationTitle: notificationTitle ?? this.notificationTitle,
      notificationMessage: notificationMessage ?? this.notificationMessage,
      notificationDate: notificationDate ?? this.notificationDate,
      notificationRead: notificationRead ?? this.notificationRead,
      notificationReadDate: notificationReadDate ?? this.notificationReadDate,
      notificationTaskId: notificationTaskId ?? this.notificationTaskId,
      notificationContratNo:
          notificationContratNo ?? this.notificationContratNo,
      notificationContratId:
          notificationContratId ?? this.notificationContratId,
      notificationBoolUtil: notificationBoolUtil ?? this.notificationBoolUtil,
    );
  }

  String get formattedDate {
    return notificationDate != null
        ? DateFormat('MMM dd, yyyy - HH:mm').format(notificationDate!)
        : '';
  }
}
