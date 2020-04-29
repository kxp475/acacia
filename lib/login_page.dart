import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'readLocalProfileData.dart';
import 'main.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class loginPage extends StatefulWidget {
  loginPage() : super(key: key);

  @override
  loginPageState createState() => loginPageState();
}

class loginPageState extends State<loginPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  String _email = "";
  String _password = "";

  void onLoginPressed() {
    print('The user wants to login with $_email and $_password');
    _signInWithEmailAndPassword();
  }

  void gotoSignup() {
    Navigator.pop(context);
  }

  void _signInWithEmailAndPassword() async {
    final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
      email: _email,
      password: _password,
    ))
        .user;
    if (user != null) {
      setState(() {
        print("loginSuccess!!!!!");
        writeUsername(_email);
        writePassword(_password);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
      });
    } else {
      setState(() {
        print("Login Failed.");
      });
    }
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
    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: onLoginPressed,
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final alreadyHaveAccountText = Text("Don't have an account?",
        style: new TextStyle(fontSize: 15, color: Colors.white));
    final alreadyHaveAccountButton = Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.white.withOpacity(0),
      child: MaterialButton(
        //minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: gotoSignup,
        child: Text('Signup',
            style: new TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ),
    );

    final paddingA = Padding(padding: EdgeInsets.only(top: 25.0));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "images/mountains.jpg",
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
                'Welcome Back!',
                style: new TextStyle(fontSize: 30.0, color: Colors.black),
              ),
              new Text('Login to your account:',
                  style: new TextStyle(fontSize: 20, color: Colors.black)),
              paddingA,
              emailField,
              paddingA,
              passwordField,
              paddingA,
              loginButton,
              paddingA,
              paddingA,
              alreadyHaveAccountText,
              alreadyHaveAccountButton,
            ],
          ),
        ),
      ),
    );
  }
}
