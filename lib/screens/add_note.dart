import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:slambook/screens/home.dart';
import 'package:slambook/utils/user_preferences.dart';

class AddNoteScreen extends StatefulWidget {
  final String? selectedDay;
  const AddNoteScreen({Key? key, this.selectedDay}) : super(key: key);

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  String _selectedDay = "";
  DateTime today = DateTime.now();
  DateFormat dateFormat = DateFormat("dd MMM yyyy");
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  Map<String, dynamic> _mySelectedEvents = {};

  @override
  void initState() {
    super.initState();
    if (UserSimplePreferences.getNote() != "") {
      _mySelectedEvents =
          json.decode(UserSimplePreferences.getNote()) as Map<String, dynamic>;
    }
  }

  @override
  Widget build(BuildContext context) {
    _selectedDay = ModalRoute.of(context)!.settings.arguments == null
        ? DateFormat("dd MMM yyyy").format(today).toString()
        : ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: _buildAppBar(context),
      body: _content(context),
    );
  }

  _buildAppBar(context) {
    return AppBar(
      centerTitle: true,
      // backgroundColor: Colors.transparent,
      // elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => const HomeScreen()),
          // );
          Navigator.pop(context);
        },
      ),
      automaticallyImplyLeading: true,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.add_a_photo),
          onPressed: () {
            // Navigator.pop(context);
          },
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: ElevatedButton(
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(Colors.green),
            ),
            onPressed: () {
              _saveNote(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
              // Navigator.pop(context);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('Save'),
              ],
            ),
          ),
        ),
      ],
    );
  } // end function

  _content(context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_selectedDay),
          TextField(
            controller: _titleController,
            textCapitalization: TextCapitalization.words,
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Title',
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
          Expanded(
            child: TextField(
              controller: _descriptionController,
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: "Write more here...",
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          )
        ],
      ),
    );
  }

  _saveNote(context) {
    if (_titleController.text.isEmpty && _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          elevation: 0,
          content: Text('Required title and description'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    } else {
      if (_mySelectedEvents[_selectedDay] != null) {
        _mySelectedEvents[_selectedDay]?.add({
          "eventTitle": _titleController.text,
          "eventDescription": _descriptionController.text,
        });
      } else {
        _mySelectedEvents[_selectedDay] = [
          {
            "eventTitle": _titleController.text,
            "eventDescription": _descriptionController.text,
          }
        ];
      }
      UserSimplePreferences.setNote(_mySelectedEvents);
    }
  }
} // end class
