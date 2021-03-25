import 'package:flutter/material.dart';
import 'package:pokedex/constants/constants.dart';

class WebPageWrapper extends StatelessWidget {
  final Widget child;
  WebPageWrapper({@required this.child});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Container(
        alignment: Alignment.topCenter,
        child: SizedBox(
          height: size.height,
          width: size.width * SCREEN_WIDTH,
          child: child,
        ),
      ),
    );
  }
}
