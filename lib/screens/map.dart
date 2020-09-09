import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:reach_me/components/loading.dart';
import 'package:reach_me/models/UserLoc.dart';
import 'package:reach_me/models/UserLocation.dart';
import 'package:reach_me/screens/profile.dart';
import 'package:reach_me/services/database.dart';
import 'package:reach_me/services/location.dart';

//class MapScreen extends StatefulWidget {
//  final String uid;
//  MapScreen({this.uid});
//  @override
//  _MapScreenState createState() => _MapScreenState();
//}
//
//class _MapScreenState extends State<MapScreen> {
//
//  List<Marker> createNewMarker(List<DocumentSnapshot> loc) {
//    List<Marker> markers = [];
//    loc.forEach((element) {
//      markers.add(
//        new Marker(
//          point: new LatLng(element['Latitude'], element['Longitude']),
//          height: 100,
//          width: 100,
//          builder: (context) => Material(
//            color: Colors.transparent,
//            child: Scaffold(
//              backgroundColor: Colors.transparent,
//              body: GestureDetector(
//                onTap: (){Scaffold.of(context).showSnackBar(SnackBar(content: Text(element['name']),backgroundColor: Color.fromARGB(255, 255, 0, 0),
//                  duration: Duration(seconds: 5),
//                  action: SnackBarAction(
//                    label: 'UNDO', onPressed: scaff.hideCurrentSnackBar,
//                  ),));},
//                child: Center(
//                  child: ClipOval(
//                    child: Image.network(
//                      element['userphoto'],
//                    ),
//                  ),
//                ),
//              ),
//            ),
//            // child: IconButton(
//            //   icon: Icon(Icons.location_on),
//            //   color: Colors.red,
//            //   iconSize: 60,
//            //   onPressed: () {
//            //     print('icon tapped');
//            //   },
//            // ),
//          ),
//        ),
//      );
//    });
//    return markers;
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("Map"),
//      ),
//      body: StreamBuilder(
//        stream: Firestore.instance.collection('Locations').snapshots(),
//        builder: (context, snapshot) {
//          DocumentSnapshot userSnap;
//          List<DocumentSnapshot> snaps;
//          if (snapshot.hasData) {
//            snaps = snapshot.data.documents;
//            snaps.forEach((element) {
//              if (element.documentID == widget.uid) {
//                userSnap = element;
//              }
//            });
//          }
//          return snapshot.hasData
//              ? Container(
//            height: MediaQuery.of(context).size.height,
//            width: 370,
//            child: FlutterMap(
//              options: MapOptions(
//                center:
//                LatLng(userSnap['Latitude'], userSnap['Longitude']),
//                minZoom: 3,
//                maxZoom: 19.0,
//              ),
//              layers: [
//                TileLayerOptions(
////                        urlTemplate:
////                        'https://api.openrouteservice.org/mapsurfer/{z}/{x}/{y}.png?api_key=omitted',
//                    urlTemplate:
//                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
//                    subdomains: ['a', 'b', 'c'],
//                    keepBuffer: 20),
//                new MarkerLayerOptions(
//                  markers: createNewMarker(snaps),
//                ),
//              ],
//            ),
//          )
//              : Loading();
//        },
//      ),
//    );
//  }
//}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:reach_me/components/loading.dart';
import 'package:reach_me/models/User.dart';
import 'package:reach_me/models/UserLoc.dart';
import 'package:reach_me/models/UserLocation.dart';
import 'package:reach_me/services/database.dart';
import 'package:reach_me/services/location.dart';

class MapScreen extends StatefulWidget {
  final String uid;
  final User user;
  MapScreen({this.uid, this.user});
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Position position;
  Database db = Database();
  LocationOptions locationOptions = LocationOptions();
  MapController controller = MapController();
  List<UserLoc> userLocation = [];

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserLocation>(
      create: (context) => LocationService().locationStream,
      child: Map2(
        uid: widget.uid,
        user: widget.user,
      ),
    );
  }
}

class Map2 extends StatefulWidget {
  final String uid;
  final User user;
  Map2({this.uid, this.user});
  @override
  _Map2State createState() => _Map2State();
}

class _Map2State extends State<Map2> {
  Database db = Database();

  List<Marker> createNewMarker(List<DocumentSnapshot> loc) {
    List<Marker> markers = [];
    loc.forEach((element) {
      if (widget.user.following.contains(element.documentID) ||
          element.documentID == widget.user.uid) {
        markers.add(
          new Marker(
            point: new LatLng(element['Latitude'], element['Longitude']),
            height: 150,
            width: 150,
            builder: (context) => Material(
              color: Colors.transparent,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: GestureDetector(
                  onTap: () {
                    Scaffold.of(context).removeCurrentSnackBar(
                        reason: SnackBarClosedReason.remove);
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                        element['name'] +
                            "\n" +
                            "Latitude: " +
                            element['Latitude'].toString() +
                            "\n" +
                            "Longitude: " +
                            element['Longitude'].toString() +
                            "\n" +
                            "Updated " +
                            db.convertTime(Timestamp.fromMillisecondsSinceEpoch(
                                element['time'])),
                        style: TextStyle(fontSize: 16),
                      ),
                      backgroundColor: Colors.blue,
                      duration: Duration(seconds: 5),
                      action: widget.uid != element.documentID
                          ? SnackBarAction(
                              label: "Go to Profile",
                              textColor: Colors.white,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfilePage(
                                              user: widget.user,
                                              uid: element.documentID,
                                            )));
                              },
                            )
                          : null,
                    ));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: Image.network(
                          element['userphoto'],
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          color: Colors.blue,
                          child: Text(
                            "Updated " +
                                db.convertTime(
                                    Timestamp.fromMillisecondsSinceEpoch(
                                        element['time'])),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // child: IconButton(
              //   icon: Icon(Icons.location_on),
              //   color: Colors.red,
              //   iconSize: 60,
              //   onPressed: () {
              //     print('icon tapped');
              //   },
              // ),
            ),
          ),
        );
      }
    });
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    var userLocation = Provider.of<UserLocation>(context);
    if (userLocation != null) {
      db.storeLocation(
        widget.uid,
        userLocation.latitude,
        userLocation.longitude,
      );
    }
    return userLocation == null
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text("Map"),
            ),
            body: StreamBuilder(
              stream: Firestore.instance.collection('Locations').snapshots(),
              builder: (context, snapshot) {
                DocumentSnapshot userSnap;
                List<DocumentSnapshot> snaps;
                if (snapshot.hasData) {
                  snaps = snapshot.data.documents;
                  snaps.forEach((element) {
                    if (element.documentID == widget.uid) {
                      userSnap = element;
                    }
                  });
                }
                return snapshot.hasData
                    ? Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: FlutterMap(
                          options: MapOptions(
                            center: LatLng(
                                userSnap['Latitude'], userSnap['Longitude']),
                            minZoom: 0,
                            maxZoom: 19.0,
                          ),
                          layers: [
                            TileLayerOptions(
//                        urlTemplate:
//                        'https://api.openrouteservice.org/mapsurfer/{z}/{x}/{y}.png?api_key=omitted',
                                urlTemplate:
                                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                subdomains: ['a', 'b', 'c'],
                                keepBuffer: 20),
                            new MarkerLayerOptions(
                              markers: createNewMarker(snaps),
                            ),
                          ],
                        ),
                      )
                    : Loading();
              },
            ),
          );
  }
}
