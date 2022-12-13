import 'package:flutter/material.dart';

class ThemeTileView extends StatelessWidget {
  final Color color;
  const ThemeTileView({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(100)),
      ),
      onTap: () {
        print(color);
      },
    );
  }
}
