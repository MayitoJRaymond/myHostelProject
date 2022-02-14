// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:myhostel_sample/LoginPage.dart';
import 'package:myhostel_sample/WelcomePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutterfire_cli/flutterfire_cli.dart';

import 'dart:ui';

import 'package:myhostel_sample/google.dart';



 //final FirebaseAuth _auth = FirebaseAuth.instance;

void main() async {
WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}
 class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Our Unique Project',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        debugShowCheckedModeBanner: false,
        home:  Scaffold(
          body:  WelcomePage(),                   //links you to the welcome page
        ));
  }
}








