import 'package:flutter/cupertino.dart';

class LockInfo {
  String id;
  String name;
  String state;
  IconData? icon;

  LockInfo({
    required this.id, required this.name, required this.state, required this.icon
  });
}
