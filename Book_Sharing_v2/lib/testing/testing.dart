import 'dart:math';

import 'package:book_sharing_app/models/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TestingScreen extends StatefulWidget {
  @override
  _TestingScreenState createState() => _TestingScreenState();
}

class _TestingScreenState extends State<TestingScreen> {
  final _firestore = Firestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Testing")),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection("books").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            final List<DocumentSnapshot> booksSnapshots =
                snapshot.data.documents;
            final List<Book> books = booksSnapshots
                .map((bookSnapshot) => Book.fromSnapshot(bookSnapshot))
                .toList();
            return ListView.builder(
              itemBuilder: (context, index) => Text(books[index].title),
              itemCount: books.length,
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addBook,
        child: Icon(Icons.plus_one),
      ),
    );
  }
  final r = Random();
  void _addBook() async {
    Book newBook = Book(title: "New Book ${r.nextInt(100)}", author: "Pruthvi Patel", imageUrl: "",genres: ["mst"]);
    await _firestore.collection("books").add(newBook.toMap());
  }
}
