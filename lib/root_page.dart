import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'readLocalProfileData.dart';
import 'main.dart';
import 'signin_page.dart';


String username = "";

class root_Page extends StatefulWidget{

	@override
	State<StatefulWidget> createState() => root_PageState();
}

class root_PageState extends State<root_Page>{
	final FirebaseAuth _auth = FirebaseAuth.instance;

	Route _createRoute() {
	  return PageRouteBuilder(
	    pageBuilder: (context, animation, secondaryAnimation) => MyHomePage(),
	    transitionsBuilder: (context, animation, secondaryAnimation, child) {
	      var begin = Offset(0.0, 1.0);
	      var end = Offset.zero;
	      var curve = Curves.ease;

	      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

	      return SlideTransition(
	        position: animation.drive(tween),
	        child: child,
	      );
	    },
	  );
	}

	void _signingWithLocalInfo(String u, String p) async {
	    print("attempting signin");

	    if(u == "" || u == null || u == "Error!"){
	    	Navigator.push(
	          context,
	          MaterialPageRoute(builder: (context) => signinPage()),
	        );
	    }

	    final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
	      email: u,
	      password: p,
	    ))
	        .user;

	    print(user);
	    if (user != null) {
	      setState(() {
	        print("signup success!!!");
	       
	          Navigator.of(context).push(_createRoute());


	       
	      
	      });
	    } else {
	      	Navigator.push(
	          context,
	          MaterialPageRoute(builder: (context) => signinPage()),
	        );
	    }
  	}


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
	         	_signingWithLocalInfo(lUsername,lPassword);

	      	});

	    	});
	    });
    

  }


	@override
	Widget build(BuildContext context){

		

      	final paddingA = Padding(padding: EdgeInsets.only(top: 25.0));


		return Scaffold(
			 
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
