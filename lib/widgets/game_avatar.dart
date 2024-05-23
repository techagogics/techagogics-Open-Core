import 'package:flutter/material.dart';
import '../utilities/realtime.dart';

class GameAvatar extends StatelessWidget {
  final String score;
  final Color? backgroundColor;
  const GameAvatar({Key? key, required this.score, this.backgroundColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: backgroundColor ?? RandomColor.getRandom(),
      child: Text(score),
    );
  }
}
