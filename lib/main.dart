// import 'package:fancy_bar/fancy_bar.dart';
import 'dart:io';
import 'dart:math';

import 'package:cloud_lock/home.dart';
import 'package:cloud_lock/management.dart';
import 'package:cloud_lock/settings.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'bubble_bottom_bar.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
const String channelId = "0";
const String channelName = "org.shawngao.channel/notification";
const String channelDescription = "org.shawngao.channel/notification";
const String appName = "门禁管理";
void main() {
  runApp(const MyApp());
  if (Platform.isAndroid) {
    //设置Android头部的导航栏透明
    SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

// class NavigationRouter extends StatelessWidget {
//   const NavigationRouter({
//     required Key key,
//     required this.value
//   }) : super(key: key);
//   final String value;
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Scaffold(
//       body: ,
//     )
//   }
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: appName,
      home: MyHomePage(title: appName),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const _platformToast =
      MethodChannel('org.shawngao.channel/toast');
  static const bottomBar1 = <Widget> [Icon(Icons.dashboard, size: 30),
    Icon(Icons.lock, size: 30), Icon(Icons.settings, size: 30),
  ];
  final List<Widget> _children = [
    Home(value: 'Hello Home.', onPressed: () => {}),
    Management(value: "Hello, Management.", onPressed: () => {}),
    Settings(value: "Hello, Settings.", onPressed: () => {})
  ];
  static const bottomBar = <BubbleBottomBarItem>[
    BubbleBottomBarItem(backgroundColor: Colors.blue,
        icon: Icon(Icons.dashboard_outlined, color: Colors.black,),
        activeIcon: Icon(Icons.dashboard, color: Colors.blue,),
        title: Text("首页")),
    BubbleBottomBarItem(backgroundColor: Colors.orange,
        icon: Icon(Icons.lock_open, color: Colors.black,),
        activeIcon: Icon(Icons.lock, color: Colors.orange,),
        title: Text("管理")),
    BubbleBottomBarItem(backgroundColor: Colors.black,
        icon: Icon(Icons.settings_outlined, color: Colors.black,),
        activeIcon: Icon(Icons.settings, color: Colors.black,),
        title: Text("设置")),
  ];

  void _incrementCounter() async {
    navStyle = !navStyle;
    setState(() {currentIndex = currentIndex;});
    _platformToast.invokeMethod('showShortToast', {'message': 'You was clicked me.'});
    await _showNotification();
  }

  late int currentIndex;
  bool navStyle = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentIndex = 0;
    var android = const AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings = InitializationSettings(android: android);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,);
  }

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(channelId, channelName, channelDescription: channelDescription,
        importance: Importance.max, priority: Priority.max, ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show((Random()).nextInt(1024), "Hello.",
        "This is a test notification", platformChannelSpecifics, payload: 'item x');
  }

  void changePage(int? index) => setState(() {currentIndex = index!;});
  static const Color topColor = Color(0xffb7cad5);
  static const Color bottomColor = Color(0xffffffff);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: topColor,
        title: const Text(appName),
      ),
      backgroundColor: bottomColor,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              topColor,
              bottomColor
            ],
            stops: [
              0.0, 1.0
            ],
          ),
        ),
        child: Center(
          child: Hero(
            tag: _children[currentIndex].hashCode,
            child: _children[currentIndex],
          ),
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        backgroundColor: Colors.red,
        child: const Icon(FontAwesomeIcons.plus),
      ),
      bottomNavigationBar: navStyle ? BubbleBottomBar(
        opacity: .2,
        items: bottomBar,
        currentIndex: currentIndex,
        onTap: changePage,
        fabLocation: BubbleBottomBarFabLocation.end,
        elevation: 8,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        hasNotch: true,
      ) : CurvedNavigationBar(
        backgroundColor: Colors.blueAccent,
        items: bottomBar1,
        index: currentIndex,
        onTap: changePage,
        height: 60,
      ),
      floatingActionButtonLocation: navStyle ? FloatingActionButtonLocation.endDocked
      : FloatingActionButtonLocation.endFloat,
    );
  }
}
