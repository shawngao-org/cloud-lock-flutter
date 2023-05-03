import 'package:flutter/material.dart';

class Management extends StatefulWidget {
  final String value;
  final VoidCallback onPressed;

  const Management({super.key, required this.value, required this.onPressed});

  @override
  State<Management> createState() => _ManagementState();
}

class _ManagementState extends State<Management> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ElevatedButton(onPressed: widget.onPressed, child: Text(widget.value));
  }
}
