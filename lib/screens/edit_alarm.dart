import 'package:a_normal_alarm/utils/alarms_list.dart';
import 'package:a_normal_alarm/utils/alarms_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'clock_show.dart';

class EditAlarm extends StatefulWidget {
  final int index;
  final AlarmInfo alarm;
  const EditAlarm({super.key, required this.alarm, required this.index});

  @override
  State<StatefulWidget> createState() => _EditAlarmState();
}

class _EditAlarmState extends State<EditAlarm> {
  late AlarmInfo editingAlarm;
  List<String> weekdays = ["2", "3", "4", "5", "6", "7", "S"];

  @override
  void initState() {
    super.initState();
    editingAlarm = AlarmInfo(
        active: widget.alarm.active,
        vibrate: widget.alarm.vibrate,
        snoozePattern: widget.alarm.snoozePattern,
        snooze: widget.alarm.snooze,
        hour: widget.alarm.hour,
        minute: widget.alarm.minute,
        schedule: widget.alarm.schedule,
        musicPlay: widget.alarm.musicPlay);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      SingleChildScrollView(
          child: Column(children: [
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 200),
            child: InkWell(
                onTap: () async {
                  editingAlarm = (await showClockPicker(
                      context: context, time: editingAlarm))!;
                  setState(() {});
                },
                borderRadius: BorderRadius.circular(24),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text("${editingAlarm.hour < 10 ? 0 : ""}${editingAlarm.hour}",
                      style: const TextStyle(height: 1.2, fontSize: 80)),
                  const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(":",
                          style: TextStyle(height: 1.2, fontSize: 80))),
                  Text(
                      "${editingAlarm.minute < 10 ? 0 : ""}${editingAlarm.minute}",
                      style: const TextStyle(height: 1.2, fontSize: 80))
                ]))),
        Card(
            shadowColor: Colors.transparent,
            child: Column(children: [
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        for (int indexDay = 0;
                            indexDay < editingAlarm.schedule.length;
                            indexDay++)
                          InkWell(
                              borderRadius: BorderRadius.circular(69),
                              onTap: () => setState(() =>
                                  editingAlarm.schedule[indexDay] =
                                      !editingAlarm.schedule[indexDay]),
                              child: Container(
                                height: 32,
                                width: 32,
                                decoration: BoxDecoration(
                                    color: editingAlarm.schedule[indexDay]
                                        ? Theme.of(context).colorScheme.primary
                                        : null,
                                    border: Border.all(
                                        color: editingAlarm.schedule[indexDay]
                                            ? Colors.transparent
                                            : Theme.of(context)
                                                .colorScheme
                                                .outline),
                                    borderRadius: BorderRadius.circular(69)),
                                child: Center(
                                    child: Text(weekdays[indexDay],
                                        style: TextStyle(
                                            color:
                                                editingAlarm.schedule[indexDay]
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .onPrimary
                                                    : null))),
                              ))
                      ])),
              ListTile(
                  title: const Text("Báo thức"),
                  leading: const Icon(Icons.alarm),
                  trailing: Switch(
                      value: editingAlarm.active,
                      onChanged: (bool idk) =>
                          setState(() => editingAlarm.active = idk))),
              ListTile(
                  title: const Text("Rung"),
                  leading: const Icon(Icons.vibration),
                  trailing: Switch(
                      value: editingAlarm.vibrate,
                      onChanged: (bool idk) =>
                          setState(() => editingAlarm.vibrate = idk))),
              ListTile(
                  title: const Text("Âm thanh chuông báo"),
                  subtitle: Text("Mặc định",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary)),
                  leading: const Icon(Icons.music_note_outlined),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    const VerticalDivider(),
                    Switch(
                        value: editingAlarm.musicPlay,
                        onChanged: (bool idk) =>
                            setState(() => editingAlarm.musicPlay = idk))
                  ])),
              ListTile(
                  title: const Text("Tạm dừng"),
                  subtitle: Text(
                      "${editingAlarm.snoozePattern["cooldown"]} phút, ${editingAlarm.snoozePattern["times"]} lần",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary)),
                  leading: const Icon(Icons.snooze),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    const VerticalDivider(),
                    Switch(
                        value: editingAlarm.snooze,
                        onChanged: (bool idk) =>
                            setState(() => editingAlarm.snooze = idk))
                  ])),
            ])),
        const SizedBox(height: 60),
      ])),
      Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12))),
              child: Row(children: [
                Expanded(
                    child: InkWell(
                        borderRadius: BorderRadius.circular(69),
                        onTap: () => Navigator.of(context).pop(),
                        child: SizedBox(
                            height: 52,
                            child: Center(
                                child: Text("Thoát",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                    textAlign: TextAlign.center))))),
                Expanded(
                    child: InkWell(
                        borderRadius: BorderRadius.circular(69),
                        onTap: () {
                          Provider.of<AlarmsManager>(context, listen: false)
                              .updateEditedAlarm(widget.index, editingAlarm);
                          Navigator.of(context).pop();
                        },
                        child: SizedBox(
                            height: 52,
                            child: Center(
                                child: Text("Lưu",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                    textAlign: TextAlign.center)))))
              ])))
    ]));
  }
}
