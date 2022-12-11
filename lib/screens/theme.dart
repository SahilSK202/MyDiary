import 'package:flutter/material.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({super.key});

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
    );
  }
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
}
