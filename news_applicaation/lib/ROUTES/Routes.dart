import 'package:flutter/material.dart';
import 'package:news_applicaation/ROUTES/RouteNames.dart';
import 'package:news_applicaation/SCREENS/Homescreen.dart';

class Routes {

static Route<dynamic> onGenerateRoute (RouteSettings settings){

  switch(settings.name){

    case Routenames.homescreen:
    return MaterialPageRoute(builder: (context) =>const Homescreen());

    default:
    return MaterialPageRoute(builder: (context) => const ScaffoldMessenger(child: Text("No page found")),);
  }
}

}