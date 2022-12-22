// ignore_for_file: import_of_legacy_library_into_null_safe
import 'package:flutter/material.dart';
import 'package:varese_transport/screens/home/components/api_call.dart';
import 'package:varese_transport/screens/home/components/navigation_drawer.dart';
import '../body.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        drawer: NavigationDrawer(),
        //Paint the top app bar - in this case just the menu icon
        appBar: build_app_bar(),
        //Call the body class to paint the central elements
        body: Body(),
        //Call the class that manages the bottom button and the
        //API call
        bottomNavigationBar: APICall());
  }

  AppBar build_app_bar() {
    //Just some design stuff
    return AppBar(
      elevation: 0,
      backgroundColor: Color(0x00000000),
    );
  }
}
