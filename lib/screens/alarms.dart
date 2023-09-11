import 'package:a_normal_alarm/screens/edit_alarm.dart';
import 'package:provider/provider.dart';
import '../utils/alarms_manager.dart';
import 'clock_show.dart';
import 'package:flutter/material.dart';
import '../utils/alarms_list.dart';
//import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

class Alarms extends StatefulWidget {
  const Alarms({super.key});

  @override
  State<StatefulWidget> createState() => _AlarmsState();
}

class _AlarmsState extends State<Alarms> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer<AlarmsManager>(builder: (context, alarmsManager, _) {
          if (alarmsManager.alarmsList.isEmpty) {
            return const Opacity(
                opacity: .5,
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Icon(Icons.alarm_off, size: 90),
                      Text("Không có báo thức nào")
                    ])));
          }
          return CustomScrollView(slivers: <Widget>[
            const SliverAppBar.large(title: Text("Báo thức")),
            SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
              return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AlarmCard(
                      alarm: alarmsManager.alarmsList[index], index: index));
            }, childCount: alarmsManager.alarmsList.length))
          ]);
        }),
        floatingActionButton: FloatingActionButton.extended(
            heroTag: null,
            onPressed: () async =>
                Provider.of<AlarmsManager>(context, listen: false)
                    .insert((await showClockPicker(context: context))!),
            label: const Row(children: [
              Icon(Icons.alarm_add),
              SizedBox(width: 12),
              Text("Thêm báo thức")
            ])));
  }
}

class AlarmCard extends StatefulWidget {
  final AlarmInfo alarm;
  final int index;
  const AlarmCard({super.key, required this.alarm, required this.index});

  @override
  State<StatefulWidget> createState() => _AlarmCardState();
}

class _AlarmCardState extends State<AlarmCard> {
  List<String> weekdays = ["2", "3", "4", "5", "6", "7", "S"];

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: UniqueKey(),
        onDismissed: (_) => Provider.of<AlarmsManager>(context, listen: false)
            .remove(widget.index),
        child: Card(
            shadowColor: Colors.transparent,
            child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditAlarm(
                            index: widget.index, alarm: widget.alarm))),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SizedBox(
                      height: 90,
                      child: Stack(children: [
                        Align(
                            alignment: Alignment.topRight,
                            child: Container(
                                decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(69))),
                                child: Icon(Icons.chevron_right_rounded,
                                    size: 18,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary))),
                        Row(mainAxisSize: MainAxisSize.min, children: [
                          Text(
                              "${widget.alarm.hour < 10 ? 0 : ""}${widget.alarm.hour}",
                              style:
                                  const TextStyle(height: 1.2, fontSize: 52)),
                          const Padding(
                              padding: EdgeInsets.only(bottom: 5),
                              child: Text(":",
                                  style: TextStyle(height: 1.2, fontSize: 52))),
                          Text(
                              "${widget.alarm.minute < 10 ? 0 : ""}${widget.alarm.minute}",
                              style: const TextStyle(height: 1.2, fontSize: 52))
                        ]),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: Row(children: [
                              SizedBox(
                                  width: 100,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        for (int day = 0;
                                            day < widget.alarm.schedule.length;
                                            day++)
                                          Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                    width: 3,
                                                    height: 3,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(69),
                                                        color: widget.alarm
                                                                .schedule[day]
                                                            ? Theme.of(context)
                                                                .colorScheme
                                                                .primary
                                                            : Colors
                                                                .transparent)),
                                                Text(weekdays[day],
                                                    style: TextStyle(
                                                        color: widget.alarm
                                                                .schedule[day]
                                                            ? Theme.of(context)
                                                                .colorScheme
                                                                .primary
                                                            : Theme.of(context)
                                                                .colorScheme
                                                                .outline))
                                              ])
                                      ])),
                              const Spacer(),
                              GestureDetector(
                                  onTap: () => Provider.of<AlarmsManager>(
                                          context,
                                          listen: false)
                                      .toggleAlarmMainPage(
                                          widget.index, !widget.alarm.active),
                                  behavior: HitTestBehavior.translucent,
                                  child: SizedBox(
                                      height: 30,
                                      child: Switch(
                                          value: widget.alarm.active,
                                          onChanged: (_) =>
                                              Provider.of<AlarmsManager>(
                                                      context,
                                                      listen: false)
                                                  .toggleAlarmMainPage(
                                                      widget.index,
                                                      !widget.alarm.active))))
                            ]))
                      ])),
                ))));
  }
}
