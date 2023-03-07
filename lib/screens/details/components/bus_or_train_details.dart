import 'package:flutter/material.dart';
import 'package:DaQui_to_MIND/constants.dart';
import 'package:DaQui_to_MIND/lib/classes/section.dart';
import 'package:DaQui_to_MIND/screens/details/components/get_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

///This widget is the small container between departure and arrival station that contains info
///such as bus or train number, who operates this line, the duration and the stops
class BusOrTrainDetails extends StatelessWidget {
  final Section section;
  const BusOrTrainDetails(this.section, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //The out-most container
    //No height constraint in order to allow for adaptation (opening fermate or simply more or less info)
    //No width constraint since it is being set by the parent
    return Container(
      //Needed for the line on the left hand side to pass by without bejng covered up by this container
      margin: const EdgeInsets.only(left: 40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey.withAlpha(50),
      ),
      child: Column(
          //Aling the items on the left side
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //This row is for the line number and the logo of the manager of the service
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              //Line number
              Container(
                margin: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                height: 30,
                width: 60,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    //Assign each line an exact color
                    color:
                        getBackgroundColor(section.line, section.description)),
                child: Text(
                  section.line,
                  style: baseTextStyle.copyWith(
                      fontWeight: FontWeight.w600,
                      //Choose the text color based on what provides greater contrast using the .computeLuminance
                      //function provided by Color
                      //Since we are using only primaries colors I think its always white but better be safe than sorry
                      color:
                          getBackgroundColor(section.line, section.description)
                                      .computeLuminance() >
                                  0.5
                              ? Colors.black
                              : Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              //Logo of the manager
              Container(
                  padding: const EdgeInsets.fromLTRB(0, 7, 15, 0),
                  child: GetManager(section)),
            ]),
            //Indication about the bus/train etc.
            Container(
              padding: const EdgeInsets.all(10),
              child: Text(
                section.note,
                style: regularTextStyle.copyWith(fontSize: 12),
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(5),
              child: Text(
                AppLocalizations.of(context)!.duration + section.duration,
                style: regularTextStyle.copyWith(fontSize: 12),
              ),
            ),
            //Make sure the stops tab is only display if there actually are any stops
            section.stops.length > 2
                ? ExpansionTile(
                    //-2 since list includes arrival
                    title: Text(
                      (section.stops.length - 2).toString() +
                          (section.stops.length > 3
                              ? AppLocalizations.of(context)!.stops
                              : AppLocalizations.of(context)!.stop),
                      textAlign: TextAlign.left,
                      style: regularTextStyle.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.blue),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    childrenPadding: const EdgeInsets.all(10),
                    children: getStops(section),
                  )
                :
                //Small placeholder in case of direct connection
                Container(
                    height: 10,
                  )
          ]),
    );
  }

  Color getBackgroundColor(String lineName, String description) {
    //Check if line is Metro
    if (description == "2") {
      if (lineName == "M1") {
        return Color(0xFFe31d1a);
      }
      if (lineName == "M2") {
        return Color(0xFF638b18);
      }
      if (lineName == "M3") {
        return Color(0xFFf6a704);
      }
      if (lineName == "M4") {
        return Color(0xFF14386a);
      }
      if (lineName == "M5") {
        return Color(0xFF9778d3);
      }
      //Brescian Metro - Just one line
      if (lineName == "METRO") {
        return Colors.yellow;
      } else {
        //Default case
        return Colors.orange;
      }
    }
    return Colors.primaries
        .elementAt(getIntFromString(lineName) % Colors.primaries.length);
  }

  //A hashing function that assingS an int to a given string
  int getIntFromString(String lineName) {
    var result = 0;
    for (var i = 0; i < lineName.length; i++) {
      result += lineName.codeUnitAt(i);
    }
    return result;
  }

  //Returns a list of widgets that contains all the stations the part of the trip has
  List<Widget> getStops(Section sections) {
    List<Widget> result = [];
    result.add(const Divider());
    for (var i = 1; i < sections.stops.length - 1; i++) {
      result.add(
        Text(
          sections.stops.elementAt(i).arrival +
              ": " +
              sections.stops.elementAt(i).name,
          style: baseTextStyle,
          textAlign: TextAlign.left,
          softWrap: false,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
      if (i != sections.stops.length - 1) {
        result.add(const Divider());
      }
    }
    return result;
  }
}
