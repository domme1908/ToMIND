import 'package:flutter/material.dart';
import 'package:varese_transport/lib/classes/section.dart';

///This class returns the logo of the manager of a certain section in the itinerary
class GetManager extends StatelessWidget {
  final Section section;
  const GetManager(this.section, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //section.manager is equal to manager if the manager was not present in the json object and thus not initialized
    //This should only happen when the section is walking but to avoid exceptions we check for it
    if (section.manager != "manager") {
      //Here we try to load the right logo using the string given by API
      return Image.asset(
          "assets/images/aziende_trasporto/" + section.manager + ".png",
          scale: 7,
          //The error builder is called if there is no image with exactly the name of the manager as per API response
          errorBuilder: (BuildContext context, Object Excpetion, StackTrace) {
        switch (section.manager) {
          //Multiple managers under one parent company and thus same logo
          case "PEREGO":
          case "CTPI":
            return Image.asset(
              "assets/images/aziende_trasporto/CTPI.png",
              scale: 7,
            );
          case "BGTRASP-EST":
          case "BGTRASP-OV":
          case "BGTRASP-SUD":
            return Image.asset(
                "assets/images/aziende_trasporto/BGTRASP-EST.png",
                scale: 2);
          case "TRASPBS-NORD":
          case "TRASPBS-SUD":
            return Image.asset(
                "assets/images/aziende_trasporto/TRASPBS-NORD.png",
                scale: 7);
          //It's impossible to save a file in this format
          case "CO.MO.FUN":
            return Image.asset("assets/images/aziende_trasporto/co_mo_fun.png",
                scale: 7);
          //If the logo is not found just return a text representation of the manager
          default:
            return Text(section.manager);
        }
      });
    }
    //Just to make the compiler happy
    return const Text("");
  }
}
