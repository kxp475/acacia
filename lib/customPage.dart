import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'readLocalProfileData.dart';
import 'main.dart';
import 'signin_page.dart';
import 'add_page.dart';
import 'package:loading_overlay/loading_overlay.dart';

String username = "";


class custom_Page extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => custom_PageState();
}

enum pageType { Water, Sleep, Exercise, Custom }

extension on pageType {
  String toShortString() {
    return this.toString().split('.').last;
  }
}

class custom_PageState extends State<custom_Page> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  bool visible = false;
  var name = "";
  TextEditingController _controller;

  @override
  void initState() {
     _controller = TextEditingController();

  }

  Future<void> alert_CannotDuplicatePages() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              'You alread have a ${name} Notebook'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Select a different name'),
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
      if (i == '$name') {
        setState(() {
          visible = false;
        });
        alert_CannotDuplicatePages();
        return;
      }
    }

    await user.initiateNoteBook("$name");
    await user.getNoteBookList();


    setState(() {
      visible = false;
      //litems.insert(0,'${selectedType.toString().split('.').last}');
    });
    Navigator.push(
      context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
    );
  }


  @override
  Widget build(BuildContext context) {
    final paddingA = Padding(padding: EdgeInsets.only(top: 25.0));

    final createButton = Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.cyan,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: onCreateButtonPressed,
        child: Text("Add Notebook",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset : true,

      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Custom Notebook', style: new TextStyle(color: Colors.white)),
      ),
      body: Container(
        child: GestureDetector( 
          behavior : HitTestBehavior.translucent,
          onTap: () {
            print("tapped!");
            FocusScope.of(context).requestFocus(new FocusNode());
          },
        child:Container(
          child: LoadingOverlay(
            child: Container(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: <Widget>[


                  Card(
                  elevation: 3.0,
                    child: Container(
                      padding: const EdgeInsets.all(30.0),

                      child: Column(

                            children: <Widget>[
                              
                              Text('Create a notebook to track whatever you want.',
                              style: new TextStyle(fontSize: 20, color: Colors.black)),
                              paddingA,

                              new TextField(
                                controller: _controller,
                                textAlign: TextAlign.center,
                                style: new TextStyle(fontSize: 20.0,color: Colors.black),
                                decoration: new InputDecoration(labelText: "Enter notebook name",filled: true,

                                fillColor: Colors.white,),
                                //keyboardType: TextInputType.number,
                                onChanged: (text) {
                                  name = text;
                                  if(text != ""){
                                    setState((){
                                      //isSubmitDataButtonVisible = true;
                                    });
                                  }else{
                                    setState((){
                                     // isSubmitDataButtonVisible = false;
                                    });
                                  }
                                print("First text field: $text");
                              },),
                              paddingA,
                            ],
                        ),
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
        ),
      ),
      ),
    );
  }
}
