import 'package:flutter/material.dart';
import 'package:DaQui_to_MIND/constants.dart';
import 'package:DaQui_to_MIND/lib/classes/itinerary.dart';
import 'package:DaQui_to_MIND/lib/classes/vehicles_icons.dart';
import 'package:DaQui_to_MIND/screens/details/details_screen.dart';
import 'package:DaQui_to_MIND/screens/home/components/api_call.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SolutionsCard extends StatelessWidget {
  //The data of this specific solution
  final Itinerary data;
  //The list of lines involved
  List<Widget>? lineIconsList;
  SolutionsCard(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Save the thumbnail consisting of the list of lines
    final itineraryThumb = Container(
      alignment: FractionalOffset.centerLeft,
      child: Row(
        //For readability excluded to function
        children: lineIcons(data),
      ),
    );
    //Basic text styles
    const baseTextStyle = TextStyle(fontFamily: 'Poppins');
    final regularTextStyle = baseTextStyle.copyWith(
        color: kPrimaryColor.withAlpha(200),
        fontSize: 9.0,
        fontWeight: FontWeight.w400);
    final subHeaderTextStyle = regularTextStyle.copyWith(fontSize: 12.0);
    final headerTextStyle = baseTextStyle.copyWith(
        color: kPrimaryColor, fontSize: 23.0, fontWeight: FontWeight.w600);
    //The actual content of the card
    final cardContent = Container(
      margin: const EdgeInsets.all(kDefaultPadding),
      constraints: const BoxConstraints.expand(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(height: 4.0),
          Row(
            //Space between positions the elements on the outside -> perfect for this case
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(
                      width: 200,
                      child: ListTile(
                        leading: Image.asset("assets/images/departure.png",
                            scale: 20),
                        title: Text(data.departure, style: headerTextStyle),
                        subtitle: Text((data.departureStation),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: regularTextStyle.copyWith(fontSize: 12)),
                        dense: true,
                      )),
                  SizedBox(
                      width: 200,
                      child: ListTile(
                        leading:
                            Image.asset("assets/images/arrival.png", scale: 20),
                        title: Text(data.arrival, style: headerTextStyle),
                        subtitle: Text((data.arrivalStation),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: regularTextStyle.copyWith(fontSize: 12)),
                        dense: true,
                      )),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(AppLocalizations.of(context)!.departs_at,
                      style: subHeaderTextStyle),
                  Text(
                    //Check if solution has already departed
                    getTimeToDeparture(data).inMinutes < 0
                        ? AppLocalizations.of(context)!.already_departed
                        :
                        //Check if difference is less than 2 hours
                        getTimeToDeparture(data).inMinutes > 119
                            ?
                            //If no check if difference is less than 1 day
                            getTimeToDeparture(data).inHours > 24
                                ?
                                //If no print the difference formatted as days
                                getTimeToDeparture(data).inDays.toString() +
                                    AppLocalizations.of(context)!.days
                                //If difference is less than a day but more than 2 hours print formatted as hours
                                : getTimeToDeparture(data).inHours.toString() +
                                    AppLocalizations.of(context)!.hours
                            //If difference is less than 2 hours print formatted as minutes
                            : getTimeToDeparture(data).inMinutes.toString() +
                                "min",
                    style: headerTextStyle.copyWith(
                        fontSize: getTimeToDeparture(data).inMinutes < 0
                            ? 18
                            : getTimeToDeparture(data).inMinutes > 99
                                ? 25
                                : 28),
                  ),
                  Text(
                    AppLocalizations.of(context)!.duration +
                        data.duration.toString(),
                    style: subHeaderTextStyle,
                  ),
                  Text(
                    AppLocalizations.of(context)!.transfers +
                        data.transfers.toString(),
                    style: subHeaderTextStyle,
                    textAlign: TextAlign.left,
                  ),
                ],
              )
            ],
          ),
          //A small spacer
          Container(height: 5.0),
          //Spacer
          Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              height: 2.0,
              color: const Color(0xff00c6ff)),
          itineraryThumb
        ],
      ),
    );
    //The block that depicts the card
    final solutionCard = GestureDetector(
        onTap: () {
          DetailsScreen.chosenItinerary = data;
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const DetailsScreen()));
        },
        child: Container(
          child: cardContent,
          height: 220.0,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Colors.black38,
                blurRadius: 15.0,
                offset: Offset(0.0, 10.0),
              ),
            ],
          ),
        ));
    //Putting all the pieces together and return a container card
    return Container(
      height: 220.0,
      margin: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 20.0,
      ),
      child: solutionCard,
    );
  }
}

//This function determines how much time remains before the departure of the given itinerary
Duration getTimeToDeparture(Itinerary itinerary) {
  //End date is the date of departure
  DateTime endDate = DateTime.parse(DateTime.now().year.toString() +
      "-" +
      (DateTime.now().month < 10
          ? "0" + DateTime.now().month.toString()
          : DateTime.now().month.toString()) +
      "-" +
      (DateTime.now().day < 10
          ? "0" + DateTime.now().day.toString()
          : DateTime.now().day.toString()) +
      " " +
      itinerary.departure.replaceAll("*", "") +
      ":00");
  //startDate is the current time
  DateTime startDate = DateTime.now();
  //Get the requested date
  String tempDate = APICallState.date;
  tempDate = tempDate.replaceAll(".", "-");
  //Convert the date into the right format
  DateTime requestedDate = DateTime.parse(tempDate.substring(6, 10) +
      "-" +
      tempDate.substring(3, 5) +
      "-" +
      tempDate.substring(0, 2));

  if (itinerary.departure.contains("*"))
    requestedDate = requestedDate.add(const Duration(days: 1));
  //Get only the date of today without the time!
  DateTime today = DateTime.parse(DateTime.now().toString().substring(0, 10));
  //Check if search is being conducted for a date in the future
  if (requestedDate.isAfter(today)) {
    //If date is in the future add the days it is in the future to the endDate
    endDate = endDate.add(Duration(
        days: (Duration(
                milliseconds: requestedDate
                    .subtract(
                        Duration(milliseconds: today.millisecondsSinceEpoch))
                    .millisecondsSinceEpoch)
            .inDays)));
  }
  //Calculate the difference between the two dates
  Duration diff = endDate.difference(startDate);
  //Return the latter
  return diff;
}

//This function defines the thumbnail consisting of all the lines used
List<Widget> lineIcons(Itinerary itinerary) {
  List<Widget> result = <Widget>[];
  //Neccessary to save how many lines cannot be display on-screen
  var remaining = 0;
  //Add max 2 lines
  for (var i = 0; i < itinerary.vehicels.length; i++) {
    if (i < 3) {
      result.add(
        Container(
            width: 46,
            height: 30,
            child: VehiclesIcons(itinerary.vehicels.elementAt(i))),
      );
      if (i != itinerary.vehicels.length - 1) {
        result.add(const Text(
          " > ",
          style: TextStyle(fontFamily: 'Poppins', fontSize: 22),
        ));
      }
    } else {
      remaining++;
    }
  }
  //If there are lines that cannot be displayed -> <remaining>
  if (remaining > 0) {
    result.add(Container(
      width: 50,
      height: 29,
      decoration: BoxDecoration(
          color: Colors.grey, borderRadius: BorderRadius.circular(10)),
      child: Center(child: Text("+" + remaining.toString())),
    ));
  }
  return result;
}

//A function that converts a standadized hex-Color-String to a Flutter-Color element
Color hexToColor(String code) {
  return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}
