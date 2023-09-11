import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// This is the alarm info.
/// schedule list has to be careful.
/// an schedule list must contains 7 bools for each day on a week from
/// Monday to Sunday
/// 1      -> 7 (Index)
///
/// Example:
/// [false, false, false, false, false, false, true]
/// This alarm will only triggers on Sunday.
///
/// snoozePattern:
/// {
///   "times": 3 (How many times will the alarm goes off again)
///   "cooldown": 5 (How many minutes will the alarm would go back to snooze)
/// }
class AlarmInfo {
  bool active, vibrate, musicPlay, snooze;
  int hour, minute;
  List<bool> schedule;
  String? musicPath;
  Map<String, int> snoozePattern;

  AlarmInfo(
      {required this.active,
      required this.vibrate,
      required this.snoozePattern,
      required this.snooze,
      required this.hour,
      required this.minute,
      required this.schedule,
      this.musicPath,
      required this.musicPlay});
}

Future<List<AlarmInfo>> getAlarmsListPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String? alarmListRaw = prefs.getString("alarms_list");

  if (alarmListRaw == null) {
    return [];
  }

  List<dynamic> alarmList = jsonDecode(alarmListRaw);

  return [
    for (dynamic alarm in alarmList)
      AlarmInfo(
          active: alarm["active"] as bool,
          vibrate: alarm["vibrate"] as bool,
          snoozePattern: (alarm["snoozePattern"] as Map)
              .map((key, value) => MapEntry(key, value as int)),
          snooze: alarm["snooze"] as bool,
          hour: alarm["hour"],
          minute: alarm["minute"],
          schedule:
              (alarm["schedule"] as List).map((item) => item as bool).toList(),
          musicPath: alarm["musicPath"],
          musicPlay: alarm["musicPlay"])
  ];
}

Future<bool> pushFrontAlarmPrefs(AlarmInfo newAlarm) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String? alarmListRaw = prefs.getString("alarms_list");

  List<dynamic> alarmList = [];

  if (alarmListRaw != null) {
    alarmList = jsonDecode(alarmListRaw);
  }

  alarmList.insert(0, {
    "active": newAlarm.active,
    "vibrate": newAlarm.vibrate,
    "snoozePattern": newAlarm.snoozePattern,
    "snooze": newAlarm.snooze,
    "hour": newAlarm.hour,
    "minute": newAlarm.minute,
    "schedule": newAlarm.schedule,
    "musicPath": newAlarm.musicPath,
    "musicPlay": newAlarm.musicPlay
  });

  await prefs.setString("alarms_list", jsonEncode(alarmList));

  return true;
}

Future<bool> deleteAlarmIndexPrefs(int position) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  List<dynamic> alarmList = jsonDecode(prefs.getString("alarms_list")!);
  alarmList.removeAt(position);

  prefs.setString("alarms_list", jsonEncode(alarmList));

  return true;
}

Future<bool> updateAlarmIndexPrefs(
    int position, AlarmInfo replacedAlarm) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  List<dynamic> alarmList = jsonDecode(prefs.getString("alarms_list")!);
  alarmList[position] = {
    "active": replacedAlarm.active,
    "vibrate": replacedAlarm.vibrate,
    "snoozePattern": replacedAlarm.snoozePattern,
    "snooze": replacedAlarm.snooze,
    "hour": replacedAlarm.hour,
    "minute": replacedAlarm.minute,
    "schedule": replacedAlarm.schedule,
    "musicPath": replacedAlarm.musicPath,
    "musicPlay": replacedAlarm.musicPlay
  };

  prefs.setString("alarms_list", jsonEncode(alarmList));

  return true;
}
