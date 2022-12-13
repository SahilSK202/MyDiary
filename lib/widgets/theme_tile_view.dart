import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slambook/constants/themes.dart';
import 'package:slambook/utils/theme_notifier.dart';
import 'package:slambook/utils/user_preferences.dart';

class ThemeTileView extends StatelessWidget {
  final Color color;
  const ThemeTileView({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    themeNotifier.getTheme;

    return MaterialButton(
      color: color,
      height: 100,
      shape: const CircleBorder(),
      onPressed: () {
        print(color);
        onThemeChanged(color.toString(), themeNotifier);
      },
    );
  }

  void onThemeChanged(String value, ThemeNotifier themeNotifier) {
    if (value == Colors.black.toString()) {
      themeNotifier = themeNotifier.setTheme(darkBlackTheme);
    } else if (value == Colors.blue.toString()) {
      themeNotifier = themeNotifier.setTheme(lightBlueTheme);
    }

    UserSimplePreferences.setTheme(value);
  }
}
