import 'package:book_sharing_app/models/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//class Snapshot {
//  final String title;
//  final String description;
//
//  Snapshot(this.title, this.description);
//}

class BookPage extends StatelessWidget {
  final PostModel post;
  final BookPostType bookPostType;
  BookPage(this.post, this.bookPostType);

//
//  // In the constructor, require a Todo.
//  BookPage({Key key, @required this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text(
          "Book Page",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: StreamBuilder(
          stream: Firestore.instance
              .collection("books")
              .document(post.bookId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();
            final book = Book.fromSnapshot(snapshot.data);
            return Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: book.imageUrl == null ||
                                          book.imageUrl.isEmpty
                                      ? AssetImage(
                                          "assets/book_placeholder.png")
                                      : NetworkImage(book.imageUrl)),
                            ),
                            width: 100,
                            height: 150,
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  book.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(book.author,
                                    style: TextStyle(fontSize: 14)),
                                book.genres != null
                                    ? Container(
                                  width: 200,
                                  child: Wrap(
                                    direction: Axis.horizontal,
                                    spacing: 8.0,
                                    children: book.genres
                                        .map(
                                          (e) => Chip(
                                        label: Text(
                                          e,
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    )
                                        .toList(),
                                  ),
                                )
                                    : Container(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(
                        height: 1,
                        color: Colors.black,
                      ),
                      Text(
                        "--Users Who Are ${bookPostType == BookPostType.Requesting ? "Requesting" : "Donating"} --",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Divider(
                        height: 1,
                        color: Colors.black,
                      ),
                      StreamBuilder(
                        stream: Firestore.instance
                            .collection("users")
                            .document(post.userId)
                            .snapshots(),
                        builder: (context, snapshot) {
                          final bUser = User.fromSnapshot(snapshot.data);
                          return ExpansionTile(
                            title: Text(
                              bUser.name,
                              style: TextStyle(fontSize: 18),
                            ),
                            trailing: Icon(Icons.person),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Email Id:  ${bUser.email}",
                                      style: TextStyle(fontSize: 16),
                                      textAlign: TextAlign.left,
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Phone Number:  ${bUser.phone}",
                                      style: TextStyle(fontSize: 16),
                                      textAlign: TextAlign.left,
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "City:  ${bUser.city}",
                                      style: TextStyle(fontSize: 16),
                                      textAlign: TextAlign.left,
                                    )),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
