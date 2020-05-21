import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'readLocalProfileData.dart';
import 'main.dart';
import 'signin_page.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:loading_overlay/loading_overlay.dart';

import 'barGraph.dart';                                                                                                                 
import 'barGraphPage.dart';

String username = "";

class notebook_Page extends StatefulWidget {
  static const routeName = '/notebook_Page';

  @override
  State<StatefulWidget> createState() => notebook_PageState();
}

class notebook_PageState extends State<notebook_Page> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const routeName = '/notebook_Page';

  final noteBookUnitType = {'Water':'glasses','Sleep':'hours','Exercise':'minutes','Custom':''};
  final noteBookUnitePhrase = {'Water':'Number of Glasses Drank','Sleep':'Hours You Slept','Exercise':'Minutes You Exercised','Custom':"Custom Data"};



  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController _controller;
  bool isSubmitDataButtonVisible = false;
  bool hasLoaded = false;
  var today;
  var _isLoading = false;
  var daysInThisMonth = 30;
  var nameOfMonth = "";
  var monthOffset = 0;
  var updateValue = "0";
  int goal;

  Map noteBookMonthData = {};

  String inputData;
  String notebookName;

  @override
  void initState() {
     _controller = TextEditingController();
  }

  void loadMonthNotebookData() async{

    Map monthLength = {1:31,2:29,3:31,4:30,5:31,6:30,7:31,8:31,9:30,10:31,11:30,12:31};
    Map monthNames = {1: "January",2:"February",3:"March",4:"April",5:"May",6:"June",7:"July",8:"August",9:"September",10:"October",11:"November",12:"December"};
    if(hasLoaded == false){
      setState((){
        _isLoading = true;
      });
      var today = new DateTime.now();
      int month = today.month + monthOffset;

      daysInThisMonth = monthLength[month];
      nameOfMonth = monthNames[month];


      noteBookMonthData = await user.getNoteBookContentMonth(notebookName,today.year,month);

      goal = await user.getGoal(notebookName);
      print(noteBookMonthData);
      setState((){});
      hasLoaded = true;
      _isLoading = false;
    }
  }

  String getDayData(int index){
    String data = noteBookMonthData["${index+1}"];
    if(data == null){
      data = "";
    }
    return data;

  }



  void changeMonthView(int change){

    monthOffset = monthOffset + change;

    var today = new DateTime.now();
    int month = today.month + monthOffset;

    if(month == 0){
      monthOffset++;
      return;
    }
    if(month == 13){
      monthOffset--;
      return;
    }

    hasLoaded = false;

    print("changing month!");
    loadMonthNotebookData();
  }

  Color getCardColor(String name, String value){

      int g = goal ?? 0;

      if(value == ""){
        return Colors.white;
      }
      if(int.parse(value) >= g){
         return Colors.green;
      }else{
        return Colors.red;
      }

    return Colors.white;
  }

  String getNoteBookBackGroundImageFile(){
    Map bgFiles = {"Exercise" : "images/exerciseCentered.jpg","Sleep" : "images/sky.jpg","Water" : "images/water.jpg","Custom" : "images/treeLogin.jpg"};
    if(bgFiles[notebookName] == null){
      return bgFiles["Custom"];
    }
    return bgFiles[notebookName];
  }

  String getNoteBookPhrase(){
    if(noteBookUnitePhrase[notebookName] == null){
      return notebookName;
    }
    return noteBookUnitePhrase[notebookName];
  }

  int getGoal(){
    if(goal == null){
      return 0;
    }
    return goal;
  }

  void onSubmitDataButtomPressed()async{
       //inputData = "Test";
       int defaultValue = -3;
       int data =  int.tryParse(inputData) ?? defaultValue;

       if(data == defaultValue){
             showDialog<void>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                      'You must input a number'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text('Please try again'),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState((){
                          _isLoading = false;
                          hasLoaded = false;
                        });
                      },
                    ),
                  ],
                );
              },
            );
       }else{

        var today = new DateTime.now();

        await user.updateNotebookData("$notebookName",today.year,today.month,today.day,'$data');

        setState((){
          _isLoading = false;
          hasLoaded = false;
        });

       }  
  }

  void onEditDaySubmit(int day,String updatedData)async{
       //inputData = "Test";
       int defaultValue = -3;
       int data =  int.tryParse(updatedData) ?? defaultValue;

        var today = new DateTime.now();

        await user.updateNotebookData("$notebookName",today.year,today.month + monthOffset,day,'$data');

        setState((){
          _isLoading = false;
          hasLoaded = false;
        });

       
  }

  void onEditGoalSubmit(String updatedData)async{
       //inputData = "Test";
       int defaultValue = 0;
       int data =  int.tryParse(updatedData) ?? defaultValue;


        await user.updateGoal("$notebookName",data);

        setState((){
          _isLoading = false;
          hasLoaded = false;
        });

       
  }

  displayEditDayDialog(BuildContext context,int day) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Edit Data for ${nameOfMonth}-${day+1}'),
            content: TextField(
              keyboardType: TextInputType.number,
              //controller: _textFieldController,
                onChanged: (text) {
                  updateValue = text;
                  
                },
              
              decoration: InputDecoration(hintText: "Enter Data"),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('SUBMIT'),
                onPressed: () {
                  onEditDaySubmit(day+1,"$updateValue");
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  displayEditGoalDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Edit Daily Goal for $notebookName'),
            content: TextField(
              keyboardType: TextInputType.number,
              //controller: _textFieldController,
                onChanged: (text) {
                  updateValue = text;
                  
                },
              
              decoration: InputDecoration(hintText: "Enter Goal : ${noteBookUnitType[notebookName]}"),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('SUBMIT'),
                onPressed: () {
                  onEditGoalSubmit("$updateValue");
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    final notebookArgs args = ModalRoute.of(context).settings.arguments;
    print("Here's the data passed from the main menu:");
    print(args.name);
    print(args.info);
    notebookName = args.name;

    today = new DateTime.now();

    loadMonthNotebookData();

    final paddingA = Padding(padding: EdgeInsets.only(top: 20.0));

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        resizeToAvoidBottomInset: false,

        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title:
              Text('${args.name}', style: new TextStyle(color: Colors.white)),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.calendar_today)),
              Tab(icon: Icon(Icons.edit)),
              Tab(icon: Icon(Icons.wb_sunny)),
            ],
          ),
        ),
        body: GestureDetector( 
          onTap: () {
            print("tapped!");
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: LoadingOverlay( 
          child: TabBarView(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "images/grey.jpg",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  paddingA,
                  Row(
                    children: <Widget>[
                       IconButton(
                          icon: Icon(Icons.arrow_left),
                          onPressed: () {
                              changeMonthView(-1);
                          },
                       ),
                       Expanded(
                        child: Column( 
                          children: <Widget>[ 
                              Text("${nameOfMonth}",
                                  textAlign: TextAlign.left,
                                  style: new TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black)),
                              Text("${args.name}",
                                  textAlign: TextAlign.left,
                                  style: new TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),                             
                              ]),

                            ),
                       IconButton(
                          icon: Icon(Icons.arrow_right),
                          onPressed: () {
                              changeMonthView(1);
                          },
                       ),
                    ],
                  ),
        
                  paddingA,
                  new Expanded(
                    child: GridView.count(
                      primary: false,

                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      // Create a grid with 2 columns. If you change the scrollDirection to
                      // horizontal, this produces 2 rows.
                      crossAxisCount: 7,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0,
                      childAspectRatio: .5,
                      // Generate 100 widgets that display their index in the List.
                      children: List.generate(daysInThisMonth, (index) {
                        return Card(
                          elevation: 1,
                          color: getCardColor(notebookName,'${getDayData(index)}'),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 0.0),
                            onTap: () {
                              print("Touched a day!");
                              displayEditDayDialog(context,index);
                              setState(() {
                                //_id = Index; //if you want to assign the index somewhere to check
                                //print(_id);
                              });
                            },

                            title: Text(' ${index+1}', style: new TextStyle(fontSize: 10,color: Colors.black)),
                            subtitle: Text(
                               '${getDayData(index)}',
                                textAlign: TextAlign.center,
                                style: new TextStyle(fontSize: 25,color: Colors.black)
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    '${getNoteBookBackGroundImageFile()}',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Enter Today's Data For:",
                      textAlign: TextAlign.left,
                      style: new TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  Text("${getNoteBookPhrase()}",
                      textAlign: TextAlign.left,
                      style: new TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.normal,
                          color: Colors.white)),
                  paddingA,
                  new TextField(
                      controller: _controller,
                      textAlign: TextAlign.center,
                      style: new TextStyle(fontSize: 20.0,color: Colors.black),
                      decoration: new InputDecoration(labelText: "Enter Data for ${today.month}/${today.day}",filled: true,

                    fillColor: Colors.white,),
                      keyboardType: TextInputType.number,
                      onChanged: (text) {
                        inputData = text;
                        if(text != ""){
                          setState((){
                            isSubmitDataButtonVisible = true;
                          });
                        }else{
                          setState((){
                            isSubmitDataButtonVisible = false;
                          });
                        }
                        print("First text field: $text");
                  },),
                  paddingA,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Daily goal: \n ${getGoal()} ${noteBookUnitType[notebookName] ?? ""} ",
                      textAlign: TextAlign.left,
                      style: new TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.normal,
                          color: Colors.white)),
                      
                      GestureDetector(
                        onTap: () {
                          displayEditGoalDialog(context);
                          print("Edit Goal Button Pressed");
                        },
                        child: Icon(Icons.mode_edit, color: Colors.white),
                      ),

                    ],

                  ),
                  /* Text("Your daily goal is: 5 ${noteBookUnitType[notebookName]} ",
                      textAlign: TextAlign.left,
                      style: new TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.normal,
                          color: Colors.white)), */
                  paddingA,
                  Visibility(
                      visible: isSubmitDataButtonVisible,
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
                                    _isLoading = true;
                                  });
                                  onSubmitDataButtomPressed();
                                }),
                                child: Text("Save Data",
                                    textAlign: TextAlign.center,
                                    style: style.copyWith(
                                        color: Colors.white, fontWeight: FontWeight.normal)),
                              ),
                          ),
                      ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(30.0),
      	      child: PageView(
      			      children: <Widget>[BarChartPage()],
      	      ),

            ),
          ],

          ),
        isLoading: _isLoading,
        // demo of some additional parameters
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(),
        ),
        ),
      ),
    );
  }
}
