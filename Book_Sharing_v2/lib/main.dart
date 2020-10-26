import 'package:book_sharing_app/pages/auth/login.dart';
import 'package:book_sharing_app/pages/home_page/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:book_sharing_app/pages/splash.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Book Sharing App",
        theme: ThemeData(
          fontFamily: GoogleFonts.poppins().fontFamily,
          primaryColor: Colors.deepPurpleAccent,
          accentColor: Colors.deepPurpleAccent,
        ),
        home: RootScreen(),
      ),
    );


class RootScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseUser>(
      future: FirebaseAuth.instance.currentUser(),
      builder: (context, snapshot) {
        return !snapshot.hasData ? Splash() : HomeScreen();
//        print(snapshot.data);
//        if (!snapshot.hasData) {
//          return Center(
//            child: CircularProgressIndicator(),
//          );
//        } else {
//          return snapshot.data?.uid == null ? Splash() : HomeScreen();
//        }
      },
    );
  }
}
