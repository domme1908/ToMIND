import 'package:flutter/material.dart';
import 'package:DaQui_to_MIND/constants.dart';
//This class was developed by Sergi Martínez, source: https://github.com/sergiandreplace/flutter_planets_tutorial/blob/Lesson_3_Planets-Flutter_adding_content_to_the_card/lib/ui/home/home_page.dart

class GradientAppBar extends StatelessWidget {
  final String title;
  final double barHeight = 66.0;

  const GradientAppBar(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.only(top: statusBarHeight),
      height: statusBarHeight + barHeight,
      child: ListTile(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 35,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          title,
          style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 36.0),
        ),
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [kSecondaryColor, kSecondaryColor],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
    );
  }
}
