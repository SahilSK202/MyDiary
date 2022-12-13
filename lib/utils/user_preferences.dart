import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreferences {
  static SharedPreferences? _preferences;

  static const _key = "notes";
  static const _theme = "theme";

  // Function to get instance of UserSimplePreferences
  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Function to set Notes Map as string in shared_preferences
  static Future setNote(Map<String, dynamic> note) async =>
      await _preferences?.setString(_key, json.encode(note));

  // Function to get Notes Map as string in shared_preferences
  static String getNote() {
    if (_preferences?.getString(_key) == null) {
      return "";
    } else {
      return _preferences?.getString(_key) as String;
    }
  }

  // Function to set Theme as string in shared_preferences
  static Future setTheme(String color) async =>
      await _preferences?.setString(_theme, color);

  // Function to get Theme as string in shared_preferences
  static String getTheme() {
    if (_preferences?.getString(_theme) == null) {
      return Colors.blue.toString();
    } else {
      return _preferences?.getString(_theme) as String;
    }
  }
}
