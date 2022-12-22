//This class represents a bus or train line by assining it a name and color for userfriendliness
class Lines {
  String line;
  String color;
  //Constructor
  Lines(this.line, this.color);
  //This factory takse a well-defined JSON string (array) and creates a new Lines Object
  factory Lines.fromJson(dynamic json) {
    return Lines(json[0] as String, json[1] as String);
  }
}
