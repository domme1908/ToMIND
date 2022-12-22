import 'package:flutter/material.dart';
import 'package:varese_transport/constants.dart';
import 'package:varese_transport/screens/details/components/map.dart';

class FullscreenMap extends StatefulWidget {
  FullscreenMap({Key? key}) : super(key: key);

  @override
  State<FullscreenMap> createState() => _FullscreenMapState();
}

class _FullscreenMapState extends State<FullscreenMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: Padding(
          padding: EdgeInsets.fromLTRB(kDefaultPadding - 15, kDefaultPadding,
              kDefaultPadding, kDefaultPadding),
          child: FloatingActionButton(
            backgroundColor: kPrimaryColor.withAlpha(200),
            child: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: OSMap(),
    );
  }
}
