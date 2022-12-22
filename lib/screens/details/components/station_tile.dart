import 'package:flutter/material.dart';
import 'package:varese_transport/lib/classes/section.dart';
import 'package:varese_transport/screens/details/components/get_icon.dart';

import '../../../constants.dart';

///This class returns the tile used to display either the departure or the arrival station of one section of the trip
class StationTile extends StatelessWidget {
  final Section section;
  final bool isDeparture;
  const StationTile(this.section, this.isDeparture, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String station, time;
    double padding;
    Widget icon;
    //This is needed to distinguish between the tile being at the beginning or at the end of the path
    if (isDeparture) {
      padding = 20;
      icon = GetIcon(section.description);
      station = section.departure;
      time = section.departureTime;
    } else {
      padding = 30;
      station = section.arrival;
      time = section.arrivalTime;
      icon = const Icon(Icons.circle, color: kSecondaryColor, size: 25);
    }
    return ListTile(
        contentPadding: EdgeInsets.only(left: padding),
        title: Text(station, style: headerTextStyle.copyWith(fontSize: 18)),
        subtitle: Text(time, style: baseTextStyle.copyWith(fontSize: 15)),
        leading: icon);
  }
}
