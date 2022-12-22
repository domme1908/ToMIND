import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:varese_transport/screens/details/components/details_container.dart';
import 'package:varese_transport/screens/details/components/station_tile.dart';
import 'package:varese_transport/lib/classes/section.dart';

class Item extends StatelessWidget {
  final Section section;
  final int index;
  final int end;
  const Item(this.section, this.index, this.end, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //This column represents one section of the solutions
    //1st part: Departure station and time
    //2nd part: Description of vehicle, line, stops, etc.
    //3rd part: Arrival station and time
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StationTile(section, true),
        DetailsContainer(section),
        StationTile(section, false),
      ],
    );
  }
}
