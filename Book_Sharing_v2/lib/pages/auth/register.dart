import 'package:book_sharing_app/pages/auth/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:book_sharing_app/models/post_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../home_page/home_screen.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _fireStore = Firestore.instance;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false;
  var cityDropDownValue;
  var departmentDropDownValue;
  List<String> cities = <String>[
    'Vadodara',
    'Ahmedabad',
    'Surat',
    'Gandhinagar'
  ];
  List<String> departments = <String>[
    'CSE',
    'Civil Engineering',
    'Electrical Engineering',
    'Mechanical Engineering'
  ];

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  void initState() {
    cityDropDownValue = cities[0];
    departmentDropDownValue = departments[0];
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Create An Account"),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Name is required!";
                      }
                      return null;
                    },
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Email is required!";
                      } else if (!isEmail(value)) {
                        return "Email is not valid!";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Email Address",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: phoneController,
                    validator: (value) {
                      if (value.length != 10) {
                        return "Phone is should be exactly of 10 digits!";
                      } else if (!isNumeric(value)) {
                        return "Phone is not valid!";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    decoration: InputDecoration(
                      labelText: "Phone",
                      border: OutlineInputBorder(),
                    ),
                  ),
//                  SizedBox(height: 20.0),
                  TextFormField(
                    obscureText: true,
                    controller: passwordController,
                    validator: (value) {
                      if (value.length < 6) {
                        return "Password is must be atleast 6 characters!";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "password",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    obscureText: true,
                    validator: (value) {
                      if (value.length < 6) {
                        return "Password is must be atleast 6 characters!";
                      } else if (value != passwordController.text) {
                        return "Both password must be the same!";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      DropdownButton<String>(
                        value: cityDropDownValue,
                        style: TextStyle(color: Colors.black),
                        items: cities.map((String city) {
                          return new DropdownMenuItem<String>(
                            value: city,
                            child:
                                new Text(city, overflow: TextOverflow.ellipsis),
                          );
                        }).toList(),
                        onChanged: (String newValue) {
                          setState(() {
                            cityDropDownValue = newValue;
                          });
                        },
                      ),
                      DropdownButton<String>(
                        value: departmentDropDownValue,
                        style: TextStyle(color: Colors.black),
                        items: departments.map((String dept) {
                          return new DropdownMenuItem<String>(
                            value: dept,
                            child:
                                new Text(dept, overflow: TextOverflow.ellipsis),
                          );
                        }).toList(),
                        onChanged: (String newValue) {
                          setState(() {
                            departmentDropDownValue = newValue;
                          });
                        },
                      ),
                    ],
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
                            "Register",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Login())),
                    child: Text(
                      "Already an existing user? Sign in",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
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
    String error;
    if (!formKey.currentState.validate()) return;
    setState(() {
      isLoading = true;
    });
    User newUser = User(
      name: nameController.text,
      phone: phoneController.text,
      email: emailController.text,
      city: cityDropDownValue,
      department: departmentDropDownValue,
    );

    try {
      final result = await _auth.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      await _fireStore
          .collection("users")
          .document(result.user.uid)
          .setData(newUser.toJson());
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } on PlatformException catch (e) {
      print("PlatformException[FirebaseAuthError]: ${e.code}");

      switch (e.code) {
        case FirebaseAuthErrorCode.INVALID_EMAIL:
          error = "Invalid Email Address!";
          break;
        case FirebaseAuthErrorCode.WEAK_PASSWORD:
          error = "Password must be atleast of 6 characters!";
          break;
        case FirebaseAuthErrorCode.EMAIL_ALREADY_IN_USE:
          error = "User is already exists, please try to sign in!";
          break;
        case FirebaseAuthErrorCode.NETWORK_ERROR:
          error = "Make sure you connected with the internet!";
          break;
      }
    } catch (e) {
      error = e.toString();
    } finally {
      setState(() {
        isLoading = false;
      });
      if (error != null) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(error),
        ));
      }
    }
  }
}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}

bool isEmail(String value) {
  return RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(value);
}



class FirebaseAuthErrorCode {
  static const INVALID_EMAIL = "ERROR_INVALID_EMAIL";
  static const WRONG_PASSWORD = "ERROR_WRONG_PASSWORD";
  static const NO_USER_FOUND = "ERROR_USER_NOT_FOUND";
  static const USER_NOT_ALLOWED = "ERROR_USER_DISABLED";
  static const NETWORK_ERROR = "ERROR_NETWORK_REQUEST_FAILED";

  //SignUp Specific codes
  static const EMAIL_ALREADY_IN_USE = "ERROR_EMAIL_ALREADY_IN_USE";
  static const WEAK_PASSWORD = "ERROR_WEAK_PASSWORD";
}
