import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Toast {

  static errToast(String str, context) {
    CherryToast(
        icon:  FontAwesomeIcons.circleXmark,
        themeColor:  Colors.red,
        title:  const Text(""),
        displayTitle:  false,
        description:  Text(str),
        toastPosition:  Position.bottom,
        animationType: AnimationType.fromBottom,
        animationDuration:  const Duration(milliseconds:  1000),
        autoDismiss:  true
    ).show(context);
  }

  static successToast(String str, context) {
    CherryToast(
        icon:  FontAwesomeIcons.circleCheck,
        themeColor:  Colors.green,
        title:  const Text(""),
        displayTitle:  false,
        description:  Text(str),
        toastPosition:  Position.bottom,
        animationType: AnimationType.fromBottom,
        animationDuration:  const Duration(milliseconds:  1000),
        autoDismiss:  true
    ).show(context);
  }

  static warnToast(String str, context) {
    CherryToast(
        icon:  FontAwesomeIcons.circleExclamation,
        themeColor:  Colors.orange,
        title:  const Text(""),
        displayTitle:  false,
        description:  Text(str),
        toastPosition:  Position.bottom,
        animationType: AnimationType.fromBottom,
        animationDuration:  const Duration(milliseconds:  1000),
        autoDismiss:  true
    ).show(context);
  }
}
