import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:DaQui_to_MIND/lib/classes/dynamic_autocomplete.dart';
import 'package:DaQui_to_MIND/lib/classes/station.dart';
import 'package:DaQui_to_MIND/screens/favorites/components/body.dart';
import 'package:DaQui_to_MIND/screens/favorites/favorites_screen.dart';
import 'package:DaQui_to_MIND/screens/home/components/api_call.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../constants.dart';

class FavList extends StatefulWidget {
  AsyncSnapshot<List<List<String>>> snapshot;
  FavList(this.snapshot, this.isFrom, {Key? key}) : super(key: key);
  bool isFrom;
  @override
  State<FavList> createState() => _FavListState(snapshot, isFrom);
}

class _FavListState extends State<FavList> {
  bool isFrom;
  AsyncSnapshot<List<List<String>>> snapshot;
  _FavListState(this.snapshot, this.isFrom);
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () {
                    if (isFrom) {
                      DynamicVTAutocompleteState.textControllerFrom.text =
                          snapshot.data![index].elementAt(0);
                      APICallState.fromStation = Station(
                          snapshot.data![index].elementAt(0),
                          snapshot.data![index].elementAt(1),
                          snapshot.data![index].elementAt(2),
                          snapshot.data![index].elementAt(3));
                    } else {
                      DynamicVTAutocompleteState.textControllerTo.text =
                          snapshot.data![index].elementAt(0);
                      APICallState.toStation = Station(
                          snapshot.data![index].elementAt(0),
                          snapshot.data![index].elementAt(1),
                          snapshot.data![index].elementAt(2),
                          snapshot.data![index].elementAt(3));
                    }
                    Navigator.pop(context);
                  },
                  child: ListTile(
                    trailing: Body.removingFavs
                        ? GestureDetector(
                            child: Icon(
                              Icons.highlight_remove,
                              color: Colors.red,
                            ),
                            onTap: () {
                              print(snapshot.data![index].toString());
                              deleteFav(int.parse(
                                  snapshot.data![index].elementAt(4)));
                              Body.removingFavs = false;

                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          FavScreen(isFrom))));
                            })
                        : Container(
                            width: 1,
                          ),
                    leading: Image.asset(
                      "assets/images/" +
                          snapshot.data![index].elementAt(1) +
                          ".png",
                      scale: 12,
                    ),
                    title: Text(
                      snapshot.data![index].elementAt(0),
                      style: headerTextStyle.copyWith(fontSize: 20),
                    ),
                    subtitle: Text(
                      getTypeOfStation(snapshot.data![index].elementAt(1)),
                      style: subHeaderTextStyle.copyWith(fontSize: 16),
                    ),
                  ));
            }));
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

void deleteFav(int counter) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove("fav" + counter.toString());
}
