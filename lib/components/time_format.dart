import 'package:flutter/material.dart';

class TimeFormat {
  static getFormattedTime(
      {required BuildContext context, required String time}) {
    final formatTime = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(formatTime).format(context);
  }
}
