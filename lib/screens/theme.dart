import 'package:flutter/material.dart';
import 'package:slambook/widgets/theme_tile_view.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({Key? key}) : super(key: key);

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _content(),
    );
  }

  _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: const Text(
        "Select Theme",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      automaticallyImplyLeading: true,
    );
  } // end function

  _content() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              ThemeTileView(color: Colors.black),
              ThemeTileView(color: Colors.deepPurple),
              ThemeTileView(color: Colors.indigo),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              ThemeTileView(color: Colors.pink),
              ThemeTileView(color: Colors.blue),
              ThemeTileView(color: Colors.orange),
            ],
          ),
        ),
      ],
    );
  }
} // end class
