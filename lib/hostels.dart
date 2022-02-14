// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myhostel_sample/input.dart';

class Hostel extends StatefulWidget {
  String name = '';
  var rooms = 0;
  String roomSingle = '';
  String roomDouble = '';

  @override
  _HostelState createState() => _HostelState();
}

class _HostelState extends State<Hostel> {
  final Stream<QuerySnapshot> hostel =
      FirebaseFirestore.instance.collection('hostel').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Hostel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream: hostel,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Loading");
                    }

                    return Card(
                        child: ListView(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        data['id'] = document.id;
                        print(data.toString());
                        return ListTile(
                          onTap: () => Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => InPut(
                                  data))), //pass the data as a variable to the Inputpage
                          title: Column(
                            children: [
                              Text(
                                data['name'], style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(data['rooms'].toString())
                            ],
                          ),
                          subtitle: Column(
                            children: [
                              Text(data['roomSingle'].toString()),
                              Text(data['roomDouble'].toString()),
                            ],
                          ),
                        );
                      }).toList(),
                    ));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  myCard(String name, var rooms, String roomSingle, String roomDouble) =>
      InkWell(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return Scaffold();
            
          }));
        },
        child: Card(
            //function represents each hostel specs
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                SizedBox(width: 20),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            )),
      );
}
