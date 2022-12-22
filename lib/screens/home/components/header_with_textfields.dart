import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:varese_transport/constants.dart';
import 'package:varese_transport/lib/classes/dynamic_autocomplete.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../lib/classes/station.dart';
import 'api_call.dart';

extension TimeOfDayConverter on TimeOfDay {
  String to24hours() {
    final hour = this.hour.toString().padLeft(2, "0");
    final min = this.minute.toString().padLeft(2, "0");
    return "$hour:$min";
  }
}

class HeaderWithTextfields extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HeaderWithTextfieldsState();
  }
}

class HeaderWithTextfieldsState extends State<HeaderWithTextfields> {
  TextEditingController dateinput = TextEditingController();
  TextEditingController timeinput = TextEditingController();
  TextEditingController startLabel = TextEditingController();
  TextEditingController destinationLabel = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //Set the initial value for date and time fields to today and now
    dateinput.text = DateFormat('dd.MM.yyyy').format(DateTime.now());
    timeinput.text = TimeOfDay.now().format(context);
    //Save same values in the static variables of the APICall
    APICallState.date = DateFormat('dd.MM.yyyy').format(DateTime.now());
    APICallState.time = TimeOfDay.now().format(context);
    //Get total size of the screen
    Size size = MediaQuery.of(context).size;

    Widget getTimePicker() {
      return //Time Picker
          Container(
        //Some basic desing code
        height: 50,
        width: size.width * 0.35,
        margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(36),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 10),
                  blurRadius: 50,
                  color: kPrimaryColor.withOpacity(0.23))
            ]),
        //Code similar to date-picker -> check above for doc
        child: TextField(
          controller: timeinput,
          readOnly: true,
          decoration: const InputDecoration(
            icon: Icon(Icons.access_time),
            hintStyle: TextStyle(
              color: Colors.grey,
            ),
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
          onTap: () async {
            if (Platform.isAndroid) {
              TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  //Set initial time to now
                  //Lookups for past time is tecnically possible but not a big issue
                  initialTime: TimeOfDay.now(),
                  builder: (context, childWidget) {
                    //Sets clock to 24h instead of AM PM -> In Italy no one understands AMPM
                    return MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(alwaysUse24HourFormat: true),
                      child: childWidget!,
                    );
                  });
              //Always check if the time was correctly set in order to avoid NullPointerExceptions
              if (pickedTime != null) {
                timeinput.text = pickedTime.format(context);
                APICallState.time = pickedTime.to24hours();
              }
            } else {
              //IOS Date Picker
              showCupertinoModalPopup(
                  context: context,
                  builder: (context) => Container(
                      height: 500,
                      color: const Color.fromARGB(255, 255, 255, 255),
                      child: Column(children: [
                        SizedBox(
                          height: 400,
                          child: CupertinoDatePicker(
                              use24hFormat: true,
                              minimumDate: DateTime.now(),
                              mode: CupertinoDatePickerMode.time,
                              onDateTimeChanged: (val) {
                                TimeOfDay result = TimeOfDay.fromDateTime(val);
                                timeinput.text = result.to24hours();
                                //Save to static APICall variable for API call
                                APICallState.time = result.to24hours();
                              }),
                        ),
                        CupertinoButton(
                          child: const Text('OK'),
                          onPressed: () => Navigator.of(context).pop(),
                        )
                      ])));
            }
          },
        ),
      );
    }

    Widget getDatePicker() {
      return Container(
          margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          height: 50,
          width: size.width * 0.40,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(36),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 50,
                    color: kPrimaryColor.withOpacity(0.23))
              ]),
          child: TextField(
            //Set the controller to be able to change the text afterwards
            controller: dateinput,
            //Avoid popping up of keyboard
            readOnly: true,
            //Design the calendar field
            decoration: const InputDecoration(
              icon: Icon(Icons.calendar_month),
              hintStyle: TextStyle(
                color: Colors.grey,
              ),
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            //Open datepicker
            //This function must be async since we don't know how long the user
            //will keep the window open
            onTap: () async {
              if (Platform.isAndroid) {
                //pickedDate is nullable since the window can be closed without inputting data
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    //Lookups for paste values make no sense hence they are disabled
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101));
                //Proceed only if we have a DateTime object
                if (pickedDate != null) {
                  //Format date
                  String formated = DateFormat('dd.MM.yyyy').format(pickedDate);
                  //Save if to the textfield for user benefit
                  dateinput.text = formated;
                  //Save to static APICall variable for API call
                  APICallState.date = formated;
                }
              } else {
                //IOS Date Picker
                showCupertinoModalPopup(
                    context: context,
                    builder: (context) => Container(
                        height: 500,
                        color: const Color.fromARGB(255, 255, 255, 255),
                        child: Column(children: [
                          SizedBox(
                            height: 400,
                            child: CupertinoDatePicker(
                                use24hFormat: true,
                                minimumDate: DateTime.now(),
                                maximumYear: DateTime.now().year + 1,
                                mode: CupertinoDatePickerMode.date,
                                onDateTimeChanged: (val) {
                                  String formated =
                                      DateFormat('dd.MM.yyyy').format(val);
                                  //Save if to the textfield for user benefit
                                  dateinput.text = formated;
                                  //Save to static APICall variable for API call
                                  APICallState.date = formated;
                                }),
                          ),
                          CupertinoButton(
                            child: const Text('OK'),
                            onPressed: () => Navigator.of(context).pop(),
                          )
                        ])));
              }
            },
          ));
    }

    return Container(
        //40% of total height
        height: size.height * 0.45,
        child: Stack(
            children: <Widget>[
                  //Upper round box
                  Container(
                    //Upper box that lies underneath the textfields
                    padding: const EdgeInsets.only(
                        left: kDefaultPadding,
                        right: 2,
                        bottom: 100 + kDefaultPadding,
                        top: 40),
                    height: size.height * 0.45 - 27,
                    decoration: const BoxDecoration(
                      //Color of upper half of the screen
                      gradient: kGradient,
                      //color: kPrimaryColor,
                      //Make edges round
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(36),
                          bottomRight: Radius.circular(36)),
                    ),
                    //Upper row of greetings text and logo
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          //Greetings text
                          Text(
                            AppLocalizations.of(context)!.homescreen_greeting,
                            style:
                                Theme.of(context).textTheme.headline3!.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                          //const Spacer(),
                          Image.asset(
                            "assets/images/logo.png",
                            //Fit oversize logo to screen
                            scale: 2,
                          )
                        ]),
                  )
                ]
                //As widget list
                +
                //Append the two text field lists
                //See below for doc on helper method
                text_field(size, 120, true, context) +
                text_field(size, 60, false, context) +
                //Add widget list for time and date
                <Widget>[
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Wrap(
                          alignment: WrapAlignment.spaceAround,
                          children: [getDatePicker(), getTimePicker()]))
                ]));
  }
}

