import 'package:flutter/material.dart';
import 'package:slambook/screens/add_note.dart';
import 'package:slambook/utils/user_preferences.dart';
import 'screens/home.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await UserSimplePreferences.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {'/addNote': (context) => const AddNoteScreen()},
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
