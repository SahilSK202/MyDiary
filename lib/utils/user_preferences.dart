import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreferences {
  static SharedPreferences? _preferences;

  static const _key = "notes";

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setNote(Map<String, dynamic> note) async =>
      await _preferences?.setString(_key, json.encode(note));

  static String getNote() {
    if (_preferences?.getString(_key) == null) {
      return "";
    } else {
      return _preferences?.getString(_key) as String;
    }
  }
}
