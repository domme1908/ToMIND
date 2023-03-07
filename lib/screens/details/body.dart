import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:DaQui_to_MIND/constants.dart';
import 'package:DaQui_to_MIND/lib/classes/itinerary.dart';
import 'package:DaQui_to_MIND/screens/details/details_screen.dart';
import 'package:DaQui_to_MIND/screens/details/item.dart';

class Body extends StatefulWidget {
  final ScrollController controller;
  const Body({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BodyState(controller);
  }
}

class _BodyState extends State<Body> {
  Itinerary chosenSolution = DetailsScreen.chosenItinerary;
  final ScrollController controller;
  _BodyState(this.controller);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        //Attribution to OSMaps
        SizedBox(
            height: 40,
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Container(
                  margin: EdgeInsets.all(10),
                  color: Color.fromARGB(116, 255, 255, 255),
                  child: InkWell(
                    child: Text(
                      "©OpenStreetMap",
                      textAlign: TextAlign.end,
                      style: baseTextStyle.copyWith(fontSize: 10),
                    ),
                    onTap: () async {
                      const url = "https://www.openstreetmap.org/";
                      await launch(url);
                    },
                  ))
            ])),
        Expanded(
            //Container needs to be white since the mother container is transperant
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    color: Colors.white),
                child: Column(children: [
                  //This is the line on the top of the sliding up panel
                  Container(
                      height: 4,
                      margin: EdgeInsets.only(top: 20),
                      child: Container(
                        height: 5,
                        width: 70,
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(40),
                        ),
                      )),
                  //The title of the sliding up panel
                  Container(
                      margin: EdgeInsets.all(kDefaultPadding),
                      child: Text(
                        AppLocalizations.of(context)!.travel_route,
                        style: headerTextStyle.copyWith(fontSize: 30),
                      )),
                  Expanded(
                      //Create a ListView.builder in order to display the elements of the fetched array
                      child: ListView.builder(
                    controller: controller,
                    shrinkWrap: true,
                    //Every item (element) is a SolutionsCard
                    itemBuilder: (context, index) => Item(
                        chosenSolution.sections[index],
                        index,
                        chosenSolution.sections.length),
                    itemCount: chosenSolution.sections.length,
                  )),
                ])))
      ]),
    );
  }
}
