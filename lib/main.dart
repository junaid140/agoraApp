import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:videoapp/views/pages/index.dart';
import 'package:firebase_core/firebase_core.dart';



Future<void> backgroundHandler(RemoteMessage? message) async{
  RemoteNotification? notification = message!.notification;
  AndroidNotification? android = message.notification!.android;
  AppleNotification? apple = message.notification!.apple;
  if(notification != null){
    flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            color: Colors.blue,
            playSound: true,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: IOSNotificationDetails(
            presentSound: true,
            subtitle: message.notification!.body,
          ),
        ));
    print("Notification Received");
  }

  print(message.data.toString());
  print(message.notification!.title);
}
class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String title;
  final String body;
  final String payload;
}
AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', 'High Importance Notification',
    importance: Importance.max, playSound: true
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
 await  FirebaseMessaging.onMessage;

  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home:  IndexPage(),
    );
  }
}
