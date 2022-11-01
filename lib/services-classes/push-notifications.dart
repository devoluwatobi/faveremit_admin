import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationsManager {
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  bool _initialized = false;
  late String? token;

  Future<void> init() async {
    if (!_initialized) {
      // For iOS request permission first.

      _firebaseMessaging.requestPermission();

      // android local notification initialization
      var androidInitialize =
          const AndroidInitializationSettings("ic_notification");

      //ios local notification initialization
      var iosInitialize = const IOSInitializationSettings();

      //set initialization for local notification

      var localNotificationInitializationSettings = InitializationSettings(
          android: androidInitialize, iOS: iosInitialize);
      // var localNotification = FlutterLocalNotificationsPlugin();
      localNotification.initialize(localNotificationInitializationSettings);

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        // if (notification != null &&
        //     message.data["senderID"] != userDetails.id) {
        print(notification!.body!);
        showNotifications(title: notification.title!, body: notification.body!);
        // }
      });

      FirebaseMessaging.onBackgroundMessage((message) async {
        if (message.notification != null) {
          RemoteNotification? notification = message.notification;
          showNotifications(
              title: notification!.title!, body: notification.body!);
        }

        return;
      });
    }

    // For testing purposes print the Firebase Messaging token
    token = await _firebaseMessaging.getToken();
    print("FirebaseMessaging token: $token");
    var notificationToken = token;

    //subscribe to all users
    await FirebaseMessaging.instance.subscribeToTopic("all_admins");
    _initialized = true;
  }

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static FlutterLocalNotificationsPlugin localNotification =
      FlutterLocalNotificationsPlugin();

  static Future<void> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
      print(data);
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
      print(notification);
      showNotifications(
          title: message["notification"]["title"],
          body: message["notification"]["body"]);
    }

    // Or do other work.
  }

  static Future showNotifications(
      {required String title, required String body}) async {
    var androidDetails = const AndroidNotificationDetails(
        "channelId", "channelName",
        channelDescription: "channelDescription",
        importance: Importance.max,
        playSound: true,
        priority: Priority.max);
    var iosDetails = const IOSNotificationDetails();
    var generalNotificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    await localNotification.show(
      DateTime.now().microsecond,
      title,
      body,
      generalNotificationDetails,
      payload: 'Default_Sound',
    );
  }
}

Future<void> backgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    print(data);
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
    print(notification);
    showBackgroundNotifications(
        title: message["notification"]["title"],
        body: message["notification"]["body"]);
  }

  // Or do other work.
}

Future showBackgroundNotifications(
    {required String title, required String body}) async {
  var androidDetails = const AndroidNotificationDetails(
      "channelId", "channelName",
      channelDescription: "channelDescription",
      importance: Importance.max,
      playSound: true,
      priority: Priority.max);
  var iosDetails = const IOSNotificationDetails();
  var generalNotificationDetails =
      NotificationDetails(android: androidDetails, iOS: iosDetails);
  print(title);
}

PushNotificationsManager pushNotificationsManager = PushNotificationsManager();
