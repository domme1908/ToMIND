//This class saves the data of a station or fermata
class Station {
  String station;
  String type;
  String x;
  String y;
  //This is needed to initialize stations that have not yet been fetched from the API
  Station.empty()
      : station = "null",
        type = "null",
        x = "null",
        y = "null";
  //Constructor
  Station(this.station, this.type, this.x, this.y);
  //Factory from JSON
  factory Station.fromJson(dynamic json) {
    return Station(json["label"] as String, json["type"] as String,
        json["x"] as String, json["y"] as String);
  }
  //This function adds all the values to a string list
  //Needed to save favorite stations on the disk of the device
  List<String> toStringList() {
    List<String> result = [];
    result.add(this.station);
    result.add(this.type);
    result.add(this.x);
    result.add(this.y);
    return result;
  }
}
