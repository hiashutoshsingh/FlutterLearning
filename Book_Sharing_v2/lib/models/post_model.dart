import 'package:book_sharing_app/pages/auth/register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum BookPostType{ Donating, Requesting }

class BookPost {
  Book book;
  String timestamp;
  User user;
  String availability;
  BookPostType type;

  BookPost({
    this.book,
    this.user,
    this.timestamp,
    this.availability,
    this.type,
  });
}

class PostModel {
  String bookId;
  String userId;


  PostModel({
    this.bookId,
    this.userId,
  });
}

class Book {
  String id;
  String title="";
  String author ="";
  List genres = [];
  String imageUrl;

  Book({this.id, this.title, this.author, this.genres, this.imageUrl});

  Book.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    title = snapshot["title"];
    author = snapshot["author"];
    genres = snapshot["genres"];
    imageUrl = snapshot["imageUrl"];
  }

//  Book.fromMap(Map<String, dynamic> snapshot) {
//    print(snapshot["title"]);
//    title = snapshot["title"];
//    author = snapshot["author"];
//    genres = snapshot["genres"];
//    imageUrl = snapshot["imageUrl"];
//  }

  Map<String, dynamic> toMap() {
    return {
      "title": this.title,
      "author": this.author,
      "genres": this.genres,
      "imageUrl": this.imageUrl,
    };
  }

  @override
  String toString() {
    return 'Book{title: $title, author: $author, genres: $genres, imageUrl: $imageUrl}';
  }

}

class User {
  String id;
  String name;
  String email;
  String phone;
  String city;
  String department;

  User({this.name, this.email, this.phone, this.city, this.department});

//  User.fromJson(Map<String, dynamic> json) {
//    name = json['Name'];
//    email = json['Email'];
//    phone = json['Phone'];
//    city = json['city'];
//    department = json['department'];
//  }

  User.fromSnapshot(DocumentSnapshot json) {
    id = json.documentID;
    name = json['Name'];
    email = json['Email'];
    phone = json['Phone'];
    city = json['city'];
    department = json['department'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['Email'] = this.email;
    data['Phone'] = this.phone;
    data['city'] = this.city;
    data['department'] = this.department;
    return data;
  }
}

