import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'profile_settings.dart';
import 'readLocalProfileData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'userData.dart';
import 'login_page.dart';
import 'signin_page.dart';
import 'add_page.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'root_page.dart';
import 'notebook_view.dart';

void main() => runApp(MyApp());

String username = "";
List<String> litems = ["Water", "Sleep", "Exercise"];

final databaseReference = Firestore.instance;

userData user = userData("init");

Future<void> createRecord() async {
  //user.fetchUserData();
  ///user.setData();
  //user.initiateNoteBook("Water");
  //user.getNoteBookList();

  //user.createDocumentforUser();
  // user.deleteNoteBook("Water");
  //List notebooks = await user.getNoteBookList();
  //print("List of notebooks:");
  //notebooks.forEach((notebooks) => print(notebooks));
  //user.createNotebookArray("Water");
  Map data = await user.getNoteBookContentMonth("Exercise", 2020, 1);
  //user.updateNotebookData("Exercise",2020,1,1,60);
  print(data);
}

class notebookArgs {
  final String name;
  final String info;

  notebookArgs(this.name, this.info);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      routes: {
        notebook_Page.routeName: (context) => notebook_Page(),
      },
      home: root_Page(), //signinPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  int _counter = 0;
  String _title = "Acacia";
  bool visible = true;
  bool hasLoaded = false;
  int _id;

  void loadNoteBook() async {
    if (hasLoaded == false) {
      print("loading NoteBooks!!!");
      await user.getNoteBookList();
      visible = false;
      setState(() {});
      hasLoaded = true;
    }
  }

  @override
  void initState() {
    if (user == null) {
      user = userData("init");
    }
    ;

    Future.delayed(const Duration(milliseconds: 10), () {
      String lUsername;
      String lPassword;

      readUsername("username").then((String value) {
        setState(() {
          lUsername = value;

          //INSTANTIATE USER OBJECT. THIS OBJECT WILL HOLD ALL USER DATA **************
          user.setUsername(lUsername);
          print(user.getUsername());
        });
        readPassword("password").then((String value) {
          setState(() {
            lPassword = value;
          });
          print("THE LOADED USERNAME IS $lUsername , PASSWORD IS $lPassword");
          username = lUsername;
        });
      });
    });

    Future.delayed(const Duration(milliseconds: 5000), () {
      setState(() {});
    });
  }

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

  void onProfileSettingsButtonPressed() {
    print("You've pressed the Profile Settings Button!");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => profile_settingsPage()),
    );
  }

  void onAddPageButtonPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => add_Page()),
    );
  }

  void handleNoteBookTap() {
    print("Touched the Notebook");
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    loadNoteBook();

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

    //loadNoteBook();

    Future<void> _undoRemovePrompt(int index, var item) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure you want to delete $item page?'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                      'You will have to create another page to track $item again.'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Undo Deletion'),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    //litems.insert(index, item);
                    user.noteBookList.insert(index, item);
                  });
                },
              ),
              FlatButton(
                child: Text('Confirm Deletion'),
                onPressed: () async {
                  visible = true;
                  setState(() {});

                  await user.deleteNoteBook(item);
                  await user.getNoteBookList();

                  setState(() {
                    visible = false;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    void addPage() {
      print("Add a page");
      createRecord();
    }

    return new WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text('$_title',
              style: Theme.of(context)
                  .textTheme
                  .display1
                  .copyWith(color: Colors.white)),
          actions: [
            GestureDetector(
              onTap: () {
                onAddPageButtonPressed();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Icon(Icons.add, size: 30.0, color: Colors.white),
              ),
            ),
            GestureDetector(
              onTap: () {
                onProfileSettingsButtonPressed();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Icon(Icons.settings, color: Colors.white),
              ),
            )
          ],
          automaticallyImplyLeading: false,
        ),
        body: LoadingOverlay(
          child: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "images/treeBlurred.jpg",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Expanded(
                      child: new ListView.builder(
                          itemCount: user.noteBookList.length,
                          itemBuilder: (BuildContext ctxt, int Index) {
                            //final item = litems[Index];
                            return Dismissible(
                              key: Key(user.noteBookList[Index]),
                              onDismissed: (direction) {
                                var item = user.noteBookList.elementAt(Index);
                                setState(() {
                                  user.noteBookList.remove(item);
                                });
                                _undoRemovePrompt(Index, item);
                                // Then show a snackbar.
                              },
                              child: Container(
                                padding: const EdgeInsets.only(
                                    top: 20.0, left: 30.0, right: 30.0),
                                child: Card(
                                  elevation: 1,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 100.0, horizontal: 10.0),
                                    onTap: () {
                                      setState(() {
                                        _id =
                                            Index; //if you want to assign the index somewhere to check
                                        print(_id);
                                        print(user.noteBookList.elementAt(_id));
                                        Navigator.pushNamed(
                                          context,
                                          notebook_Page.routeName,
                                          arguments: notebookArgs(
                                            user.noteBookList.elementAt(_id),
                                            'This is some more info',
                                          ),
                                        );
                                      });
                                    },
                                    leading: FlutterLogo(),
                                    //trailing: Icon( Icons.settings),
                                    title: Text(user.noteBookList[Index],
                                        style: new TextStyle(fontSize: 20)),
                                  ),
                                ),
                              ),
                            );
                          })),
                ],
              ),
            ),
          ),
          isLoading: visible,
          opacity: 0.1,
          progressIndicator: CircularProgressIndicator(),
        ),

        floatingActionButton: FloatingActionButton.extended(
          onPressed: addPage,
          tooltip: 'Increment',
          icon: Icon(Icons.mode_edit, color: Colors.white),
          label: Text("Log",
              style: new TextStyle(fontSize: 20, color: Colors.white)),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
