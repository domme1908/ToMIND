import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:varese_transport/constants.dart';

//This widget shows a banner containing the logo of Regione Lombarida and E015 Ecosystem
//as per usage-contract of the Muoversi in Lombardia API
class LogoBanner extends StatelessWidget {
  final Color bannerColor;

  const LogoBanner({Key? key, required this.bannerColor}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 55,
        color: bannerColor,
        padding: EdgeInsets.symmetric(
            vertical: kDefaultPadding - 7, horizontal: kDefaultPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              child: Image.asset(
                "assets/images/e015_logo.png",
              ),
              onTap: () async {
                const url = "https://www.e015.regione.lombardia.it/";
                await launch(url);
              },
            ),
            InkWell(
              child: Image.asset("assets/images/lombardia_negativo.png"),
              onTap: () async {
                const url = "https://www.regione.lombardia.it/";
                await launch(url);
              },
            )
          ],
        ));
  }
}
