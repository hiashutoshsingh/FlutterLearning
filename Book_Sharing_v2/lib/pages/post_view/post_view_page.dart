
import 'package:book_sharing_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:book_sharing_app/pages/post_view/donate_post.dart';
import 'package:book_sharing_app/pages/post_view/request_post.dart';

class PostViewPage extends StatefulWidget {
  @override
  _PostViewPageState createState() => _PostViewPageState();
}

class _PostViewPageState extends State<PostViewPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.deepPurpleAccent,
            title: Text("Book Sharing"),
            leading: Icon(Icons.library_books),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.info),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RootScreen(),
                    ),
                  );
                },
              ),
            ],
            bottom: TabBar(
              isScrollable: true,
              tabs: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Tab(
                    child: Text(
                      "Donate",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Tab(
                    child: Text(
                      "Request",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: _buildBody(),
        ));
  }

  Widget _buildBody() {
    return TabBarView(
      children: [
        DonatePostView(),
        RequestPostView(),
      ],
    );
  }
}
