import 'package:book_sharing_app/models/post_model.dart';
import 'package:book_sharing_app/pages/auth/register.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Firestore userProf = Firestore.instance;
  String currentUid;

  final textStylesState = TextStyle(
    fontSize: 11.0,
    color: Colors.white,
  );
  final textStyleTop = TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  final textStyleStatus = TextStyle(
    fontSize: 11.0,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.deepPurpleAccent
        ),
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
              //         colors: [
                      //   Colors.deepPurple,
                      //   Colors.deepPurpleAccent,
                      // ],
                      //         stops: [
                      //   0.3,
                      //   1,
                      // ],
                      begin: Alignment.topRight)),
            ),
            FutureBuilder<FirebaseUser>(
                future: FirebaseAuth.instance.currentUser(),
                builder: (context, authSnapshot) {
                  if (!authSnapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  final userId = authSnapshot.data.uid;
                  return FutureBuilder<DocumentSnapshot>(
                      future: Firestore.instance
                          .collection("users")
                          .document(authSnapshot.data.uid)
                          .get(),
                      builder: (context, userSnapshot) {
                        if (!userSnapshot.hasData)
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        final cUser = User.fromSnapshot(userSnapshot.data);
                        return Column(
                          children: <Widget>[
                            _profileRow(cUser),
                            SizedBox(height: 30),
                            _statesRow(userId),
                            _bottomCard(userId)
                          ],
                        );
                      });
                })
          ],
        ),
      ),
    );
  }

  _profileRow(User user) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.deepPurpleAccent
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Container(
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
                image: DecorationImage(
                  image: AssetImage("assets/person_placeholder.png"),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            SizedBox(width: 15.0),
            Text(user.name, style: TextStyle(fontSize: 24, color: Colors.white),)
          ],
        ),
      ),
    );
  }

  _statesRow(String uid) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            FutureBuilder<QuerySnapshot>(
                future: Firestore.instance
                    .collection("donate_book")
                    .where("user", isEqualTo: uid)
                    .getDocuments(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(child: CircularProgressIndicator());
                  return Column(
                    children: <Widget>[
                      Text(
                        snapshot.data.documents.length.toString(),
                        style: textStyleTop,
                      ),
                      Text(
                        "Books Donated",
                        style: textStylesState,
                      )
                    ],
                  );
                }),
            Text(
              "\u007c",
              style: textStylesState,
            ),
            FutureBuilder<QuerySnapshot>(
                future: Firestore.instance
                    .collection("request_book")
                    .where("user", isEqualTo: uid)
                    .getDocuments(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(child: CircularProgressIndicator());
                  return Column(
                    children: <Widget>[
                      Text(
                        snapshot.data.documents.length.toString(),
                        style: textStyleTop,
                      ),
                      Text(
                        "Books Requested",
                        style: textStyleStatus,
                      )
                    ],
                  );
                }),
//            Text(
//              "\u007c",
//              style: textStylesState,
//            ),
//            Column(
//              children: <Widget>[
//                Text(
//                  "20",
//                  style: textStyleTop,
//                ),
//                Text(
//                  "Trade point",
//                  style: textStylesState,
//                )
//              ],
//            ),
//            Text(
//              "\u007c",
//              style: textStylesState,
//            )
          ],
        ));
  }

  _bottomCard(String uid) {
    return Container(
    child: Column(
      children: <Widget>[
        Transform.translate(
          offset: Offset(0, 70),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35.0),
                  topRight: Radius.circular(35.0),
                )),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "My Donations",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    width: 100.0,
                    height: 300.0,
                    child: FutureBuilder<QuerySnapshot>(
                        future: Firestore.instance
                            .collection("donate_book")
                            .where("user", isEqualTo: uid)
                            .getDocuments(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return Center(
                                child: CircularProgressIndicator());
                          final bookIdList = snapshot.data.documents
                              .map((e) => e["book"])
                              .toList();
                          return ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: bookIdList.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return FutureBuilder<DocumentSnapshot>(
                                  future: Firestore.instance
                                      .collection("books")
                                      .document(bookIdList[index])
                                      .get(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData)
                                      return Container();
                                    final book =
                                        Book.fromSnapshot(snapshot.data);
                                    return item(book);
                                  },
                                );
                              });
                        }),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    ),
    );
  }

  item(Book book) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      width: 180,
      child: Column(
        children: <Widget>[
          Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topRight: Radius.circular(40.0),topLeft: Radius.circular(40.0)),
              color: Colors.purpleAccent,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: book.imageUrl == null || book.imageUrl.isEmpty
                    ? AssetImage("assets/book_placeholder.png")
                    : NetworkImage(book.imageUrl),
              ),
            ),
          ),
          Container(
            height: 80.0,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple,
                )
              ],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0.0),
                topRight: Radius.circular(0.0),
                bottomLeft: Radius.circular(40.0),
                bottomRight: Radius.circular(40.0),
              ),
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      book.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

