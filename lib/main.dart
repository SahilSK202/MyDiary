import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slambook/constants/themes.dart';
import 'package:slambook/screens/add_note.dart';
import 'package:slambook/utils/theme_notifier.dart';
import 'package:slambook/utils/user_preferences.dart';
import 'screens/home.dart';

// Function to initialize shared_preferences before running the app.
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserSimplePreferences.init();
  var themeColor = UserSimplePreferences.getTheme();
  if (themeColor == Colors.black.toString()) {
    activeTheme = darkBlackTheme;
  } else if (themeColor == Colors.blue.toString()) {
    activeTheme = lightBlueTheme;
  }
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => ThemeNotifier(activeTheme),
      )
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      theme: themeNotifier.getTheme,
      routes: {'/addNote': (context) => const AddNoteScreen()},
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
