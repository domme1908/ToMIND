import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:DaQui_to_MIND/constants.dart';
import 'package:DaQui_to_MIND/lib/classes/gradient_app_bar.dart';
import 'package:DaQui_to_MIND/screens/favorites/components/fav_list.dart';
import 'package:DaQui_to_MIND/screens/favorites/components/select_favs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Body extends StatefulWidget {
  bool isFrom;
  Body(this.isFrom);
  static bool removingFavs = false;
  @override
  State<StatefulWidget> createState() {
    return _BodyState(isFrom);
  }
}

class _BodyState extends State<Body> {
  _BodyState(this.isFrom);
  bool isFrom;

  final Future<List<List<String>>> _favs = getFavs();
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GradientAppBar(AppLocalizations.of(context)!.favs),
        FutureBuilder(
            future: _favs,
            builder: (BuildContext context,
                AsyncSnapshot<List<List<String>>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) return noFavsYet(context);

                return FavList(snapshot, this.isFrom);
              } else {
                return CircularProgressIndicator();
              }
            }),
        Container(
            width: screenSize.width,
            height: 70,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
              child: Text(
                AppLocalizations.of(context)!.remove_favs,
                style:
                    headerTextStyle.copyWith(color: Colors.white, fontSize: 22),
              ),
              onPressed: () {
                Body.removingFavs = !Body.removingFavs;
                setState(() {});
              },
            )),
        Container(
            width: screenSize.width,
            height: 70,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(kSecondaryColor),
              ),
              child: Text(
                AppLocalizations.of(context)!.add_favs,
                style:
                    headerTextStyle.copyWith(color: Colors.white, fontSize: 22),
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SelectFavs(isFrom),
                ));
              },
            )),
      ],
    );
  }
}

Widget noFavsYet(BuildContext context) {
  return Container(
      margin: EdgeInsets.only(top: 30),
      child: Column(
        children: [
          Image.asset(
            "assets/images/dog.png",
            scale: 7,
          ),
          Text(
            AppLocalizations.of(context)!.no_favs,
            style: headerTextStyle.copyWith(fontSize: 30),
          ),
          Text(
            AppLocalizations.of(context)!.try_add_favs,
            style: headerTextStyle.copyWith(fontSize: 20),
          )
        ],
      ));
}

Future<List<List<String>>> getFavs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (!prefs.containsKey("counter")) {
    return List<List<String>>.empty();
  } else {
    List<List<String>> result = [];
    for (String key in prefs.getKeys()) {
      if (key != "counter" && key != "lang" && key != "ads") {
        result.add(prefs.getStringList(key)!);
      }
    }
    return result;
  }
}
