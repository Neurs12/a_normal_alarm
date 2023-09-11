import 'package:a_normal_alarm/utils/alarms_list.dart';
import 'package:flutter/material.dart';

Future<AlarmInfo?> showClockPicker(
    {required BuildContext context, AlarmInfo? time}) async {
  TimeOfDay selectedTime = (await showTimePicker(
      initialTime: time == null
          ? TimeOfDay.now()
          : TimeOfDay(hour: time.hour, minute: time.minute),
      context: context,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!);
      }))!;
  return time == null
      ? AlarmInfo(
          active: true,
          snoozePattern: {"times": 3, "cooldown": 5},
          snooze: true,
          vibrate: true,
          hour: selectedTime.hour,
          minute: selectedTime.minute,
          schedule: [false, false, false, false, false, false, false],
          musicPlay: true)
      : AlarmInfo(
          active: time.active,
          snoozePattern: time.snoozePattern,
          snooze: time.snooze,
          vibrate: time.vibrate,
          hour: selectedTime.hour,
          minute: selectedTime.minute,
          schedule: time.schedule,
          musicPlay: time.musicPlay);
}
