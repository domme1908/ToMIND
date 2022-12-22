import 'package:flutter/material.dart';

///This class simply returns the fitting icon for the list tile of the departure station
class GetIcon extends StatelessWidget {
  final String vehicle;
  const GetIcon(this.vehicle, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (vehicle == "") {
      return Image.asset(
        "assets/images/walk.png",
        scale: 12,
      );
    }
    var intVehicle = int.parse(vehicle);
    switch (intVehicle) {
      case 3:
        return Image.asset(
          "assets/images/bus.png",
          scale: 12,
        );
      case 1:
        return Image.asset(
          "assets/images/train.png",
          scale: 11.5,
        );
      case 2:
        return Image.asset(
          "assets/images/metro_treno.png",
          scale: 12,
        );
      case 4:
        return Image.asset(
          "assets/images/tram.png",
          scale: 12,
        );
      case 5:
        return Image.asset(
          "assets/images/traghetto.png",
          scale: 12,
        );
      case 6:
        return Image.asset("assets/images/funicolare.png", scale: 12);
    }
    //Some fallback code
    return const Icon(Icons.not_interested);
  }
}
