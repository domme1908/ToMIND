import 'package:flutter/material.dart';
import 'package:varese_transport/lib/classes/itinerary.dart';

//This widget is used beneath the solution details to give a preview of
//what vehicles are involved in the given solution
class VehiclesIcons extends StatelessWidget {
  final String vehicle;
  const VehiclesIcons(this.vehicle, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Default path if no match is found
    String path = "assets/images/autobus.png";
    switch (int.parse(vehicle)) {
      case 1:
        path = "assets/images/train.png";
        break;
      case 2:
        path = "assets/images/metro.png";
        break;
      case 3:
        path = "assets/images/autobus.png";
        break;
      case 5:
        path = "assets/images/traghetto.png";
        break;
      case 4:
        path = "assets/images/tram.png";
        break;
      case 6:
        path = "assets/images/funicolare.png";
        break;
    }
    //Return a small box with the icon inside
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9), color: Colors.white),
        padding: const EdgeInsets.all(3),
        child: Image.asset(path));
  }
}
