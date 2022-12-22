import 'package:flutter/material.dart';
import 'package:varese_transport/screens/home/components/header_with_textfields.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Body extends StatefulWidget {
  State<StatefulWidget> createState() {
    return BodyState();
  }
}

class BodyState extends State<Body> {
  static bool ads = false;
  Exception ex = Exception();
  bool flag = false;
  //This method checks weather the api we are trying to reach is available or not
  Future<http.Response?> checkConnection() async {
    try {
      return await http.get(Uri.parse('https://apidaqui-18067.nodechef.com/'));
    } on Exception catch (e) {
      //Save exeption for debug
      ex = e;
      print(ex);
      flag = true;
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    //This is the layout of the homescreen
    return FutureBuilder(
        future: checkConnection(),
        builder: (context, snapshot) {
          if (flag) {
            if (snapshot.data == null) {
              //Alert the user that there is no connection
              return AlertDialog(
                  title: Text(AppLocalizations.of(context)!.server_unavailable),
                  content: Text(
                      AppLocalizations.of(context)!.server_unavailable_details),
                  actions: [
                    TextButton(
                        onPressed: () {
                          //Refresh the page
                          setState(() {
                            checkConnection();
                          });
                        },
                        child: Text(AppLocalizations.of(context)!.try_again))
                  ]);
            }
          }
          if (snapshot.hasData) {
            http.Response response = snapshot.data! as http.Response;
            print("responseeeee " + response.body);
            if (response.body == "adsOk") ads = true;
            if (response.body == "noAds") ads = false;
          }
          return snapshot.hasData
              ? Column(
                  children: <Widget>[
                    //Startup actual application
                    HeaderWithTextfields(),
                  ],
                )
              : Center(child: CircularProgressIndicator());
        });
  }
}
