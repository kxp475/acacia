import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';


void main() => runApp(MyApp());

final FirebaseAuth _auth = FirebaseAuth.instance;


  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    print(directory.path);
    return directory.path;
  }

  Future<File> get _localUsernameFile async {
    final path = await _localPath;
    return File('$path/username.txt');
  }


  Future<File> get _localPasswordFile async {
    final path = await _localPath;
    return File('$path/password.txt');
  }

  Future<String> readUsername(String name) async {
    try {
     
          final file = await _localUsernameFile;
     
     
      
      // Read the file
      String contents = await file.readAsString();
      // Returning the contents of the file
      return contents;
    } catch (e) {
      // If encountering an error, return
      return 'Error!';
    }
  }

  Future<String> readPassword(String name) async {
    try {
     
          final file = await _localPasswordFile;
     
      
      // Read the file
      String contents = await file.readAsString();
      // Returning the contents of the file
      return contents;
    } catch (e) {
      // If encountering an error, return
      return 'Error!';
    }
  }

  Future<File> writeUsername(String username) async {
    print("writing some content");
    final file1 = await _localUsernameFile;
    // Write the file
    return file1.writeAsString(username);
  }

    Future<File> writePassword(String password) async {
    print("writing some content");
    final file1 = await _localPasswordFile;
    // Write the file
    return file1.writeAsString(password);
  }



class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
      ),
      home: signinPage(),
    );
  }
}


class loginPage extends StatefulWidget{
  loginPage() : super(key:key);

  @override
  loginPageState createState() => loginPageState();
}

class loginPageState extends State<loginPage>{
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  String _email = "";
  String _password = "";

  void onLoginPressed(){
    print('The user wants to login with $_email and $_password');
    _signInWithEmailAndPassword();
  }

  void gotoSignup(){
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
      setState((){
        print("Login Failed.");

      });
    }
  }


  @override
  Widget build(BuildContext context){

    final emailField = TextField(
          obscureText: false,
          style: style,
          onChanged: (text) {
            print("First text field: $text");
            _email = text;
          },
          decoration: InputDecoration(
              fillColor: Colors.white.withOpacity(0.9), filled: true,
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
          fillColor: Colors.white.withOpacity(0.9), filled: true,
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

    final alreadyHaveAccountText =  Text("Don't have an account?", style: new TextStyle(fontSize:15,color : Colors.white));
    final alreadyHaveAccountButton = Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.white.withOpacity(0),
      child: MaterialButton(
        //minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: gotoSignup,
        child: Text('Signup', style: new TextStyle(fontSize:20,fontWeight: FontWeight.bold,color : Colors.white)),
      ),
    );


    final paddingA = Padding(padding: EdgeInsets.only(top: 25.0));

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Container(

                  decoration: BoxDecoration(
                      image: DecorationImage(
                      image: AssetImage("images/mountains.jpg",),
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
                       new Text('Welcome Back!',
                       style: new TextStyle(fontSize: 30.0,color : Colors.black),),

                       new Text('Login to your account:', style: new TextStyle(fontSize:20,color : Colors.black)),
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


class signinPage extends StatefulWidget {
  signinPage() : super(key:key);

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

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
      
      });
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

        writeUsername(_email);
        writePassword(_password);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
      
      });
    } else {
      print("signup failed!");
    }
  }


  void onSignupPressed(){
   

   
    

    print('The user wants to login with $_email and $_password');
    _register();
  }

  void gotoLogin(){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => loginPage()),
      );
  }

  @override
  void initState() {
      
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
          _signingWithLocalInfo(lUsername,lPassword);
      });

    });

  }


  @override
  Widget build(BuildContext context){



    final emailField = TextField(
          obscureText: false,
          style: style,
          onChanged: (text) {
            print("First text field: $text");
            _email = text;
          },
          decoration: InputDecoration(
              fillColor: Colors.white.withOpacity(0.9), filled: true,
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
          fillColor: Colors.white.withOpacity(0.9), filled: true,
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

    final alreadyHaveAccountText =  Text('Already Have an Account?', style: new TextStyle(fontSize:15,color : Colors.white));
    final alreadyHaveAccountButton = Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.white.withOpacity(0),
      child: MaterialButton(
        //minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: gotoLogin,
        child: Text('login', style: new TextStyle(fontSize:20,fontWeight: FontWeight.bold,color : Colors.white)),
      ),
    );


    final paddingA = Padding(padding: EdgeInsets.only(top: 25.0));

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                      image: AssetImage("images/treeLogin.jpg",),
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
                       new Text('Welcome to Acacia',
                       style: new TextStyle(fontSize: 30.0,color : Colors.white),),

                       new Text('Create an Account:', style: new TextStyle(fontSize:20,color : Colors.white)),
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

    );
  }
}



class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _title = "Acacia!";

  void _incrementCounter() {
    setState(() {
      _title = "Acacia! Changed";
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => signinPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('$_title'),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to Acacia!',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
