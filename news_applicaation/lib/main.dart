import 'package:flutter/material.dart';
import 'package:news_applicaation/ROUTES/RouteNames.dart';
import 'package:news_applicaation/ROUTES/Routes.dart';

void main(){
  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routenames.homescreen,
      onGenerateRoute: Routes.onGenerateRoute,
    );
  }
}