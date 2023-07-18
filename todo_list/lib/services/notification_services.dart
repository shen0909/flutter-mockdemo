import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:todo_list/models/task.dart';
import '../ui/notification_page.dart';

class NotifyHelper{
  /*从flutter本地通知插件FlutterLocalNotificationsPlugin初始化一个实例*/
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin(); //

  /*初始化函数*/
  initializeNotification() async {
    _configureLocalTimezone();
    /*初始化时区*/
    tz.initializeTimeZones();
    //初始化--IOS平台
    // this is for latest iOS settings
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification
    );

    //初始化--Android平台
    final AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings("appicon");

    /*需要被初始化的第一个参数内部有两个参数
     *初始化 ios Android 两个平台 */
    final InitializationSettings initializationSettings =
    InitializationSettings(
      iOS: initializationSettingsIOS,
      android:initializationSettingsAndroid,
    );

    /*插件的主入口，需要初始化第一个参数*/
    await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        /*回调函数*/
        onSelectNotification: selectNotification
        );
  }

  Future onDidReceiveLocalNotification(int ? id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    Get.dialog(Text("welcome to flutter notification"));
  }

  /*在通知到达后，通过点击通知选项卡转到另一个页面*/
  Future selectNotification(String? payload) async {
    if (payload != null) {
      print('notification payload: $payload');
    } else {
      print("Notification Done");
    }
    Get.to(()=>NotificationPage( lable: payload!,));
  }

  /*请求iOS权限*/
  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /*即时通知显示通知功能*/
  displayNotification({required String title, required String body}) async {
    print("doing test");
    //android细节
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max,
        priority: Priority.high);
    //ios细节
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'You change your theme',
      'You changed your theme back !',
      platformChannelSpecifics,
      /*payload---->显示带有可选有效负载的通知，点击通知时，该有效负载将传递回应用。
       *持有通知传递的任何数据 */
      payload: 'It could be anything you pass',
    );
  }

  /*预定通知
   *在一段时间后显示 */
  scheduledNotification(int hour,int minutes,Task task) async {
    /*在特定的日期、时间显示*/
    await flutterLocalNotificationsPlugin.zonedSchedule(
        /*0,
        'scheduled title',
        'theme changes 5 seconds ago',*/
        task.id!.toInt(),
        task.title,
        task.note,
        /*在此设置时间，在多少秒后显示
         *由于seconds: 5里面只能是不可变的整数，所以根据传入的信息重新构造时间 */
        _converTime(hour,minutes),
        // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
              'your channel id',
              'your channel name',
            )),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: "${task.title}|"+"${task.note}"
    );
  }

  //转换时间
  /*tz.local---->来自于本地设备的当地时间
   *需要配置 */
  tz.TZDateTime _converTime(int hour,int minutes){
    final tz.TZDateTime now=tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduletime=tz.TZDateTime(tz.local, now.year,now.month,now.day,hour,minutes);
    if(scheduletime.isBefore(now)){
      scheduletime =scheduletime.add(const Duration(days: 1));
    }
    return scheduletime;
  }

  Future<void> _configureLocalTimezone() async {
    tz.initializeTimeZones();
    /*获取本地时区*/
    final String timeZone=await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }
  /*安排一个通知，我们需要调用FlutterLocalNotificationsPlugin的zoneSchedule方法。这个方法需要一个TZDateTime 类的实例，
   *这个类是由timezone 包提供的
   *zoneSchedule方法包含几个参数，其中
   *scheduleDate 参数指定何时显示通知。androidAllowWhileIdle ，当设置为true ，确保计划的通知被显示，无论设备是否处于低功率模式。*/
}