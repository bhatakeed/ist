import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Constant {
  static String univerUrl = "https://www.iust.ac.in/";
  static Color primaryColor = Colors.blue;
  static Color secondaryColor = Colors.red;
  static Color indTabColor = Colors.red;
  static TextStyle headerFont = const TextStyle(fontFamily: 'Righteous');
  static TextStyle tabsTextStyle = const TextStyle(fontSize: 12,fontWeight: FontWeight.w900,letterSpacing: 1);
  static Color backgroundAppColor = Colors.white30;
  static final  KFlexibleSpaceBar = Container(
  decoration: BoxDecoration(
  gradient: LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Colors.lightBlueAccent.withOpacity(0.1),
    Colors.lightBlueAccent.withOpacity(0.5),
    Colors.lightBlueAccent.withOpacity(1.0)
  ]
  ),
  ),
  );
  static const KTitleStyle = TextStyle(
      fontFamily: 'Dosis',
      fontSize: 12,
      fontWeight: FontWeight.bold,
      letterSpacing: 1);
  static const KSwitchColor = Colors.blue;
  static final KbodyColor = Colors.lightBlueAccent.withOpacity(0.1);
}
