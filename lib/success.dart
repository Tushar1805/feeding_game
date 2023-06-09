import 'package:feeding_game/utils.dart';
import 'package:flutter/material.dart';

class GoodJob extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Text(
          "Good Job",
          style: fontStyle(context, 70, Color.fromRGBO(62, 139, 58, 1),
              FontWeight.w900, FontStyle.normal),
        ),
      ),
    );
  }
}
