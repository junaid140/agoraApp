import 'dart:io';
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';

import '../../constants/general_constant.dart';
// import 'package:medcaremobileapp/screens/incoming_call.dart';




class PushNotificationServices {

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  CollectionReference callingDocRef = FirebaseFirestore.instance.collection(
      'calls');

  Future<String?> getToken() async {
    String? token = await firebaseMessaging.getToken();
    print('--------------token: $token');
    await FirebaseFirestore.instance.collection('blanguser').doc(
        FirebaseAuth.instance.currentUser!.uid).update({
      'token': token,
    });

  }

  String getClientRequestId(Map<String, dynamic> message) {
    String roomId = "";
    if (Platform.isAndroid) {
      roomId = message['roomId'];
      print('-------client request id $roomId');
    } else {
      roomId = message['roomId'];
      // print('0000000------0000000-----client request id $clientRequestId');
    }
    return roomId;
  }

  retrieveClientRequestData(String requestId, BuildContext context) {
    callingDocRef.doc(requestId).get().then((value) async {
      Map callInfo = {
        'channel_id': value.get("channel_id"),
        'senderName': value.get("channel_id"),
        'senderPicture': "",
      };


      print("---------0000-------information");

      // Navigator.push(context,
      //     MaterialPageRoute(builder: (context) => Incoming(callInfo,)));
      // showDialog(context: context, builder: (context)=>
      //     Incoming(callInfo,));
      // } else {
      //   print("++++++++++++++++++error-____________________");
      // }
    });
  }

  static sendNotification(String token, String client_request_id, type,
      title, body) async {
    Map<String, String>headerMap = {
      'Content-type': 'application/json',
      'Authorization': 'key=$serverKey',
      "apns-push-type": "background",
      "apns-priority": "5", // Must be `5` when `contentAvailable` is set to true.
      "apns-topic": "io.flutter.plugins.firebase.messaging",
    };
    Map notification = {
      'title': "$title",
      "body": "$body"
    };
    Map dataMap = {
      'click_action': 'Blang App Notification',
      'id': "1",
      'status': 'done',
      'roomId': client_request_id,
      'type': "text"
    };
    Map sendNotificationMap = {
      "notification": notification,
      'data': dataMap,
      "android": {
        "priority": "high"
      },
      "apns":{
        "payload":{
          "aps":{
            "contentAvailable": true,
            "alert" : {
              "body" : "$body",
              "title" : "$title",
            },
          },
        },
      },
      "to": token,
    };
    var res = await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: headerMap,
        body: jsonEncode(sendNotificationMap)
    );

    print(res);
  }

}

