//This class represents a stop of a section
class Stop {
  //Not much to comment - everything pretty self-explainatory
  String id;
  String name;
  String arrival;
  String departure;
  String x;
  String y;
  Stop(
    this.id,
    this.name,
    this.arrival,
    this.departure,
    this.x,
    this.y,
  );
  factory Stop.fromJson(dynamic json) {
    return Stop(
        json["idFermata"] as String,
        json["nome"] as String,
        json["partenza"] as String,
        json["arrivo"] as String,
        json["x"] as String,
        json["y"] as String);
  }
}
