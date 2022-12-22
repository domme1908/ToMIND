import 'package:flutter/material.dart';
import 'package:varese_transport/lib/classes/gradient_app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class About extends StatefulWidget {
  About({Key? key}) : super(key: key);

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        GradientAppBar("About"),
        Expanded(
            child: Stack(children: [
          WebView(
            initialUrl: 'https://apidaqui-18067.nodechef.com/about',
            onPageFinished: (finish) {
              setState(() {
                isLoading = false;
              });
            },
          ),
          isLoading ? Center(child: CircularProgressIndicator()) : Container()
        ])),
      ]),
    );
  }
}
