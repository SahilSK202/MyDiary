import 'package:flutter/material.dart';
import 'package:slambook/screens/theme.dart';
// import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
    );
  }
}

_buildAppBar(context) {
  return AppBar(
    centerTitle: true,
    title: const Text(
      "My Slambook",
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    ),
    actions: <Widget>[
      ElevatedButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ThemeScreen()),
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.palette_outlined,
              size: 24.0,
            ),
            SizedBox(
              width: 5,
            ),
            Text('Theme'),
          ],
        ),
      ),
      ElevatedButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0),
        ),
        onPressed: () {
          // handle the press
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.share_outlined,
              size: 24.0,
            ),
            SizedBox(
              width: 5,
            ),
            Text('Share'),
          ],
        ),
      ),
    ],
  );
}
