import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'readLocalProfileData.dart';
import 'main.dart';
import 'signin_page.dart';


String username = "";

class notebook_Page extends StatefulWidget{

     static const routeName = '/notebook_Page';

	@override
	State<StatefulWidget> createState() => notebook_PageState();
}

class notebook_PageState extends State<notebook_Page>{
	final FirebaseAuth _auth = FirebaseAuth.instance;

    static const routeName = '/notebook_Page';

	final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

	@override
  	void initState() {
      
   

	    
    

  	}


	@override
	Widget build(BuildContext context){

		final notebookArgs args = ModalRoute.of(context).settings.arguments;
		print("Here's the data passed from the main menu:");
		print(args.name);
		print(args.info);
		

      	final paddingA = Padding(padding: EdgeInsets.only(top: 25.0));


		return Scaffold(
			appBar: AppBar(
        		// Here we take the value from the MyHomePage object that was created by
        		// the App.build method, and use it to set our appbar title.
        		title: Text('${args.name}', style: new TextStyle(color : Colors.white)),
      		),
			body: Center(
				child: Container(
					decoration: BoxDecoration(
                  		image: DecorationImage(
                    		image: AssetImage("images/treeLogin.jpg",),
                    		fit: BoxFit.cover,
                  		),
              		),
				),
			),
		);
	}
}