import 'package:flutter/material.dart';
import 'package:DaQui_to_MIND/constants.dart';
import 'package:DaQui_to_MIND/lib/classes/logo_banner.dart';
import 'package:DaQui_to_MIND/screens/solutions/components/body.dart';

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
