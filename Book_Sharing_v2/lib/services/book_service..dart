import '../models/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookService{
  Firestore _firestore = Firestore.instance;

  Future<List<BookPost>> getAllBookPosts()async{
   QuerySnapshot res1 =  await _firestore.collection("donate_book").getDocuments();
   QuerySnapshot res2 =  await _firestore.collection("request_book").getDocuments();
   List<BookPost> posts = [];

   res1.documents.forEach((d) async {
     final bookId = d["book"];
     final userId = d["user"];
     final book = Book.fromSnapshot(await _firestore.collection("books").document(bookId).get());
     final user = User.fromSnapshot(await _firestore.collection("users").document(userId).get());
     posts.add(BookPost(book: book, user: user, type: BookPostType.Donating));
   });
   res2.documents.forEach((d) async {
     final bookId = d["book"];
     final userId = d["user"];
     final book = Book.fromSnapshot(await _firestore.collection("books").document(bookId).get());
     final user = User.fromSnapshot(await _firestore.collection("users").document(userId).get());
     posts.add(BookPost(book: book, user: user, type: BookPostType.Requesting));
   });
   return posts;
  }
}