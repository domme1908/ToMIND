import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:varese_transport/constants.dart';
import 'package:http/http.dart' as http;
import 'package:varese_transport/lib/classes/itinerary.dart';
import 'package:varese_transport/screens/home/body.dart';
import 'package:varese_transport/screens/solutions/solutions_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../lib/classes/station.dart';
import '../../../lib/classes/stop.dart';

class APICall extends StatefulWidget {
  const APICall({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return APICallState();
  }
}

class APICallState extends State<APICall> {
  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;

  @override
  void initState() {
    super.initState();
    _createInterstitialAd();
  }

  @override
  void dispose() {
    super.dispose();
    _interstitialAd?.dispose();
  }

  ///This function decides whether to show an ad on click of the search button or not
  ///If it is the first time the user opens the app no ads are shown
  ///Ads are shown every second time the user does a search
  Future<bool> checkIfShowAd() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("ads")) {
      if (prefs.getInt("ads")! % 2 == 0) {
        return true;
      }
    }
    return false;
  }

  ///This function checks weather the key ads is already present, if it is it will be incremented
  ///by one, otherwise it will be created
  Future<void> incrementSearches() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("ads")) {
      prefs.setInt("ads", prefs.getInt("ads")! + 1);
    } else {
      prefs.setInt("ads", 1);
    }
  }

  ///This function returns the string, that needs to be appended to the request in order select which vehicles
  ///are desired by the user - defaults to all vehicles allowed
  String getVehicles() {
    List<String> tempResult = [];
    String result = "%20%22options%22:%20%5b";
    if (train) tempResult.add("%221");
    if (metro) tempResult.add("%222");
    if (bus) tempResult.add("%223");
    if (tram) tempResult.add("%224");
    if (ship) tempResult.add("%225");
    if (cablecar) tempResult.add("%226");
    if (tempResult.length == 0) {
      return "";
    }
    if (tempResult.length == 1) {
      result += tempResult.first + "%22";
    } else {
      for (int i = 0; i < tempResult.length; i++) {
        if (i != tempResult.length - 1) {
          result += tempResult.elementAt(i) + "%22,";
        } else {
          result += tempResult.elementAt(i) + "%22";
        }
      }
    }
    result += "%5d,%20";
    String output = result.replaceAll("%22", "\"").replaceAll("%20", " ");
    print(output);
    return result;
  }

  //These variables are used for the API call - they are updated from the body class
  static Station fromStation = Station.empty(), toStation = Station.empty();
  static String from = "null", to = "null", time = "", date = "";
  static bool train = true,
      bus = true,
      ship = true,
      tram = true,
      metro = true,
      cablecar = true;
  static final AdRequest request = AdRequest();
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(kDefaultPadding),
        height: 100,
        child: ElevatedButton(
          onPressed: () {
            //Check if neccessary values have been given and if they are not the same
            if (!(fromStation.station == "null") &&
                !(toStation.station == "null") &&
                !((fromStation.x == toStation.x) &&
                    (fromStation.y == toStation.y)) &&
                getVehicles() != "") {
              checkIfShowAd().then((flag) {
                if (flag) {
                  print(BodyState.ads);
                  if (BodyState.ads) {
                    _showInterstitialAd();
                  }
                }
              });
              incrementSearches();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SolutionsScreen()));
            } else {
              var errorMes;
              //Values have been given but are equal
              if ((fromStation.x == toStation.x &&
                  fromStation.y == toStation.y)) {
                errorMes = AppLocalizations.of(context)!.station_cannot_be_same;
              }
              //Values have not been given but there are some vehicles selected
              else if (getVehicles() != "") {
                errorMes = AppLocalizations.of(context)!.no_stations_given;
              }
              //No vehicles are selected -> this has max priority so we override any previous message
              if (getVehicles() == "") {
                errorMes = AppLocalizations.of(context)!.no_vehicles_given;
              }
              //Otherwise display a snackbar with the error message
              errorMes = SnackBar(
                //Snackbar desing
                content: Text(
                  errorMes,
                  style:
                      baseTextStyle.copyWith(color: Colors.white, fontSize: 16),
                ),
                behavior: SnackBarBehavior.floating,
                backgroundColor: kPrimaryColor,
              );
              //Display the snackbar
              ScaffoldMessenger.of(context).showSnackBar(errorMes);
            }
          },
          style: ElevatedButton.styleFrom(
            primary: kSecondaryColor,
            shape: StadiumBorder(),
            enableFeedback: true,
            shadowColor: kPrimaryColor,
            elevation: 12,
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            //Leave this here to divede the space of the Button equally in three
            Text(""),
            Text(
              AppLocalizations.of(context)!.search_button,
              style:
                  headerTextStyle.copyWith(color: Colors.white, fontSize: 25),
            ),
            Icon(
              Icons.search,
              size: 35,
            ),
          ]),
        ));
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId:
            //'ca-app-pub-3940256099942544/8691691433',
            'ca-app-pub-2779208204217812/7073875316',
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < 3) {
              _createInterstitialAd();
            }
          },
        ));
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  ///This call is to get the link for the maps from the api in order to be
  ///able to change it later without having to update the whole app
  Future<http.Response> getMapLink() async {
    return http
        .get(Uri.parse('https://apidaqui-18067.nodechef.com/getMapLink'));
  }

  //The api call - sends the collected values to the js rest api
  Future<List<Itinerary>> fetchItinerary() async {
    print('https://apidaqui-18067.nodechef.com/getSolutions?from=' +
        (fromStation.station != "Posizione"
            ? fromStation.station.replaceAll(RegExp('\\s'), '%20')
            : "La tua posizione") +
        "&fromX=" +
        fromStation.x +
        "&fromY=" +
        fromStation.y +
        "&to=" +
        toStation.station.replaceAll(RegExp('\\s'), '%20') +
        "&toX=" +
        toStation.x +
        "&toY=" +
        toStation.y +
        "&date=" +
        date.replaceAll(".", "/") +
        "&when=" +
        time +
        "&options=" +
        getVehicles());
    final response = await http.get(Uri.parse(
        'https://apidaqui-18067.nodechef.com/getSolutions?from=' +
            (fromStation.station != "Posizione"
                ? fromStation.station.replaceAll(RegExp('\\s'), '%20')
                : "La tua posizione") +
            "&fromX=" +
            fromStation.x +
            "&fromY=" +
            fromStation.y +
            "&to=" +
            toStation.station.replaceAll(RegExp('\\s'), '%20') +
            "&toX=" +
            toStation.x +
            "&toY=" +
            toStation.y +
            "&date=" +
            date.replaceAll(".", "/") +
            "&when=" +
            time +
            "&options=" +
            getVehicles()));
    print("BODY" + response.body);
    if (response.body == "") {
      List<Itinerary> result = [];
      return Future<List<Itinerary>>.value(result);
    }
    //Call the compute function provided by flutter
    return compute(
        parseItinerary,
        response
            .body); //--> We create an isolated element that eventually returns the value, thus the fetchItinerary() function must be async
  }

  List<Itinerary> parseItinerary(String responseBody) {
    //Parse the response to a JSON Map
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    //Execute the json-factory of class Itinerary on all elements in order to return a List<Itinerary>
    return parsed.map<Itinerary>((json) => Itinerary.fromJson(json)).toList();
  }

  Future<List<Station>> fetchStations([text]) async {
    print("Fetching stations for " + text);
    final response = await http.get(Uri.parse(
        'https://apidaqui-18067.nodechef.com/getStations?text=' + text));
    return compute(parseStations, response.body);
  }

  List<Station> parseStations(String responseBody) {
    if (responseBody.contains("error")) {
      return List<Station>.empty();
    }
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Station>((json) => Station.fromJson(json)).toList();
  }

  List<Stop> parseStops(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Stop>((json) => Stop.fromJson(json)).toList();
  }
}
