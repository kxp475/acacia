import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'readLocalProfileData.dart';
import 'main.dart';
import 'signin_page.dart';
import 'package:loading_overlay/loading_overlay.dart';

String username = "";

class add_Page extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => add_PageState();
}

enum pageType { Water, Sleep, Exercise, Custom }

extension on pageType {
  String toShortString() {
    return this.toString().split('.').last;
  }
}

class add_PageState extends State<add_Page> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  bool visible = false;

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
          username = lUsername;
        });
      });
    });
  }

  pageType selectedType = pageType.Water;

  Future<void> alert_CannotDuplicatePages() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              'You alread have a ${selectedType.toString().split('.').last} Notebook'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Select a different type'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void onCreateButtonPressed() async {
    visible = true;
    setState(() {});

    for (final i in user.noteBookList) {
      print('$i');
      if (i == '${selectedType.toString().split('.').last}') {
        setState(() {
          visible = false;
        });
        alert_CannotDuplicatePages();
        return;
      }
    }
    await user.initiateNoteBook("${selectedType.toString().split('.').last}");
    await user.getNoteBookList();

    setState(() {
      visible = false;
      //litems.insert(0,'${selectedType.toString().split('.').last}');
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final paddingA = Padding(padding: EdgeInsets.only(top: 25.0));

    final createButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.cyan,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: onCreateButtonPressed,
        child: Text("Add ${selectedType.toString().split('.').last} Notebook",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Add Notebook', style: new TextStyle(color: Colors.white)),
      ),
      body: LoadingOverlay(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: <Widget>[
              paddingA,
              paddingA,
              Text('What do you want to track?',
                  style: new TextStyle(fontSize: 20, color: Colors.black)),
              ListTile(
                title: const Text('Water Intake'),
                leading: Radio(
                  value: pageType.Water,
                  groupValue: selectedType,
                  onChanged: (pageType value) {
                    setState(() {
                      selectedType = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Exercise'),
                leading: Radio(
                  value: pageType.Exercise,
                  groupValue: selectedType,
                  onChanged: (pageType value) {
                    setState(() {
                      selectedType = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Sleep'),
                leading: Radio(
                  value: pageType.Sleep,
                  groupValue: selectedType,
                  onChanged: (pageType value) {
                    setState(() {
                      selectedType = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Custom'),
                leading: Radio(
                  value: pageType.Custom,
                  groupValue: selectedType,
                  onChanged: (pageType value) {
                    setState(() {
                      selectedType = value;
                    });
                  },
                ),
              ),
              paddingA,
              createButton,
            ],
          ),
        ),

        isLoading: visible,
        // demo of some additional parameters
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(),
      ),
    );
  }
}
