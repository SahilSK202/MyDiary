import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:slambook/screens/theme.dart';
import 'package:slambook/utils/user_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime today = DateTime.now();
  DateFormat dateFormat = DateFormat("dd MMM yyyy");

  // Map to store Notes as events in the calendar
  Map<String, dynamic> _mySelectedEvents = {};

  @override
  void initState() {
    super.initState();
    // Fetching previous events from shared_preferences
    if (UserSimplePreferences.getNote() != "") {
      _mySelectedEvents =
          json.decode(UserSimplePreferences.getNote()) as Map<String, dynamic>;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _content(context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _onClickAddNew(context),
        icon: const Icon(Icons.add),
        label: const Text("Add Note"),
      ),
    );
  }

  // Function to build the App Bar of the home page
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

  // Function to render content of the home page
  Widget _content(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          // color: const Color.fromARGB(255, 201, 236, 248),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                TableCalendar(
                  calendarBuilders:
                      CalendarBuilders(markerBuilder: (context, today, events) {
                    return _listOfEvents(today).isNotEmpty
                        ? Container(
                            width: 15,
                            height: 12,
                            decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(4)),
                            child: Center(
                              child: Text(
                                _listOfEvents(today).length.toString(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 8),
                              ),
                            ),
                          )
                        : Container();
                  }),
                  locale: "en_US",
                  rowHeight: 40,
                  headerStyle: const HeaderStyle(
                      formatButtonVisible: false, titleCentered: true),
                  availableGestures: AvailableGestures.all,
                  selectedDayPredicate: (day) => isSameDay(day, today),
                  focusedDay: today,
                  firstDay: DateTime(today.year, today.month - 3, today.day),
                  lastDay: DateTime(today.year, today.month + 3, today.day),
                  onDaySelected: _onDaySelected,
                  eventLoader: _listOfEvents,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            DateFormat('EEEE, dd MMMM yyyy').format(today).toString(),
            style: const TextStyle(),
          ),
        ),
        _showNoNotesMessage(),
        ..._listOfEvents(today).map(
          (myEvents) => Padding(
            padding: const EdgeInsets.all(4.0),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                    'Title: ${myEvents['eventTitle'].length > 50 ? '${myEvents['eventTitle'].substring(0, 50)} ...' : myEvents['eventTitle']}'),
              ),
              subtitle: Text(myEvents['eventDescription'].length > 120
                  ? '${myEvents['eventDescription'].substring(0, 120)} ...'
                  : myEvents['eventDescription']),
              onTap: () => {
                _onTapNote(_listOfEvents(today).indexOf(myEvents),
                    myEvents['eventTitle'], myEvents['eventDescription'])
              },
            ),
          ),
        ),
      ],
    );
  } // end function

  // Function to set focus on the selected date on calendar.
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = focusedDay;
    });
  } // end function

  // Function to handle event when clicked on Add New button
  _onClickAddNew(context) {
    Navigator.pushNamed(context, '/addNote', arguments: {
      'index': null,
      'selectedDay': DateFormat("dd MMM yyyy").format(today).toString(),
      'selectedTitle': null,
      'selectedDescription': null,
    });
  } // end function

  // Function to return list of notes for the selected day
  List _listOfEvents(DateTime dateTime) {
    if (_mySelectedEvents[dateFormat.format(dateTime).toString()] != null) {
      return _mySelectedEvents[dateFormat.format(dateTime).toString()];
    } else {
      return [];
    }
  } // end function

  // Function to display message if no events present for selected day
  Widget _showNoNotesMessage() {
    if (_listOfEvents(today).isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(18.0),
        child: Text(
            'Writing is a good way to stop, take a step back and reflect on memories...'),
      );
    }
    return const Text('');
  } // end function

  // Function to handle the on Tap note for read and edit operations
  _onTapNote(int index, String selectedTitle, String selectedDescription) {
    Navigator.pushNamed(context, '/addNote', arguments: {
      'index': index,
      'selectedDay': DateFormat("dd MMM yyyy").format(today).toString(),
      'selectedTitle': selectedTitle,
      'selectedDescription': selectedDescription,
    });
  } // end function
} // end class
