import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:DaQui_to_MIND/constants.dart';
import 'package:DaQui_to_MIND/lib/classes/itinerary.dart';
import 'package:DaQui_to_MIND/lib/classes/logo_banner.dart';
import 'package:DaQui_to_MIND/screens/details/body.dart';
import 'package:DaQui_to_MIND/screens/details/components/map.dart';
import 'package:DaQui_to_MIND/screens/details/fullscreen_map.dart';

class DetailsScreen extends StatefulWidget {
  static var solutionId = -1;
  static Itinerary chosenItinerary = Itinerary.empty();
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DetailsScreenState();
  }
}

///This functions has a SlidingUpPanel as its main widget that displays
///the map in the background and the details-list in the foreground
class DetailsScreenState extends State<DetailsScreen> {
  static PanelController panelController = PanelController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      floatingActionButton:
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Padding(
            padding: EdgeInsets.all(kDefaultPadding),
            child: FloatingActionButton(
              heroTag: "btn1",
              backgroundColor: kPrimaryColor.withAlpha(200),
              child: Icon(Icons.arrow_back),
              onPressed: (() => Navigator.pop(context)),
            )),
        Padding(
            padding: EdgeInsets.all(kDefaultPadding),
            child: FloatingActionButton(
              heroTag: "btn2",
              backgroundColor: kPrimaryColor.withAlpha(200),
              child: Image.asset(
                "assets/images/fullscreen.png",
                scale: 25,
                color: Colors.white,
              ),
              onPressed: (() => Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => FullscreenMap())))),
            ))
      ]),
      body: SlidingUpPanel(
        boxShadow: [BoxShadow(color: Colors.transparent)],
        //Use panelBuilder in order to pass on the Scrollcontroller
        //This enables the initial pulling up of the panel transitioning to the scrolling
        //Of the list
        panelBuilder: (sc) => Body(controller: sc),
        body: OSMap(),
        backdropEnabled: true,
        color: Color.fromARGB(0, 255, 255, 255),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        maxHeight: size.height * 0.85,
        minHeight: size.height * 0.55,
      ),
      bottomNavigationBar: LogoBanner(
        bannerColor: kSecondaryColor,
      ),
    );
  }
}
