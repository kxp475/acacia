import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'profile_settings.dart';
import 'readLocalProfileData.dart';
import 'login_page.dart';
import 'signin_page.dart';
import 'add_page.dart';

void main() => runApp(MyApp());

String userEmail = "";
  List<String> litems = ["Water","Sleep","Exercise"];


final FirebaseAuth _auth = FirebaseAuth.instance;

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
        primarySwatch: Colors.cyan,
      ),
      home: signinPage(),
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
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  int _counter = 0;
  String _title = "Acacia";

  void _incrementCounter() {
    setState(() {
      _title = "Acacia";
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

  void onProfileSettingsButtonPressed(){
    print("You've pressed the Profile Settings Button!");
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => profile_settingsPage()),
    );
  }

  void onAddPageButtonPressed(){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => add_Page()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    final profileSettingsButton = Material(
            borderRadius: BorderRadius.circular(30.0),
            color: Colors.cyan,
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              onPressed: onProfileSettingsButtonPressed,
              child: Text("Profile Settings",
                  textAlign: TextAlign.center,
                  style: style.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
      );

Future<void> _undoRemovePrompt(int index,var item) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Are you sure you want to delete $item page?'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('You will have to create another page to track $item again.'),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Undo Deletion'),
            onPressed: () {
              Navigator.of(context).pop();
               setState(() {
                litems.insert(index, item);
               });
            },
          ),
          FlatButton(
            child: Text('Confirm Deletion'),
            onPressed: () {
              Navigator.of(context).pop();
               
            },
          ),
        ],
      );
    },
  );
}

  void addPage(){
    print("Add a page");
  }

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('$_title',style: Theme.of(context).textTheme.display1.copyWith(color: Colors.white)),
        actions: [GestureDetector(
                    onTap: (){

                        onAddPageButtonPressed();
                    },
                    child: Container(
                         padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Icon(Icons.add, size: 30.0, color: Colors.white),
                      ),
                  ),
                  GestureDetector(
                    onTap: (){

                        onProfileSettingsButtonPressed();
                    },
                    child: Container(
                         padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Icon(Icons.settings, color: Colors.white),
                      ),
                  )],
        automaticallyImplyLeading: false,

      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Container(
        decoration: BoxDecoration(
                      image: DecorationImage(
                      image: AssetImage("images/treeLogin.jpg",),
                      fit: BoxFit.cover,
                  ),
                  ),
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[
           
            new Expanded(
            child: new ListView.builder
              (
                itemCount: litems.length,
                itemBuilder: (BuildContext ctxt, int Index) {
                  //final item = litems[Index];

                  return Dismissible(
                      key: Key(litems[Index]),
                      onDismissed: (direction) {
                        var item = litems.elementAt(Index);
                        setState(() {
                          litems.removeAt(Index);
                        });
                        _undoRemovePrompt(Index,item);
                      // Then show a snackbar.
                       
                      },
                    child: Container(
                        padding: const EdgeInsets.only(top: 20.0,left: 30.0,right: 30.0),
                        child: Card(
                          elevation: 1,
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(vertical: 100.0,horizontal: 10.0) ,
                            leading: FlutterLogo(),
                            trailing: Icon( Icons.settings),
                            title: Text(litems[Index]),
                          ),
                        ),
                    ),
                  );

                }
              )
            ),

            //profileSettingsButton,

          ],
        ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: addPage,
        tooltip: 'Increment',
        icon: Icon(Icons.mode_edit,color: Colors.white),
        label: Text("Log",style: new TextStyle(fontSize:20,color : Colors.white)),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
