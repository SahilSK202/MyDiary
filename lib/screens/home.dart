import 'package:flutter/material.dart';
import 'package:slambook/screens/theme.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime today = DateTime.now();
  DateFormat dateFormat = DateFormat("dd MMMM yyyy");
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = focusedDay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(context), body: _content(context));
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

  Widget _content(context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Text("Selected Day = ${dateFormat.format(today).toString()}"),
          TableCalendar(
            locale: "en_US",
            rowHeight: 42,
            headerStyle: const HeaderStyle(
                formatButtonVisible: false, titleCentered: true),
            availableGestures: AvailableGestures.all,
            selectedDayPredicate: (day) => isSameDay(day, today),
            focusedDay: today,
            firstDay: DateTime(today.year, today.month - 3, today.day),
            lastDay: DateTime(today.year, today.month + 3, today.day),
            onDaySelected: _onDaySelected,
          ),
        ],
      ),
    );
  }
}
