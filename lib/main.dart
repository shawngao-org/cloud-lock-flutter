import 'dart:io';
import 'package:cloud_lock/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      home: const LoginScreen(),
      builder: EasyLoading.init(),
    );
  }
}