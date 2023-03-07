import 'package:flutter/material.dart';
import 'package:DaQui_to_MIND/constants.dart';
import 'package:DaQui_to_MIND/lib/classes/section.dart';
import 'package:DaQui_to_MIND/screens/details/components/bus_or_train_details.dart';
import 'package:DaQui_to_MIND/screens/details/components/walking_path_button.dart';

///This class is used to get the container that containes all the details on the section of the trip such as line number, manager, train number, etc.
class DetailsContainer extends StatelessWidget {
  final Section section;
  const DetailsContainer(this.section, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(left: 40),
      decoration: BoxDecoration(
          border: Border(
        left: BorderSide(color: kSecondaryColor, width: 3.5),
      )),
      padding: const EdgeInsets.only(left: 0),
      width: size.width * 0.8,
      child: selectDetailedBox(),
    );
  }

  //This function returns the right detailed description based on the given section
  //So for a path that need to be walked we return a simple button that sends the user to google maps
  //Instead for a train or bus ride we give the user info about which bus to take and what stops it makes
  Widget selectDetailedBox() {
    if (section.transportDescription == "") {
      return WalkingPathButton(section);
    }
    return BusOrTrainDetails(section);
  }
}
