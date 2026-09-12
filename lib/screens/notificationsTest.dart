import 'package:flutter/material.dart';
import 'package:steady_just_study/services/notification_service.dart';

class Notificationstest extends StatelessWidget {
  static String routeName = '/notifications';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Test Screen")),
      body: ElevatedButton(
        onPressed: () => NotificationService.instance.showTestNotification(),
        child: Text('Test Notification'),
      ),
    );
  }
}
