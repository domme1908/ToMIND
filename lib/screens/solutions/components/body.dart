import 'package:flutter/material.dart';
import 'package:DaQui_to_MIND/constants.dart';
import 'package:DaQui_to_MIND/lib/classes/gradient_app_bar.dart';
import 'package:DaQui_to_MIND/lib/classes/itinerary.dart';
import 'package:DaQui_to_MIND/screens/home/components/api_call.dart';
import 'package:DaQui_to_MIND/screens/solutions/components/solutions_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BodyState();
  }
}

class _BodyState extends State<Body> with TickerProviderStateMixin {
  //The list of all solutions provided by the API
  late Future<List<Itinerary>> futureItinerary;
  //Variables needed for the color-changing progressbar
  late AnimationController _animationController;
  late Animation<Color?> _colorTween;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    //Save the function call in a variable
    futureItinerary = APICallState().fetchItinerary();
    //Regulates the progress indicator
    _animationController =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);
    _colorTween = _animationController
        .drive(ColorTween(begin: kPrimaryColor, end: kSecondaryColor));
    _animationController.repeat();
  }

  //Avoids execptions if going back after first opening solutions
  //Disposes the animation controller correctly
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: <Widget>[
      //Create the AppBar
      GradientAppBar(AppLocalizations.of(context)!.solutions),
      //This builder fetches the data and displays a loading bar while doing so
      FutureBuilder<List<Itinerary>>(
        //Execute the async task
        future: futureItinerary,
        builder: (context, snapshot) {
          //Check if response is feasable
          if (snapshot.hasData) {
            //Check if there are solutions to display - if not display cute dog
            if (snapshot.data!.isEmpty) {
              return Expanded(
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(
                          kDefaultPadding, kDefaultPadding, kDefaultPadding, 0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(AppLocalizations.of(context)!.we_are_sorry,
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30)),
                            Text(
                              AppLocalizations.of(context)!.no_results,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 30),
                            ),
                            const Spacer(),
                            Positioned.fill(
                                child: Image.asset(
                              'assets/images/dog.png',
                              fit: BoxFit.fitWidth,
                              alignment: Alignment.bottomCenter,
                              scale: 6,
                            ))
                          ])));
            }
            return Expanded(
                //Create a ListView.builder in order to display the elements of the fetched array
                child: ListView.builder(
              controller: _scrollController,
              //Every item (element) is a SolutionsCard
              itemBuilder: (context, index) {
                return (index == snapshot.data!.length)
                    ? Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                        child: ElevatedButton(
                          child: Text(AppLocalizations.of(context)!.load_more),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              kSecondaryColor,
                            ),
                          ),
                          onPressed: () {
                            checkDate(
                                APICallState.time,
                                snapshot.data![snapshot.data!.length - 1]
                                    .departure);
                            APICallState.time = snapshot
                                .data![snapshot.data!.length - 1].departure;
                            setState(() {
                              futureItinerary = APICallState().fetchItinerary();
                              _scrollController.animateTo(
                                  _scrollController.position.minScrollExtent,
                                  duration: const Duration(milliseconds: 2000),
                                  curve: Curves.fastOutSlowIn);
                            });
                          },
                        ),
                      )
                    : SolutionsCard(snapshot.data![index]);
              },
              itemCount: snapshot.data!.length + 1,
            ));
            //Some error-handling
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return LinearProgressIndicator(
            valueColor: _colorTween,
            minHeight: 4,
          );
        },
      )
    ]));
  }
}

void checkDate(String requestedTime, String lastEvent) {
  DateTime dtLastEvent = DateTime.parse("1970-01-01 " + lastEvent);
  DateTime dtRequestedTime = DateTime.parse("1970-01-01 " + requestedTime);
  if (dtRequestedTime.isAfter(dtLastEvent)) {
    //Get the set date
    String tempDate = APICallState.date;
    //Convert the date into the right format
    DateTime requestedDate = DateTime.parse(tempDate.substring(6, 10) +
        "-" +
        tempDate.substring(3, 5) +
        "-" +
        tempDate.substring(0, 2));
    //Add one day to the requested date
    requestedDate = requestedDate.add(const Duration(days: 1));
    //Reformat the string
    String result = requestedDate.toString().substring(8, 10) +
        "/" +
        requestedDate.toString().substring(5, 7) +
        "/" +
        requestedDate.toString().substring(0, 4);
    //Save the date of the next day in the APICallState
    APICallState.date = result;
  }
}
