import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:slambook/screens/home.dart';
import 'package:slambook/utils/user_preferences.dart';

class AddNoteScreen extends StatefulWidget {
  final int? index;
  final String? selectedDay;
  final String? selectedTitle;
  final String? selectedDescription;
  const AddNoteScreen(
      {Key? key,
      this.index,
      this.selectedDay,
      this.selectedTitle,
      this.selectedDescription})
      : super(key: key);

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  int _index = -1;
  bool _isNewNote = false;
  bool _enableForm = false;
  String _selectedDay = "";
  String _selectedTitle = "";
  String _selectedDescription = "";
  DateTime today = DateTime.now();
  DateFormat dateFormat = DateFormat("dd MMM yyyy");
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  Map<String, dynamic> _mySelectedEvents = {};

  // Variables for image imports
  File? selectedImage;
  String base64Image = "";

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
    // Fetching arguments from home page
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final arguments = ModalRoute.of(context)!.settings.arguments as Map;

      _selectedDay = arguments['selectedDay'] == null
          ? DateFormat("dd MMM yyyy").format(today).toString()
          : arguments['selectedDay'] as String;

      _index = arguments['index'] ?? -1;
      _isNewNote = _index == -1;
      _enableForm = _enableForm == true ? _enableForm : _isNewNote;
      _selectedTitle = arguments['selectedTitle'] ?? "";
      _selectedDescription = arguments['selectedDescription'] ?? "";
      _titleController.text = _selectedTitle;
      _descriptionController.text = _selectedDescription;
    } else {
      _selectedDay = DateFormat("dd MMM yyyy").format(today).toString();
    }

    return Scaffold(
      appBar: _buildAppBar(context),
      body: _content(context),
    );
  }

  // Function to build the App Bar of the Add Note page
  _buildAppBar(context) {
    return AppBar(
      centerTitle: true,
      // Make app bar transparent for themes
      // backgroundColor: Colors.transparent,
      // elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      automaticallyImplyLeading: true,
      actions: <Widget>[
        _isNewNote || _enableForm
            ? (IconButton(
                icon: const Icon(Icons.add_a_photo),
                onPressed: () {
                  chooseImage("Camera");
                },
              ))
            : (IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  setState(() {
                    _enableForm = true;
                  });

                  // Navigator.pop(context);
                },
              )),
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
        _popupMenu()
      ],
    );
  } // end function

  // Function to render content of the Add Note page
  _content(context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_selectedDay),
          TextField(
            enabled: _enableForm,
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
          // Function to display picked images from gallery / camera
          // _displayImages(),
          Expanded(
            child: TextField(
              enabled: _enableForm,
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

  // Function to save the note in map and map in shared_preferences
  _saveNote(context) {
    // Handle saving empty notes
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
        //check if note is new then update else add new
        if (!_isNewNote) {
          _mySelectedEvents[_selectedDay][_index] = {
            "eventTitle": _titleController.text,
            "eventDescription": _descriptionController.text,
          };
        } else {
          _mySelectedEvents[_selectedDay]?.add({
            "eventTitle": _titleController.text,
            "eventDescription": _descriptionController.text,
          });
        }
      } else {
        // Add New note for new date if not already present
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

  // Function to manage PopupMenu
  _popupMenu() {
    return PopupMenuButton<int>(
      itemBuilder: (context) => [
        if (!_isNewNote) ...[
          const PopupMenuItem<int>(
            value: 0,
            child: Text("Delete"),
          ),
        ],
        const PopupMenuItem<int>(
          value: 1,
          child: Text("Share"),
        ),
      ],
      onSelected: (item) => _selectedItem(context, item),
    );
  }

  // Function to handle actions performed by popup menu items.
  void _selectedItem(BuildContext context, item) {
    switch (item) {
      case 0:
        _mySelectedEvents[_selectedDay]
            .remove(_mySelectedEvents[_selectedDay][_index]);

        UserSimplePreferences.setNote(_mySelectedEvents);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        break;
      case 1:
        print("Share Clicked");
        break;
    }
  }

  // Function to upload image
  Future<void> chooseImage(type) async {
    // ignore: prefer_typing_uninitialized_variables
    final ImagePicker picker = ImagePicker();
    XFile? image;
    if (type == "camera") {
      image =
          await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    } else {
      image =
          await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    }
    if (image != null) {
      setState(() {
        selectedImage = File(image!.path);
        base64Image = base64Encode(selectedImage!.readAsBytesSync());
      });
    }
  }

  _displayImages() {
    Padding(
      padding: const EdgeInsets.all(10.0),
      child: CircleAvatar(
        radius: 60,
        backgroundColor: Colors.red,
        child: Padding(
          padding: const EdgeInsets.all(8), // Border radius
          child: ClipOval(
              child: selectedImage != null
                  ? Image.file(
                      selectedImage!,
                      fit: BoxFit.cover,
                      height: 100,
                      width: 100,
                    )
                  : Image.network(
                      'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg',
                      fit: BoxFit.cover,
                      height: 100,
                      width: 100,
                    )),
        ),
      ),
    );
  }
} // end class
