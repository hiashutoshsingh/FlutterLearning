
import 'package:book_sharing_app/pages/post/donate.dart';
import 'package:book_sharing_app/pages/post/request.dart';
import 'package:flutter/material.dart';
import 'package:book_sharing_app/pages/chat/chat.dart';
import 'package:book_sharing_app/pages/post/choose_post.dart';
import 'package:book_sharing_app/pages/profile/user_profile.dart';
import 'package:book_sharing_app/pages/search/search.dart';
import 'package:book_sharing_app/pages/post_view/post_view_page.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  var _bottomNavigationIndex = 0;

  _showBottomSheet() {
    showModalBottomSheet(context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) {
        return Container(
          height: 120,
          color: Colors.deepPurpleAccent,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);

                        Navigator.of(bc).push(
                            MaterialPageRoute(builder: (context) => DonateBook()));
                      },
                      child: Text("Donate Book",style: TextStyle(color: Colors.white, fontSize: 18),)),
                ),
                Divider(
                  thickness: 0.5,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                        Navigator.of(bc).push(
                            MaterialPageRoute(builder: (context) => RequestBook()));
                      },
                      child: Text("Request Book",style: TextStyle(color: Colors.white, fontSize: 18),)),
                ),
              ],
            ),
          ),

        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var pages = [
      new PostViewPage(),
      new Search(),
      new Chat(),
      new UserProfile(),
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      body: pages[_bottomNavigationIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (index){
          switch(index){
            case 0:
              setState(() {
                _bottomNavigationIndex = 0;
              });
              break;
            case 1:
              setState(() {
                _bottomNavigationIndex = 1;
              });
              break;
            case 2:
              _showBottomSheet();
              break;
            case 3:
              setState(() {
                _bottomNavigationIndex = 2;
              });
              break;
            case 4:
              setState(() {
                _bottomNavigationIndex = 3;
              });
              break;
//
          }
        },

        backgroundColor: Colors.deepPurpleAccent,
        currentIndex: _bottomNavigationIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.white),
            title: Text("Home",
              style: TextStyle(color: Colors.white),),
//            backgroundColor: Color.fromRGBO(170, 0, 0, 1),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Colors.white),
            title: Text("Search",
              style: TextStyle(color: Colors.white),),
//            backgroundColor: Color.fromRGBO(170, 0, 0, 1),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit, color: Colors.white),
            title: Text("Post",
              style: TextStyle(color: Colors.white),),
//            backgroundColor: Color.fromRGBO(170, 0, 0, 1),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat, color: Colors.white),
            title: Text("Chat",
              style: TextStyle(color: Colors.white),),
//            backgroundColor: Color.fromRGBO(170, 0, 0, 1),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.white),
            title: Text("Profile",
              style: TextStyle(color: Colors.white),
            ),
//            backgroundColor: Color.fromRGBO(170, 0, 0, 1),
          ),
        ],
      ),
    );
  }


}