//This helper method displays a costumized text field
//The params are: size: screen size, hintText: The hint text for initializazion of
//the empty text field, positionBottom: The margin to the bottom of the textfield -> To be able to stack them
// and isFrom as boolean to set the right static variable for the API call
List<Widget> text_field(
    Size size, double positionBottom, bool isFrom, BuildContext context) {
  Size screenSize = MediaQuery.of(context).size;

  return <Widget>[
    //Searchfield
    Positioned(
      bottom: positionBottom,
      left: 0,
      right: 50,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 50,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(36),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 10),
                  blurRadius: 50,
                  color: kPrimaryColor.withOpacity(0.23))
            ]),
        child: DynamicVTAutocomplete(isFrom),
      ),
    ),
    //This widget draws an iconbutton that switches destination with arrival on tap
    Positioned(
      bottom: screenSize.height * 0.135,
      right: 20,
      child: IconButton(
        icon: Icon(
          Icons.swap_vert_circle_sharp,
          color: Colors.white,
          size: 50,
        ),
        tooltip: 'Cambia partenza e destinazione',
        onPressed: () {
          if (APICallState.toStation.station != "null" &&
              APICallState.toStation.station != "null") {
            Station temp = APICallState.fromStation;
            APICallState.fromStation = APICallState.toStation;
            APICallState.toStation = temp;
            String tempText =
                DynamicVTAutocompleteState.textControllerFrom.text;
            DynamicVTAutocompleteState.textControllerFrom.text =
                DynamicVTAutocompleteState.textControllerTo.text;
            DynamicVTAutocompleteState.textControllerTo.text = tempText;
          }
        },
      ),
    )
  ];
}
