// import 'package:factor_mobile_app/entities/NotificationUser.dart';
// import 'package:factor_mobile_app/providers/AuthProvider.dart';
// import 'package:factor_mobile_app/providers/notification_provider.dart';
// import 'package:factor_mobile_app/service/websocket_service.dart';
// import 'package:factor_mobile_app/utlis/notification_helper.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class NotificationPage extends StatefulWidget {
//   final String userId;
//   final String token;
//   NotificationPage({
//     required this.userId,
//     required this.token,
//   });

//   @override
//   _NotificationPageState createState() => _NotificationPageState();
// }

// class _NotificationPageState extends State<NotificationPage> {
//   @override
//   Widget build(BuildContext context) {
//     final notificationProvider = Provider.of<NotificationProvider>(context);

//     return Scaffold(
//       appBar: AppBar(title: Text('Notifications')),
//       body: ListView.builder(
//         itemCount: notificationProvider.notifications.length,
//         itemBuilder: (context, index) {
//           final notif = notificationProvider.notifications[index];
//           return ListTile(
//             leading: Icon(Icons.notifications),
//             title: Text(notif.notificationTitle ?? 'No Title'),
//             subtitle: Text(notif.notificationMessage ?? 'No Message'),
//             trailing: Text('${notif.notificationDate?.toString()}'),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:factor_mobile_app/entities/NotificationUser.dart';
import 'package:factor_mobile_app/providers/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  final String userId;
  final String token;

  const NotificationPage({
    required this.userId,
    required this.token,
    Key? key,
  }) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationProvider>(context, listen: false)
          .initializeWebSocket(widget.userId, widget.token);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NotificationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => provider.fetchInitialNotifications(),
              ),
              if (provider.unreadCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      provider.unreadCount.toString(),
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: _buildNotificationList(provider),
    );
  }

  Widget _buildNotificationList(NotificationProvider provider) {
    if (provider.notifications.isEmpty) {
      return const Center(child: Text('No notifications available'));
    }

    return RefreshIndicator(
      onRefresh: () => provider.fetchInitialNotifications(),
      child: ListView.builder(
        itemCount: provider.notifications.length,
        itemBuilder: (context, index) {
          final notification = provider.notifications[index];
          return _buildNotificationTile(notification);
        },
      ),
    );
  }

  Widget _buildNotificationTile(NotificationModel notification) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Icon(
          Icons.notifications,
          color: notification.notificationRead
              ? Colors.grey
              : Theme.of(context).primaryColor,
        ),
        title: Text(
          notification.notificationTitle ?? 'No title',
          style: TextStyle(
            fontWeight: notification.notificationRead
                ? FontWeight.normal
                : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.notificationMessage ?? 'No message'),
            const SizedBox(height: 4),
            Text(
              notification.formattedDate,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
        trailing: notification.notificationRead
            ? null
            : const Icon(Icons.circle, color: Colors.red, size: 12),
        onTap: () => _handleNotificationTap(notification),
      ),
    );
  }

  void _handleNotificationTap(NotificationModel notification) {
    Provider.of<NotificationProvider>(context, listen: false)
        .markAsRead(notification.id!);

    // Add your custom navigation logic here if needed
  }
}
