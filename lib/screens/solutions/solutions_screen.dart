import 'package:flutter/material.dart';
import 'package:varese_transport/constants.dart';
import 'package:varese_transport/lib/classes/logo_banner.dart';
import 'package:varese_transport/screens/solutions/components/body.dart';

class SolutionsScreen extends StatefulWidget {
  const SolutionsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SolutionsScreenState();
  }
}

class _SolutionsScreenState extends State<SolutionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
      bottomNavigationBar: LogoBanner(
        bannerColor: kSecondaryColor,
      ),
    );
  }
}
