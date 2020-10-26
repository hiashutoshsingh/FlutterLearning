import 'package:book_sharing_app/pages/post_view/book_page.dart';
import 'package:book_sharing_app/services/book_service..dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:book_sharing_app/models/post_model.dart';

import '../../models/post_model.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  BookService bookService = BookService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: FutureBuilder<List<BookPost>>(
          future: bookService.getAllBookPosts(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(backgroundColor: Colors.white),
              );
            final bookList = snapshot.data;
            return IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                showSearch(context: context, delegate: DataSearch(bookList));
              },
            );
          },
        ),
        title: Text(
          "Search",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: Colors.deepPurpleAccent,
      ),
    );
  }
}

//class DataSearch extends SearchDelegate<String> {
//  final List<String> titleList;
//  bool show = true;
//  Stream<Book> books;
//
//  DataSearch({this.titleList});
//
//  @override
//  List<Widget> buildActions(BuildContext context) {
//    // TODO: implement buildActions
//    return [
//      IconButton(
//        icon: Icon(Icons.clear),
//        onPressed: () {
//          query = "";
//          show = false;
//        },
//      )
//    ];
//  }
//
//  @override
//  Widget buildLeading(BuildContext context) {
//    // TODO: implement buildLeading
//    return IconButton(
//      icon: AnimatedIcon(
//        icon: AnimatedIcons.menu_arrow,
//        progress: transitionAnimation,
//      ),
//      onPressed: () {
//        close(context, null);
//      },
//    );
//  }
//
//  @override
//  Widget buildResults(BuildContext context) {
//    // TODO: implement buildResults
//    return _buildList();
//  }
//
//  @override
//  Widget buildSuggestions(BuildContext context) {
//    return _buildList();
//  }
//
//  _buildList(){
//    return FutureBuilder(
//        future: Firestore.instance.collection("donate_book").getDocuments(),
//        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//          if (!snapshot.hasData) {
//            return Center(child: CircularProgressIndicator());
//          } else if (snapshot.hasError) {
//            return Center(child: Text(snapshot.error.toString()));
//          } else {
//            List<DocumentSnapshot> snap = snapshot.data.documents;
//            final List<String> bookIds = snap
//                .map<String>((ds) => ds["book"])
//                .toList();
//            return FutureBuilder<List<DocumentSnapshot>>(
//                future: getBooks(bookIds),
//                builder: (context, snapshot) {
//                  if (snapshot.hasData) {
//                    List<Book> books = snapshot.data
//                        .map<Book>((e) => Book.fromSnapshot(e))
//                        .where((b) =>
//                        b.title.toLowerCase().contains(query.toLowerCase()))
//                        .toList();
//                    return ListView.builder(
//                      itemCount: books.length,
//                      itemBuilder: (context, index) => ListTile(
//                        title: Text(books[index].title),
//                        onTap: () {
//                          Navigator.of(context).push(
//                            MaterialPageRoute(
//                              builder: (context) =>
//                                  BookPage(snap[index], "Donating"),
//                            ),
//                          );
//                        },
//                      ),
//                    );
//                  } else if (snapshot.hasError) {
//                    return Center(
//                      child: Text("${snapshot.error}"),
//                    );
//                  } else {
//                    return Center(
//                      child: Text("No Data"),
//                    );
//                  }
//                });
//          }
//        });
//  }
//  Widget _buildSearchResult() {
//    return show
//        ? Container(
//            margin: EdgeInsets.all(2),
//            width: double.infinity,
//            height: 100,
//            child: Card(
//              child: Center(
//                child: Text(query),
//              ),
//            ),
//          )
//        : Container();
//  }
//
//  Future<Book> getBook(String id) async {
//    return Book.fromSnapshot(
//        await Firestore.instance.collection("books").document(id).get());
//  }
//
//  Future<List<DocumentSnapshot>> getBooks(List<String> ids) async {
//    final firestoreRef = Firestore.instance.collection("books");
//    List<DocumentSnapshot> books = [];
//    ids.forEach((id) async {
//      books.add(await firestoreRef.document(id).get());
//    });
//    return books;
//  }
//}

class DataSearch extends SearchDelegate<String> {
  final List<BookPost> bookPosts;

  DataSearch(this.bookPosts);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildList(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildList(context);
  }

  Widget _buildList(BuildContext context) {
    final List<BookPost> result = bookPosts
        .where(
            (bp) => bp.book.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView(
      children: result
          .map((bp) => ListTile(
                title: Text(bp.book.title),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookPage(
                        PostModel(bookId: bp.book.id, userId: bp.user.id), bp.type),
                  ),
                ),
              ))
          .toList(),
    );
  }
}
