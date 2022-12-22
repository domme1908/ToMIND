import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:varese_transport/constants.dart';
import 'package:varese_transport/lib/classes/section.dart';
import 'package:varese_transport/lib/classes/stop.dart';
import 'package:varese_transport/lib/classes/vehicles_icons.dart';
import 'package:http/http.dart' as http;
import 'package:varese_transport/screens/home/components/api_call.dart';
import '../../../lib/classes/itinerary.dart';
import '../details_screen.dart';

class OSMap extends StatefulWidget {
  OSMap({Key? key}) : super(key: key);

  @override
  State<OSMap> createState() => _OSMapState();
}

class _OSMapState extends State<OSMap> {
  late List<MapLatLng> polylinePoints;
  late MapTileLayerController mapController;
  late MapZoomPanBehavior _zoomPanBehavior;
  Itinerary chosenSolution = DetailsScreen.chosenItinerary;
  //These are used to avoid having to parse the string-coordinates multiple times
  late double latDep;
  late double longDep;
  late double latArr;
  late double longArr;
  //Get the link from the API
  late Future<http.Response> maplink;
  @override
  void initState() {
    //API Call to get the link
    maplink = APICallState().getMapLink();

    mapController = MapTileLayerController();
    //Parse the response string containing the coordinates
    latDep = double.parse(chosenSolution.yDeparture);
    longDep = double.parse(chosenSolution.xDeparture);
    latArr = double.parse(chosenSolution.yArrival);
    longArr = double.parse(chosenSolution.xArrival);

    //Get the center of the departure and destination of the selected itinerary
    double resultLat = (latDep + latArr) / 2;
    double resultLong = (longDep + longArr) / 2;

    //Specify focalLatLng and enable zooming
    //focalLatLng specifies where we will zoom to in case of double tap
    //Here we set it to the center inbetween the destinations
    _zoomPanBehavior = MapZoomPanBehavior(
        enableDoubleTapZooming: true,
        focalLatLng: MapLatLng(
          resultLat - 0.125,
          resultLong,
        ));
    super.initState();
  }

  ///This method returns the distance in meters inbetween the departure and arrival station
  double getDistance() {
    return Geolocator.distanceBetween(latDep, longDep, latArr, longArr);
  }

