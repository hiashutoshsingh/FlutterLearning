import 'package:flutter/material.dart';
import 'package:book_sharing_app/pages/post/request.dart';

class ChoosePost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 500,
        height: 500,
        child: Column(
          children: <Widget>[
            Center(
              child: RaisedButton(
                child: Text("Doante Book"),
                onPressed: (){

                },
              ),
            ),
            Center(
              child: RaisedButton(
                child: Text("Request Book"),
                onPressed: (){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => RequestBook())
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
