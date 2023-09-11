import 'utils/alarms_manager.dart';
import 'package:animations/animations.dart';
import 'package:provider/provider.dart';
import 'screens/alarms.dart';
import 'package:flutter/material.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(ChangeNotifierProvider(
      create: (_) => AlarmsManager(),
      builder: (context, _) => const ANormalAlarm()));
}

class ANormalAlarm extends StatelessWidget {
  const ANormalAlarm({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            pageTransitionsTheme: const PageTransitionsTheme(builders: {
              TargetPlatform.windows: SharedAxisPageTransitionsBuilder(
                  transitionType: SharedAxisTransitionType.horizontal)
            }),
            fontFamily: "Google Sans",
            brightness: Brightness.light,
            colorSchemeSeed: Colors.brown,
            useMaterial3: true),
        darkTheme: ThemeData(
            pageTransitionsTheme: const PageTransitionsTheme(builders: {
              TargetPlatform.windows: SharedAxisPageTransitionsBuilder(
                  transitionType: SharedAxisTransitionType.horizontal)
            }),
            fontFamily: "Google Sans",
            brightness: Brightness.dark,
            colorSchemeSeed: Colors.brown,
            useMaterial3: true),
        themeMode: ThemeMode.system,
        home: const Alarms());
  }
}
