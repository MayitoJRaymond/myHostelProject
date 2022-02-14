// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_final_fields, unnecessary_new, unnecessary_this, empty_constructor_bodies, unnecessary_import, unused_import, unused_field

import 'dart:async';

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myhostel_sample/input.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  final Stream<QuerySnapshot> hostel =
      FirebaseFirestore.instance.collection('hostel').snapshots();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(0.3361, 32.5645),
    zoom: 15,
  );

  static final CameraPosition _makerere = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(0.3335, 32.5675),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

 
  late BitmapDescriptor workshopIcon1;
  late BitmapDescriptor workshopIcon2;
  late BitmapDescriptor workshopIcon3;

  List<Marker> markers = [];
  Map<String, dynamic>? _currentHostel;

  @override
  void initState() {
    super.initState();
    getIcons();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            markers: markers.toSet(),
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              hostel.listen((QuerySnapshot<Object?> event) {
                // ignore: avoid_function_literals_in_foreach_calls
                event.docs.forEach((element) {
                  //forloop to look through the docs for each in the firebase
                  Map<String, dynamic> data =
                      element.data()! as Map<String, dynamic>;
                  data['id'] = element.id;

                  _addMarker(data);
                });
              });
            },
          ),
          if (_currentHostel != null)
            Container(
              margin: EdgeInsets.all(20),
              height: 300,
              child: Card(
                child: ListTile(
                  title: Column(
                    children: [
                      Text(
                        _currentHostel!['name'],
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange),
                      ),
                      Text('Rooms available:'),
                      Text(_currentHostel!['rooms'].toString()),
                      Text('Double:'),
                      Text(_currentHostel!['roomDouble']),
                      Text('Single:'),
                      Text(_currentHostel!['roomSingle']),
                      Text('services offered:'),
                      Text(_currentHostel!['services']),
                      ElevatedButton(
                        child: Text('Check for hostel contacts'),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text('Contact Hostel Custodians :'),
                                    content: Center(
                                      child: SelectableText(
                                          _currentHostel!['contacts']),
                                    ),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        child: Text('Okay'),
                                        onPressed: () {
                                          FirebaseFirestore.instance
                                              .collection('hostel')
                                              .doc(_currentHostel!['id'])
                                              .update({
                                            'rooms': FieldValue.increment(-1),
                                          }).then((value) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        'you have booked ')));
                                          Navigator.of(context).pop();
                                          });
                                        },
                                      )
                                    ],
                                  ));
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _addMarker(Map<String, dynamic> data) async {
    final point = data['cordinates'] as GeoPoint;
    var _marker = Marker(
        onTap: () => setState(() {
              _currentHostel = data;
            }),
        markerId: MarkerId(UniqueKey().toString()),
        position: LatLng(point.latitude, point.longitude),
        infoWindow: InfoWindow(title: data['name']),
        icon: data['rooms'] < 1
            ? workshopIcon1
            : data['rooms'] >= 10
                ? workshopIcon2
                : workshopIcon3);

    setState(() {
      markers.add(_marker);
    });
  }

  getIcons() async {
    var icon1 = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 3.2), "assets/images/red.png");
    var icon2 = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 3.2), "assets/images/green.png");
    var icon3 = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 3.2), "assets/images/orange.png");
    setState(() {
      this.workshopIcon1 = icon1;
      this.workshopIcon2 = icon2;
      this.workshopIcon3 = icon3;
    });
  }
}
