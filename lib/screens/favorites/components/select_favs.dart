import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:varese_transport/lib/classes/gradient_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../constants.dart';
import '../../../lib/classes/station.dart';
import '../../home/components/api_call.dart';
import '../favorites_screen.dart';

class SelectFavs extends StatefulWidget {
  bool isFrom;
  SelectFavs(this.isFrom);
  @override
  State<StatefulWidget> createState() {
    return _SelectFavsState(isFrom);
  }
}

class _SelectFavsState extends State<SelectFavs> {
  bool isFrom;
  _SelectFavsState(this.isFrom);
  final StreamController<Future<List<Station>>> _controller =
      StreamController();
  final TextEditingController _textController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  Future<void> getStationsStream(text) async {
    final response = APICallState().fetchStations(text);
    _controller.sink.add(response);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      GradientAppBar(AppLocalizations.of(context)!.add_favs),
      Container(
          margin: EdgeInsets.all(kDefaultPadding),
          child: TypeAheadField(
              noItemsFoundBuilder: (context) {
                return ListTile(
                  title: Text(AppLocalizations.of(context)!.no_stations_found,
                      style: TextStyle(
                          color: Colors.black, fontFamily: 'Poppins')),
                );
              },
              keepSuggestionsOnLoading: false,
              textFieldConfiguration: TextFieldConfiguration(
                controller: _textController,
                autofocus: false,
                style: const TextStyle(fontFamily: 'Poppins'),
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.search_stations,
                  suffixIcon: IconButton(
                    onPressed: () {
                      _textController.clear();
                    },
                    icon: const Icon(Icons.clear),
                  ),
                ),
              ),
              suggestionsCallback: (pattern) async {
                return await APICallState().fetchStations(pattern);
              },
              itemBuilder: (context, Station suggestion) {
                return ListTile(
                  leading: Image.asset(
                    "assets/images/" + suggestion.type + ".png",
                    scale: 16,
                  ),
                  subtitle: Text(
                    getTypeOfStation(suggestion.type),
                    style: TextStyle(color: Colors.black),
                  ),
                  title: Text(suggestion.station,
                      style: const TextStyle(
                          color: Colors.black, fontFamily: 'Poppins')),
                );
              },
              onSuggestionSelected: (Station suggestion) {
                saveFav(suggestion, context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => FavScreen(isFrom))));
              }))
    ]));
  }

//Returns the right string of the station type
  String getTypeOfStation(String type) {
    switch (type) {
      case "areadifermata":
        return AppLocalizations.of(context)!.areadifermata;
      case "comune":
        return AppLocalizations.of(context)!.comune;
      case "indirizzo":
        return AppLocalizations.of(context)!.indirizzo;
      case "poi":
        return AppLocalizations.of(context)!.poi;
      case "civico":
        return AppLocalizations.of(context)!.indirizzo;
      case "posizione":
        return AppLocalizations.of(context)!.posizione;
    }
    return AppLocalizations.of(context)!.stop_type_not_found;
  }
}

void saveFav(Station favToSave, BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  bool isPresent = await checkIfPresent(favToSave);
  if (!isPresent) {
    List<String> result;
    result = favToSave.toStringList();
    if (!prefs.containsKey("counter")) {
      prefs.setInt("counter", 1);
      result.add("1");
      prefs.setStringList("fav1", result);
    } else {
      result.add((prefs.getInt("counter")! + 1).toString());
      print(result);
      prefs.setInt("counter", prefs.getInt("counter")! + 1);
      prefs.setStringList("fav" + prefs.getInt("counter")!.toString(), result);
    }
  } else {
    //Display a snackbar to inform the user
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //Snackbar desing
      content: Text(
        favToSave.station + AppLocalizations.of(context)!.already_fav,
        style: baseTextStyle.copyWith(color: Colors.white, fontSize: 16),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: kPrimaryColor,
    ));
  }
}

Future<bool> checkIfPresent(Station favToSave) async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey("counter")) {
    for (var i = 1; i <= prefs.getInt("counter")!; i++) {
      if (prefs.containsKey("fav" + i.toString())) {
        if (prefs.getStringList("fav" + i.toString())!.elementAt(2) ==
                favToSave.x &&
            prefs.getStringList("fav" + i.toString())!.elementAt(3) ==
                favToSave.y) return true;
      }
    }
  }
  return false;
}
