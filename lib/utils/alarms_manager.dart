import 'package:flutter/material.dart';
import 'alarms_list.dart';

class AlarmsManager extends ChangeNotifier {
  List<AlarmInfo> alarmsList = [];

  AlarmsManager() {
    initialize();
  }

  initialize() async {
    alarmsList = await getAlarmsListPrefs();
    notifyListeners();
  }

  set(List<AlarmInfo> newList) {
    alarmsList = newList;
    notifyListeners();
  }

  insert(AlarmInfo newAlarm) {
    alarmsList.insert(0, newAlarm);
    notifyListeners();
    pushFrontAlarmPrefs(AlarmInfo(
        active: false,
        vibrate: false,
        snoozePattern: {"times": 3, "cooldown": 5},
        snooze: true,
        hour: newAlarm.hour,
        minute: newAlarm.minute,
        schedule: [false, false, false, false, false, false, false],
        musicPlay: true));
  }

  remove(int position) {
    alarmsList.removeAt(position);
    notifyListeners();
    deleteAlarmIndexPrefs(position);
  }

  toggleAlarmMainPage(int position, bool value) {
    alarmsList[position].active = value;
    // TODO: Make a schedule to launch the alarm or cancel based on the toggle event.
    if (value) {
      
    }
    notifyListeners();
    updateAlarmIndexPrefs(position, alarmsList[position]);
  }

  updateEditedAlarm(int position, AlarmInfo editedAlarm) {
    alarmsList[position] = editedAlarm;
    notifyListeners();
    updateAlarmIndexPrefs(position, editedAlarm);
  }
}
