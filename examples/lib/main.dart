import 'package:flutter/material.dart';
import "package:shimmer/shimmer.dart";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Stack(children: <Widget>[
          Image.network(
            "https://149398021.v2.pressablecdn.com/wp-content/uploads/2019/12/clouds25.jpg",
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    top: 200,
                    left: 150,
                  ),
                  child: Text(
                    "2:26",
                    style: TextStyle(
                      fontSize: 40,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 110),
                  child: Text(
                    "Friday,16 October",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 300, left: 80),
                  child: Shimmer.fromColors(
                      child: Text(">>Swipe to unlock",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          )),
                      baseColor: Colors.black,
                      highlightColor: Colors.white),
                )
              ],
            ),
          )
        ]),
      ),

      // ,
    );
  }
}