  @override
  Widget build(BuildContext context) {
    //FutureBuilder needed to be able to fetch the link dynamically
    return FutureBuilder(
        future: maplink,
        builder: (context, snapshot) {
          //Make sure to that we got the link
          if (snapshot.data != null) {
            //Cast the response so that we can access .body later
            http.Response parsedSnap = snapshot.data as http.Response;
            //Stack the attribution to OSMaps on top of the MapTileLayer
            return Stack(children: [
              SfMaps(
                layers: [
                  MapTileLayer(
                    zoomPanBehavior: _zoomPanBehavior,
                    controller: mapController,
                    //Set the area that is visible at startup
                    //Since we have the sliding up panel everything is slightly shifted upwards
                    initialLatLngBounds: MapLatLngBounds(
                        MapLatLng(min(latArr, latDep) - getDistance() / 90000,
                            max(longArr, longDep) + getDistance() / 1000000),
                        MapLatLng(max(latArr, latDep) + getDistance() / 300000,
                            min(longArr, longDep) - getDistance() / 1000000)),
                    //insert the url we got from the server as map tiles provider
                    urlTemplate: parsedSnap.body,
                    //Show the path of the journey
                    sublayers: [
                      MapPolylineLayer(
                        polylines: getLines().toSet(),
                      ),
                    ],
                    initialMarkersCount: getListOfMarkers().length,
                    markerBuilder: (BuildContext context, int index) {
                      return getMarkers(context, index);
                    },

                    ///TODO MarkerTooltips
                    ///This is the biggest TODO for the next version - should be developed in the next sprint
                    /*
                    tooltipSettings: const MapTooltipSettings(
                        color: kSecondaryColor, hideDelay: double.infinity),
                    markerTooltipBuilder: (BuildContext context, int index) {
                      return Container(
                        width: 50,
                        height: 20,
                        color: kSecondaryColor,
                        padding: const EdgeInsets.all(kDefaultPadding),
                        child: Row(children: [
                          Image.asset(
                            "assets/images/transfer.png",
                            scale: 5,
                          ),
                          VehiclesIcons(chosenSolution.vehicels.first)
                        ]),
                      );
                    },*/
                  ),
                ],
              ),
              //Attribution to OSMaps
              Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                      margin: EdgeInsets.all(10),
                      //Semi-Trasperent
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
                      ))),
            ]);
          }
          //Show the secondary color while the maplink is being retrieved
          return Container(
            color: kSecondaryColor,
          );
        });
  }

  //This function creates the lines inbetween the stops of all the sections
  List<MapPolyline> getLines() {
    List<MapPolyline> result = [];
    for (Section section in chosenSolution.sections) {
      MapPolyline sectionLine;
      List<MapLatLng> points = [];
      //section.stops is only empty if the path is walking
      if (section.stops.length == 0) {
        points = [
          MapLatLng(double.parse(section.yDeparture),
              double.parse(section.xDeparture)),
          MapLatLng(
              double.parse(section.yArrival), double.parse(section.xArrival))
        ];
        //Create the typicall dotted blue line for the path done by foot
        sectionLine = MapPolyline(
            points: points, width: 5.5, color: Colors.blue, dashArray: [5, 5]);
        result.add(sectionLine);
      } else {
        //Create the line of the section by following all the stops
        for (Stop stop in section.stops) {
          points.add(MapLatLng(double.parse(stop.y), double.parse(stop.x)));
          sectionLine = MapPolyline(
              points: points,
              color: getColorFromTD(section.transportDescription),
              width: 5.5);
          result.add(sectionLine);
        }
      }
    }
    return result;
  }

  ///This function returns a color for each vehicle that can be used
  Color getColorFromTD(String description) {
    switch (description) {
      case "1":
        return Color(0xFF006c67);
      case "2":
        return Color(0xFFe30514);
      case "3":
        return Color(0xFFFF1ABF);
      case "4":
        return Color(0xFF5e17eb);
      case "5":
        return Color(0xFFffde59);
      case "6":
        return Color(0xFF7ae582);
    }
    //Just a backup
    return Colors.white;
  }

  ///This function places a marker on every station. Doing so it distinguishes between
  ///departure, arrival, stations where the user needs to change and stations in which the
  ///itinerary only stops but no user interaction is required
  List<MapMarker> getListOfMarkers() {
    List<MapMarker> result = [];
    Section section;
    Stop stop;
    for (var i = 0; i < chosenSolution.sections.length; i++) {
      section = chosenSolution.sections.elementAt(i);
      //Set the marker for the departure station
      if (i == 0) {
        result.add(MapMarker(
            child: Image.asset(
              "assets/images/departure_map.png",
              scale: 6,
            ),
            latitude: double.parse(section.yDeparture),
            longitude: double.parse(section.xDeparture)));
      }
      //Set the marker for the arrival station
      //We check if the loop is at the last section - this also works in case of only two sections
      if (i == chosenSolution.sections.length - 1) {
        result.add(MapMarker(
            child: Image.asset(
              "assets/images/destination_map.png",
              scale: 6,
            ),
            latitude: double.parse(section.yArrival),
            longitude: double.parse(section.xArrival)));
      }
      //This part is for the inbetween stops
      //We decide if it is first stop of a new section and thus the point w
      //where the user needs to change or if it is any other stop where there is no
      //user interaction needed
      for (var j = 0; j < section.stops.length; j++) {
        stop = section.stops.elementAt(j);
        //Here we need to distinguish two cases
        //1. The section is not the but-last one -> in this case we simply set the marker
        //that indicates the need to change simply on the first stop of the section
        //2. The section is the but-last one and the last section is walking
        //In this case we need to set the change marker on the last station of the but last section since
        //the walking-sections do not have any stops
        if (j == 0 ||
            (j == section.stops.length - 1 &&
                chosenSolution.sections
                        .elementAt(chosenSolution.sections.length - 1)
                        .stops
                        .length ==
                    0 &&
                i == chosenSolution.sections.length - 2)) {
          //Change required
          result.add(MapMarker(
              child: Icon(
                Icons.circle,
                color: Color(0xFFFF9249),
                size: 18,
              ),
              latitude: double.parse(stop.y),
              longitude: double.parse(stop.x)));
        }
        //This clause is needed to avoid setting a stop point if the connection is direct
        //and there are no stops at all
        else if (chosenSolution.sections.length != 1) {
          if (stop.y != chosenSolution.yArrival &&
              stop.x != chosenSolution.xArrival)
            //No change required
            result.add(MapMarker(
                child: Icon(
                  Icons.circle,
                  color: Color(0xFFFFFFFF),
                  size: 10,
                ),
                latitude: double.parse(stop.y),
                longitude: double.parse(stop.x)));
        }
      }
    }
    return result;
  }

  MapMarker getMarkers(BuildContext context, int index) {
    List<MapMarker> result = getListOfMarkers();
    return result.elementAt(index);
  }
}
