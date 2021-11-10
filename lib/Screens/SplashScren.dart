import 'dart:async';

import 'package:covid/Screens/Authentication.dart';
import 'package:covid/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 1500), () async {
      if (await Permission.location.serviceStatus.isDisabled) {
        print('location is Disabled');
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Location is Disabled!'),
            content: Text(
                'To use this app you first need to enable location. Please enable the location and restart the app'),
            actions: [
              TextButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: Text('Ok'),
              )
            ],
          ),
        );
      } else {
        User user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          Navigator.of(context).popAndPushNamed(Authentication.routeName);
        } else {
          Navigator.of(context).popAndPushNamed(MyHomePage.routeName);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Splash Screen',
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        ],
      ),
    );
  }
}
