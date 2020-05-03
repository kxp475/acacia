import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'readLocalProfileData.dart';
import 'main.dart';
import 'signin_page.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'dart:math';

String username = "";

class log_Page extends StatefulWidget {
  static const routeName = '/log_Page';

  @override
  State<StatefulWidget> createState() => log_PageState();
}

class log_PageState extends State<log_Page> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  static const routeName = '/log_Page';
  var visible = false;

  Map notebookDailyValue = {};

  void onSignOutButton() {
    writeUsername("");
    writePassword("");
    user = null;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => signinPage()),
    );
  }

  void onSubmitDailyDataButtomPressed() async{
    var today = new DateTime.now();

    for (var k in notebookDailyValue.keys) {
      if('${notebookDailyValue[k]}' == null || '${notebookDailyValue[k]}' == ''){

      }else{
        await user.updateNotebookData("$k",today.year,today.month,today.day,'${notebookDailyValue[k]}');
      }
    }

    setState((){
          visible = false;
    });

    Navigator.of(context).pop();
  }

  String getBackGroundImageFile(){
    List bgFiles = ["images/exerciseCentered.jpg","images/sky.jpg","images/water.jpg"];
    return "images/exerciseCentered.jpg";//bgFiles.elementAt(new Random().nextInt(bgFiles.length));
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
          username = lUsername;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final logArgs args = ModalRoute.of(context).settings.arguments;
    print("Here's the list of notebooks!");
    print(args.notebooks);

    final paddingA = Padding(padding: EdgeInsets.only(top: 25.0));

    return Scaffold(
      resizeToAvoidBottomInset: false,

      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title:
            Text('Log Data for ${DateTime.now().month}/${DateTime.now().day}', style: new TextStyle(color: Colors.white)),
      ),
      body: GestureDetector( 
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child:LoadingOverlay(
          child: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    getBackGroundImageFile(),//"images/exerciseCentered.jpg",
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
                          itemCount: args.notebooks.length,
                          itemBuilder: (BuildContext ctxt, int Index) {
                            //final item = litems[Index];
                            return 
                              Container(
                                padding: const EdgeInsets.only(
                                    top: 20.0, left: 30.0, right: 30.0),
                                child: Card(
                                  elevation: 1,
                                  child: 
                                    new TextField(
                                        //controller: _controller,
                                        textAlign: TextAlign.center,
                                        style: new TextStyle(fontSize: 20.0,color: Colors.black),
                                        decoration: new InputDecoration(labelText: "Enter ${args.notebooks.elementAt(Index)} Data",filled: true,

                                    fillColor: Colors.white,),
                                        keyboardType: TextInputType.number,
                                        onChanged: (text) {
                                          notebookDailyValue['${args.notebooks.elementAt(Index)}'] = text;
                                        },),
                                ),
                              );
                           
                    })),
                    Container(
                        padding: const EdgeInsets.only(
                        top: 20.0, left: 30.0, right: 30.0),
                        child: Material(
                              borderRadius: BorderRadius.circular(30.0),
                              color: Colors.cyan,
                              child: Center(
                                  child: MaterialButton(
                                    minWidth: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
                                    onPressed: ((){
                                      FocusScope.of(context).requestFocus(new FocusNode());
                                      setState((){
                                        visible = true;
                                      });
                                      onSubmitDailyDataButtomPressed();
                                    }),
                                    child: Text("Save Data for ${DateTime.now().month}/${DateTime.now().day}",
                                        textAlign: TextAlign.center,
                                        style: style.copyWith(
                                            color: Colors.white, fontWeight: FontWeight.normal)),
                                  ),
                              ),
                          ),
                      ),
                      paddingA,
                      paddingA,
                      paddingA,
                      paddingA,

                ],
              ),
            ),
          ),
          isLoading: visible,
          opacity: 0.1,
          progressIndicator: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
