import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:book_sharing_app/models/post_model.dart';

import 'book_page.dart';

class RequestPostView extends StatefulWidget {
  @override
  _RequestPostViewState createState() => _RequestPostViewState();
}

class _RequestPostViewState extends State<RequestPostView> {
  List<BookPost> postList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection("request_book").snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error));
        } else {
          final posts = snapshot.data.documents;
//          return Container();
          return ListView.builder(
            itemBuilder: (context, index) => PostUI(posts[index]),
            itemCount: posts.length,
          );
        }
      },
    );
  }

  Widget PostUI(DocumentSnapshot doc) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection("books")
          .document(doc["book"])
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text("Error");
        } else {
          final book = Book.fromSnapshot(snapshot.data);
          return Card(
            elevation: 8,
            margin: EdgeInsets.all(5.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BookPage(PostModel(bookId: doc["book"], userId: doc["user"]), BookPostType.Requesting)),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: book.imageUrl == null || book.imageUrl.isEmpty
                              ? AssetImage("assets/book_placeholder.png")
                              : NetworkImage(book.imageUrl),
                        ),
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

                          Text(book.author, style: TextStyle(fontSize: 14)),
//                          book.genres != null
//                              ? Container(
//                                  width: 200,
//                                  child: Wrap(
//                                    direction: Axis.horizontal,
//                                    spacing: 8.0,
//                                    children: book.genres
//                                        .map(
//                                          (e) => Chip(
//                                            label: Text(
//                                              e,
//                                              style: TextStyle(fontSize: 12),
//                                            ),
//                                          ),
//                                        )
//                                        .toList(),
//                                  ),
//                                )
//                              : Container(),
//                          Row(
//                            children: <Widget>[
//                              Icon(
//                                Icons.date_range,
//                                size: 12,
//                              ),
//                              SizedBox(
//                                width: 5,
//                              ),
//                              Text(
//                                "10th March, 2020",
//                                style: TextStyle(fontSize: 12),
//                              ),
//                            ],
//                          ),
//                Padding(
//                  padding: EdgeInsets.all(7),
//                  child: Text(post.date),
//                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
