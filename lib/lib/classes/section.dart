import 'stop.dart';

//This class saves all the relevant data from each individual section of a given itinerary
class Section {
  String id;
  String duration;
  String line;
  String description;
  String departure;
  String departureTime;
  String arrival;
  String arrivalTime;
  String note;
  String xDeparture;
  String xArrival;
  String yDeparture;
  String yArrival;
  List<Stop> stops;
  //The firm that operates this line if "" walking
  String manager;
  String transportDescription;

  Section(
      this.id,
      this.duration,
      this.line,
      this.description,
      this.departure,
      this.departureTime,
      this.arrival,
      this.arrivalTime,
      this.note,
      this.xDeparture,
      this.xArrival,
      this.yDeparture,
      this.yArrival,
      this.stops,
      this.transportDescription,
      [this.manager = "none"]);
  //Create a section instance from a JSON string
  factory Section.fromJson(dynamic json) {
    //Parse the list of stops and save them temporarily
    var stopsObsJson = json["listaFermate"] as List;
    List<Stop> _stops =
        stopsObsJson.map((stopsObj) => Stop.fromJson(stopsObj)).toList();
    //Distinguish walking and other forms of transportation
    if (json.containsKey("gestore")) {
      //This one is for bus, train, etc.
      return Section(
        json['idTratta'] as String,
        json["durata"] as String,
        json["linea"] as String,
        json["mezzo"] as String,
        json["partenza"] as String,
        json["oraPartenza"] as String,
        json["arrivo"] as String,
        json["oraArrivo"] as String,
        json["note"] as String,
        json["xPartenza"] as String,
        json["xArrivo"] as String,
        json["yPartenza"] as String,
        json["yArrivo"] as String,
        _stops,
        json["mezzo"] as String,
        json["gestore"] as String,
      );
    }
    //This one is for walking
    return Section(
      json['idTratta'] as String,
      json["durata"] as String,
      json["linea"] as String,
      json["mezzo"] as String,
      json["partenza"] as String,
      json["oraPartenza"] as String,
      json["arrivo"] as String,
      json["oraArrivo"] as String,
      json["note"] as String,
      json["xPartenza"] as String,
      json["xArrivo"] as String,
      json["yPartenza"] as String,
      json["yArrivo"] as String,
      _stops,
      json["mezzo"] as String,
    );
  }
}
