import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  final String value;
  final VoidCallback onPressed;

  const Settings({super.key, required this.value, required this.onPressed});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ElevatedButton(onPressed: widget.onPressed, child: Text(widget.value));
  }

}