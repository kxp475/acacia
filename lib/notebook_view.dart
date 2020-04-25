import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'readLocalProfileData.dart';
import 'main.dart';
import 'signin_page.dart';
import 'package:table_calendar/table_calendar.dart';

String username = "";

class notebook_Page extends StatefulWidget {
  static const routeName = '/notebook_Page';

  @override
  State<StatefulWidget> createState() => notebook_PageState();
}

class notebook_PageState extends State<notebook_Page> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const routeName = '/notebook_Page';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    final notebookArgs args = ModalRoute.of(context).settings.arguments;
    print("Here's the data passed from the main menu:");
    print(args.name);
    print(args.info);

    final paddingA = Padding(padding: EdgeInsets.only(top: 20.0));

    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
        body: TabBarView(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  paddingA,
                  Text("  This Month's",
                      textAlign: TextAlign.left,
                      style: new TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.normal,
                          color: Colors.black)),
                  Text("  ${args.name}",
                      textAlign: TextAlign.left,
                      style: new TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
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
                      children: List.generate(30, (index) {
                        return Card(
                          elevation: 2,
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 0.0),
                            onTap: () {
                              setState(() {
                                //_id = Index; //if you want to assign the index somewhere to check
                                //print(_id);
                              });
                            },

                            //title: Text('${index+1}\n 2M\n '),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(" Add Data",
                      textAlign: TextAlign.left,
                      style: new TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(" Insights",
                      textAlign: TextAlign.left,
                      style: new TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
