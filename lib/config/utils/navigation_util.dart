import 'package:flutter/material.dart';

class NotifierNav extends ChangeNotifier {
  String routeName;

  NotifierNav({required this.routeName });

  void setRoute(String newRoute) {
    routeName = newRoute;
    notifyListeners();
  }
}