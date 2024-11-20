import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  // create an instance of Firebase Messaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  // function to initialize firebase messaging
  Future<void> initNotifications() async {

    // request permission to send notifications
    await _firebaseMessaging.requestPermission();

    // fetch the FCM token
    final fCMToken = await _firebaseMessaging.getToken();

    // print the token
    print("Token: $fCMToken");
  }

  // function to handle received messages

  // function to initialize foreground and background settings
}