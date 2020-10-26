import 'package:book_sharing_app/pages/auth/register.dart';
import 'package:book_sharing_app/pages/home_page/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text("Login"),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 70),
                      Image.asset(
                        "assets/login.png",
                        width: 200,
                      ),
                      SizedBox(height: 70),
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
                      SizedBox(height: 20),
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
                                "Login",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Register())),
                        child: Text(
                          "Don't have an account? Sign up",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                )),
          ),
        ));
  }

  void _submit() async {
    String error;
    if (!formKey.currentState.validate()) return;
    setState(() {
      isLoading = true;
    });

    try {
      await _auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } on PlatformException catch (e) {
      print("PlatformException[FirebaseAuthError]: ${e.code}");
      switch (e.code) {
        case FirebaseAuthErrorCode.INVALID_EMAIL:
          error = "Invalid email address!";
          break;
        case FirebaseAuthErrorCode.WRONG_PASSWORD:
          error = "Invalid password!";
          break;
        case FirebaseAuthErrorCode.USER_NOT_ALLOWED:
          error = "User is not allowed!";
          break;
        case FirebaseAuthErrorCode.NO_USER_FOUND:
          error = "No user found, try sign up insted!";
          break;
        case FirebaseAuthErrorCode.NETWORK_ERROR:
          throw error = "Make sure you connected with the internet!";
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

  bool isEmail(String value) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
  }
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
