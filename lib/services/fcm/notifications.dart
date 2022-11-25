import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

class Notifications{

  final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String>();

  Future init({bool initScheduled = false}) async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = IOSInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: iOS);
    
    await _notifications.initialize(
        settings,
        onSelectNotification: (payload) async {onNotifications.add(payload!);}
        );
  }

  Future notificationsDetails() async {
    return const NotificationDetails(

      android: AndroidNotificationDetails(

        'channel id', 'channel name', importance: Importance.max
      ),
      // iOS: IOSNotificationDetails()
    );
  }

  void showAppointmentsNotifications({int id = 0, String? title, body, payload}) async {
    _notifications.show(id, title, body, await notificationsDetails(), payload: payload);
  }

}