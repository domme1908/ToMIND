import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:DaQui_to_MIND/constants.dart';
import 'package:DaQui_to_MIND/lib/classes/logo_banner.dart';
import 'package:DaQui_to_MIND/screens/home/components/api_call.dart';
import 'package:DaQui_to_MIND/screens/menu_items/language_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../menu_items/about.dart';

class NavigationDrawer extends StatefulWidget {
  NavigationDrawer({Key? key}) : super(key: key);

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    bool _train = APICallState.train,
        bus = APICallState.bus,
        ship = APICallState.ship,
        tram = APICallState.tram,
        metro = APICallState.metro,
        cablecar = APICallState.cablecar;
    return Drawer(
        child: Material(
      color: kPrimaryColor,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
            child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(kDefaultPadding),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  const SizedBox(height: 24),
                  buildMenuItem(
                    text: AppLocalizations.of(context)!.vehicles,
                    icon: Icons.bus_alert,
                    onClicked: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                                builder: (context, setState) => AlertDialog(
                                      actions: [
                                        Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                kDefaultPadding,
                                                0,
                                                kDefaultPadding,
                                                kDefaultPadding),
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: kSecondaryColor,
                                                  shape: StadiumBorder(),
                                                  enableFeedback: true,
                                                  shadowColor: kPrimaryColor,
                                                ),
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                                child: Text("OK")))
                                      ],
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30))),
                                      backgroundColor: kPrimaryColor,
                                      contentTextStyle: baseTextStyle.copyWith(
                                          color: Colors.white, fontSize: 15),
                                      titleTextStyle: headerTextStyle.copyWith(
                                          color: Colors.white, fontSize: 18),
                                      title: Text(AppLocalizations.of(context)!
                                          .select_vehicles),
                                      content: Container(
                                        height: 480,
                                        width: screenSize.width * 0.9,
                                        child: Column(children: [
                                          SwitchListTile(
                                            activeColor: kSecondaryColor,
                                            title: Text(
                                              AppLocalizations.of(context)!
                                                  .train,
                                              style:
                                                  subHeaderTextStyle.copyWith(
                                                      color: Colors.white,
                                                      fontSize: 15),
                                            ),
                                            secondary: Image.asset(
                                              "assets/images/train.png",
                                              scale: 9,
                                            ),
                                            value: _train,
                                            onChanged: (bool value) {
                                              setState(() {
                                                APICallState.train = value;
                                                _train = value;
                                              });
                                            },
                                          ),
                                          const SizedBox(height: 18),
                                          SwitchListTile(
                                            activeColor: kSecondaryColor,
                                            title: Text(
                                              AppLocalizations.of(context)!
                                                  .metro,
                                              style:
                                                  subHeaderTextStyle.copyWith(
                                                      color: Colors.white,
                                                      fontSize: 15),
                                            ),
                                            secondary: Image.asset(
                                              "assets/images/metro_treno.png",
                                              scale: 9,
                                            ),
                                            value: metro,
                                            onChanged: (bool value) {
                                              setState(() {
                                                APICallState.metro = value;
                                                metro = value;
                                              });
                                            },
                                          ),
                                          const SizedBox(height: 17),
                                          SwitchListTile(
                                            activeColor: kSecondaryColor,
                                            title: Text(
                                              AppLocalizations.of(context)!.bus,
                                              style:
                                                  subHeaderTextStyle.copyWith(
                                                      color: Colors.white,
                                                      fontSize: 15),
                                            ),
                                            secondary: Image.asset(
                                              "assets/images/bus.png",
                                              scale: 9,
                                            ),
                                            value: bus,
                                            onChanged: (bool value) {
                                              setState(() {
                                                APICallState.bus = value;
                                                bus = value;
                                              });
                                            },
                                          ),
                                          const SizedBox(height: 17),
                                          SwitchListTile(
                                            activeColor: kSecondaryColor,
                                            title: Text(
                                              AppLocalizations.of(context)!
                                                  .tram,
                                              style:
                                                  subHeaderTextStyle.copyWith(
                                                      color: Colors.white,
                                                      fontSize: 15),
                                            ),
                                            secondary: Image.asset(
                                              "assets/images/tram.png",
                                              scale: 9,
                                            ),
                                            value: tram,
                                            onChanged: (bool value) {
                                              setState(() {
                                                APICallState.tram = value;
                                                tram = value;
                                              });
                                            },
                                          ),
                                          const SizedBox(height: 17),
                                          SwitchListTile(
                                            activeColor: kSecondaryColor,
                                            title: Text(
                                              AppLocalizations.of(context)!
                                                  .ship,
                                              style:
                                                  subHeaderTextStyle.copyWith(
                                                      color: Colors.white,
                                                      fontSize: 15),
                                            ),
                                            secondary: Image.asset(
                                              "assets/images/traghetto.png",
                                              scale: 9,
                                            ),
                                            value: ship,
                                            onChanged: (bool value) {
                                              setState(() {
                                                ship = value;
                                                APICallState.ship = value;
                                              });
                                            },
                                          ),
                                          const SizedBox(height: 17),
                                          SwitchListTile(
                                            activeColor: kSecondaryColor,
                                            title: Text(
                                              AppLocalizations.of(context)!
                                                  .cable_car,
                                              style:
                                                  subHeaderTextStyle.copyWith(
                                                      color: Colors.white,
                                                      fontSize: 15),
                                            ),
                                            secondary: Image.asset(
                                              "assets/images/funicolare.png",
                                              scale: 9,
                                            ),
                                            value: cablecar,
                                            onChanged: (bool value) {
                                              setState(() {
                                                APICallState.cablecar = value;
                                                cablecar = value;
                                              });
                                            },
                                          ),
                                        ]),
                                      ),
                                    ));
                          });
                    },
                  ),
                  const SizedBox(height: 16),
                  buildMenuItem(
                    text: AppLocalizations.of(context)!.language,
                    icon: Icons.language,
                    onClicked: () => selectedItem(context, 1),
                  ),
                  const SizedBox(height: 24),
                  Divider(color: Colors.white70),
                  const SizedBox(height: 24),
                  Platform.isAndroid
                      ? buildMenuItem(
                          text: AppLocalizations.of(context)!.coffe,
                          icon: Icons.favorite_border,
                          onClicked: () => selectedItem(context, 2),
                        )
                      : Container(),
                  const SizedBox(height: 24),
                  buildMenuItem(
                    text: 'About',
                    icon: Icons.info,
                    onClicked: () => selectedItem(context, 4),
                  ),
                ],
              ),
            ),
          ],
        )),
        Container(
          padding: EdgeInsets.all(kDefaultPadding),
          child: Text(
            AppLocalizations.of(context)!.data_banner_drawer,
            style: headerTextStyle.copyWith(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
        LogoBanner(
          bannerColor: kPrimaryColor,
        ),
      ]),
    ));
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;
    final hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  Future<void> selectedItem(BuildContext context, int index) async {
    Navigator.of(context).pop();
    switch (index) {
      case 4:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => About(),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => LanguagePicker(),
        ));
        break;
      case 2:
        const url = "https://www.buymeacoffee.com/dominik.markart";
        await launch(url);
        break;
      case 0:
        break;
    }
  }
}
