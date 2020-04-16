import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'readLocalProfileData.dart';
import 'main.dart';
import 'signin_page.dart';


String username = "";

class profile_settingsPage extends StatefulWidget{

	@override
	State<StatefulWidget> createState() => profile_settingsPageState();
}

class profile_settingsPageState extends State<profile_settingsPage>{

	final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

	void onSignOutButton(){
		writeUsername("");
        writePassword("");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => signinPage()),
        );
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
	Widget build(BuildContext context){

		final signoutButton = Material(
            
            borderRadius: BorderRadius.circular(30.0),
            color: Colors.red,
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              onPressed: onSignOutButton,
              child: Text("Signout",
                  textAlign: TextAlign.center,
                  style: style.copyWith(
                      color: Colors.white, fontWeight: FontWeight.normal)),
            ),
      	);

      	final paddingA = Padding(padding: EdgeInsets.only(top: 25.0));


		return Scaffold(
			 appBar: AppBar(
        		// Here we take the value from the MyHomePage object that was created by
        		// the App.build method, and use it to set our appbar title.
        		title: Text('Profile Settings', style: new TextStyle(color : Colors.white)),
      		),
			body: Center(
				child: Container(
					padding: const EdgeInsets.all(30.0),
					child:Column(
						mainAxisAlignment: MainAxisAlignment.center,
						children: <Widget>[
							Text('$username',style: new TextStyle(fontSize:20,fontWeight: FontWeight.bold,color : Colors.black)),
							paddingA,
							signoutButton,
						],

					),
				),
			),
		);
	}
}