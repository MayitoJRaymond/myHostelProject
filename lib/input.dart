// ignore_for_file: avoid_print, prefer_const_constructors, avoid_unnecessary_containers, use_key_in_widget_constructors, unused_import, unnecessary_import

import 'dart:async';

import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InPut extends StatefulWidget {
  InPut(this.hostelData, {Key? key}) : super(key: key);

  Map<String, dynamic> hostelData;

  @override
  State<InPut> createState() => InPutState();
}

class InPutState extends State<InPut> {
  final Stream<QuerySnapshot> hostel =
      FirebaseFirestore.instance.collection('hostel').snapshots();

  final _formKey = GlobalKey<FormState>();
  String name = '';
  var rooms = 0;
  String roomSingle = '';
  String roomDouble = '';
  String services = '';
  String contacts = '';
  double latit = 0.0;
  double longit = 0.0;
  GeoPoint cordinates = GeoPoint(0.0, 0.0);

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(
                Icons.keyboard_arrow_left,
                color: Colors.black,
              ),
            ),
            Text('Back',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.hostelData['rooms'] != null) {
      name = widget.hostelData['name']; //the entered variables dont disappear
      rooms = widget.hostelData['rooms'];
      roomSingle = widget.hostelData['roomSingle'];
      roomDouble = widget.hostelData['roomDouble'];
      services = widget.hostelData['services'];
      contacts = widget.hostelData['contacts'];
      cordinates = widget.hostelData['cordinates'];
      latit = cordinates.latitude;
      longit = cordinates.longitude;
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.hostelData['name'] ??
              'Add new hostel'), //access of the data in the Hostel page
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Positioned(top: 25, left: 0, child: _backButton()),
              _dataInput(),
            ],
          ),
        ));
  }

  Widget _dataInput() {
    return Form(
        key: _formKey,
        child: Container(
          child: Column(
            children: [
              TextFormField(
                initialValue: widget.hostelData['name'] ?? '',
                decoration: const InputDecoration(
                  icon: Icon(Icons.house),
                  labelText: "Hostel name",
                ),
                onChanged: (value) {
                  name = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Hostel name';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: (widget.hostelData['rooms'] ?? '').toString(),
                decoration: const InputDecoration(
                  icon: Icon(Icons.house),
                  labelText: "Number of rooms",
                ),
                onChanged: (value) {
                  rooms = int.parse(value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter number of rooms';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: (latit).toString(),
                decoration: const InputDecoration(
                  icon: Icon(Icons.house),
                  labelText: "latitude point",
                ),
                onChanged: (value) {
                  latit = double.parse(value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'enter latitude point';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: (longit).toString(),
                decoration: const InputDecoration(
                  icon: Icon(Icons.house),
                  labelText: "longitude point",
                ),
                onChanged: (value) {
                  longit = double.parse(value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'enter longitude point';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue:
                    (widget.hostelData['roomSingle'] ?? '').toString(),
                decoration: const InputDecoration(
                  icon: Icon(Icons.money),
                  labelText: "enter the prices for single rooms",
                ),
                onChanged: (value) {
                  roomSingle = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the prices';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue:
                    (widget.hostelData['roomDouble'] ?? '').toString(),
                decoration: const InputDecoration(
                  icon: Icon(Icons.money),
                  labelText: "enter the prices for double rooms",
                ),
                onChanged: (value) {
                  roomDouble = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the prices';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: (widget.hostelData['services'] ?? '').toString(),
                decoration: const InputDecoration(
                  icon: Icon(Icons.house),
                  labelText: "enter the services offered",
                ),
                onChanged: (value) {
                  services = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter the services offered';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: (widget.hostelData['contacts'] ?? '').toString(),
                decoration: const InputDecoration(
                  icon: Icon(Icons.contact_phone),
                  labelText: "enter the contacts",
                ),
                onChanged: (value) {
                  contacts = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'enter the contacts';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  child: Text('submit'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('sending data to cloud Firestore'),
                      ));
                      FirebaseFirestore.instance
                          .collection('hostel')
                          .doc(FirebaseAuth.instance.currentUser!
                              .uid) //specific id for the documents in the collections
                          .update({
                            'name': name,
                            'rooms': rooms,
                            'roomSingle': roomSingle,
                            'roomDouble': roomDouble,
                            'cordinates': GeoPoint(latit, longit),
                            'services': services,
                            'contacts': contacts,
                          })
                          .then((value) => ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(
                                  content: Text('hostel details added'))))
                          .catchError((error) => ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(
                                  content: Text(
                                      'failed to add details =  $error'))));
                    }
                  },
                ),
              )
            ],
          ),
        ));
  }
}
