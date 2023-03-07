import 'package:DaQui_to_MIND/lib/classes/section.dart';

///This class represents one possible solution for the requested route
class Itinerary {
  //Later neccessary to get exact route details
  int solutionID;
  int transfers;
  String duration;
  String departure;
  String xDeparture;
  String yDeparture;
  String arrival;
  String departureStation;
  String arrivalStation;
  String xArrival;
  String yArrival;

  List<Section> sections;
  //A list of all the lines involved in the solution
  List<String> vehicels;
  Itinerary.empty()
      : solutionID = -1,
        transfers = -1,
        duration = "",
        departure = "",
        arrival = "",
        departureStation = "",
        arrivalStation = "",
        vehicels = List<String>.empty(),
        sections = List<Section>.empty(),
        xArrival = "",
        yArrival = "",
        xDeparture = "",
        yDeparture = "";
  //Constructor
  Itinerary(
      this.solutionID,
      this.transfers,
      this.duration,
      this.departure,
      this.arrival,
      this.departureStation,
      this.arrivalStation,
      this.vehicels,
      this.sections,
      this.xDeparture,
      this.yDeparture,
      this.xArrival,
      this.yArrival);
  //Factory that gets a well-defined JSON string and initializes a new Itinerary-Object
  factory Itinerary.fromJson(dynamic json) {
    var sectionsObsJson = json["listaTratte"] as List;
    List<Section> _sections = sectionsObsJson
        .map((sectionsObj) => Section.fromJson(sectionsObj))
        .toList();
    //Return the new object by using the constructor
    return Itinerary(
        int.parse(json['idPercorso']),
        int.parse(json['numeroCambi']),
        json['durata'] as String,
        json['oraPartenza'] as String,
        json['oraArrivo'] as String,
        json['partenza'] as String,
        json['arrivo'] as String,
        List<String>.from(json["mezziPercorso"]),
        _sections,
        json['xPartenza'] as String,
        json['yPartenza'] as String,
        json['xArrivo'] as String,
        json['yArrivo'] as String);
  }
}
