
import 'package:book_sharing_app/models/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tagging/flutter_tagging.dart';


class RequestBook extends StatefulWidget {
  @override
  _RequestBookState createState() => _RequestBookState();
}

class _RequestBookState extends State<RequestBook> {
  final scafKey = new GlobalKey<ScaffoldState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _authorController = TextEditingController();
  TextEditingController _genreController = TextEditingController();

  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  String _selectedValuesJson = 'Nothing To Show';
  List<Genre> _genre = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scafKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        leading: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Request new Book"),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Add a book information",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _titleController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Title is required!";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Title of book",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _authorController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Author is required!";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Author",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  FlutterTagging<Genre>(
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: _genreController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
//                    hintText: 'Search Tags',
//                    hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                        labelText: 'Select Tags',
                      ),
                    ),
                    findSuggestions: GenreService.getGenres,
                    additionCallback: (value) {
                      return Genre(name: value, position: 0);
                    },
                    onAdded: (genre) {
                      return Genre(name: _genreController.text);
                    },
                    initialItems: _genre,
                    configureChip: (gen) {
                      return ChipConfiguration(
                        label: Text(gen.name),
                        backgroundColor: Colors.deepPurpleAccent,
                        labelStyle: TextStyle(color: Colors.white),
                        deleteIconColor: Colors.white,
                      );
                    },
                    configureSuggestion: (gen) {
                      return SuggestionConfiguration(
                        title: Text(gen.name),
                        subtitle: Text(gen.position.toString()),
                        additionWidget: Chip(
                          avatar: Icon(
                            Icons.add_circle,
                            color: Colors.white,
                          ),
                          label: Text('Add New Tag'),
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w300,
                          ),
                          backgroundColor: Colors.deepPurpleAccent,
                        ),
                      );
                    },
                    onChanged: () {
                      setState(() {
                        _selectedValuesJson = _genre
                            .map<String>((gen) => '\n${gen.toJson()}')
                            .toList()
                            .toString();
                        _selectedValuesJson =
                            _selectedValuesJson.replaceFirst('}]', '}\n]');
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  isLoading
                      ? CircularProgressIndicator()
                      : MaterialButton(
                    elevation: 0,
                    focusElevation: 0,
                    highlightElevation: 0,
                    minWidth: double.infinity,
                    height: 50,
                    color: Theme.of(context).primaryColor,
                    onPressed: _submit,
                    child: Text(
                      "Request this book",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submit() async {
    if (!formKey.currentState.validate()) return;
    if (_genre.isEmpty) {
      scafKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Add a genre!"),
        ),
      );
      return;
    }
    setState(() {
      isLoading = true;
    });

    try {
      final newBook = Book(
        title: _titleController.text,
        author: _authorController.text,
        genres: _genre.map((e) => e.name).toList(),
      );

      final bookRef =
      await Firestore.instance.collection("books").add(newBook.toMap());
      final user = await FirebaseAuth.instance.currentUser();
      final postMap = {"book": bookRef.documentID, "user": user.uid};
      await Firestore.instance.collection("request_book").add(postMap);
      setState(() {
        isLoading = false;
      });
      scafKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Posted Successfully!"),
        ),
      );
    } catch (e) {
      print("$e");
      setState(() {
        isLoading = false;
      });
    }
  }
}


class GenreService {
  /// Mocks fetching Genre from network API with delay of 500ms.
  static Future<List<Genre>> getGenres(String query) async {
    await Future.delayed(Duration(milliseconds: 500), null);
    return <Genre>[
      Genre(name: 'Self Development', position: 1),
      Genre(name: 'Fiction', position: 2),
      Genre(name: 'Science-Fiction', position: 3),
      Genre(name: 'Technical', position: 4),
      Genre(name: 'Non-Fiction', position: 5),
      Genre(name: 'Mystery', position: 6),
    ]
        .where((genr) => genr.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}

class Genre extends Taggable {
  ///
  final String name;

  ///
  final int position;

  /// Creates Genre
  Genre({
    this.name,
    this.position,
  });

  @override
  List<Object> get props => [name];

  /// Converts the class to json string.
  String toJson() => '''  {
    "name": $name,\n
    "position": $position\n
  }''';
}

