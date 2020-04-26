import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'profile_settings.dart';
import 'readLocalProfileData.dart';
import 'login_page.dart';
import 'main.dart';
import 'userData.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class signinPage extends StatefulWidget {
  signinPage() : super(key: key);

  @override
  signinPageState createState() => signinPageState();
}

class signinPageState extends State<signinPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  String _email = "";
  String _password = "";
  String data;

  void _register() async {
    final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
      email: _email,
      password: _password,
    ))
        .user;
    if (user != null) {
      setState(() {
        print("signup success!!!");

        writeUsername(_email);
        writePassword(_password);
      });
      userData tempUser = userData("$_email");
      await tempUser.createDocumentforUser();

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    } else {
      print("signup failed!");
    }
  }

  void _signingWithLocalInfo(String u, String p) async {
    print("attempting signin");
    final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
      email: u,
      password: p,
    ))
        .user;
    if (user != null) {
      setState(() {
        print("signup success!!!");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
      });
    } else {
      print("signup failed!");
    }
  }

  void onSignupPressed() {
    print('The user wants to login with $_email and $_password');
    _register();
  }

  void gotoLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => loginPage()),
    );
  }

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 10), () {
      String lUsername;
      String lPassword;

      readUsername("username").then((String value) {
        setState(() {
          lUsername = value;
        });
        readPassword("password").then((String value) {
          setState(() {
            lPassword = value;
          });
          print("THE LOADED USERNAME IS $lUsername , PASSWORD IS $lPassword");
          _signingWithLocalInfo(lUsername, lPassword);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final emailField = TextField(
      obscureText: false,
      style: style,
      onChanged: (text) {
        print("First text field: $text");
        _email = text;
      },
      decoration: InputDecoration(
          fillColor: Colors.white.withOpacity(0.9),
          filled: true,
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final passwordField = TextField(
      obscureText: true,
      style: style,
      onChanged: (text) {
        print("First text field: $text");
        _password = text;
      },
      decoration: InputDecoration(
          fillColor: Colors.white.withOpacity(0.9),
          filled: true,
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final signupButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: onSignupPressed,
        child: Text("Signup",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final alreadyHaveAccountText = Text('Already Have an Account?',
        style: new TextStyle(fontSize: 15, color: Colors.white));
    final alreadyHaveAccountButton = Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.white.withOpacity(0),
      child: MaterialButton(
        //minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: gotoLogin,
        child: Text('login',
            style: new TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ),
    );

    final paddingA = Padding(padding: EdgeInsets.only(top: 25.0));

    return new WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "images/treeLogin.jpg",
                ),
                fit: BoxFit.cover,
              ),
            ),
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'images/logo.png',
                  height: 100,
                  width: 100,
                ),
                new Text(
                  'Welcome to Acacia',
                  style: new TextStyle(fontSize: 30.0, color: Colors.white),
                ),
                new Text('Create an Account:',
                    style: new TextStyle(fontSize: 20, color: Colors.white)),
                paddingA,
                emailField,
                paddingA,
                passwordField,
                paddingA,
                signupButton,
                paddingA,
                paddingA,
                alreadyHaveAccountText,
                alreadyHaveAccountButton,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
