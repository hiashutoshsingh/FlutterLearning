import 'package:calculadora_gorjeta/DarkModeController.dart';
import 'package:calculadora_gorjeta/pages/HomePage.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: (BuildContext context, Widget child) {
        return MaterialApp(
          title: 'Calculadora',
          theme: ThemeData(
            brightness: DarkMode.instance.isDarkMode
                ? Brightness.dark
                : Brightness.light,
            primarySwatch: Colors.blue,
          ),
          home: HomePage(),
        );
      },
      animation: DarkMode.instance,
    );
  }
}
