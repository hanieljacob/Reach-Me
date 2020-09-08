import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:reach_me/components/loading.dart';
import 'package:reach_me/models/UserLoc.dart';
import 'package:reach_me/models/UserLocation.dart';
import 'package:reach_me/services/database.dart';
import 'package:reach_me/services/location.dart';

class MapScreen extends StatefulWidget {
  final String uid;
  MapScreen({this.uid});
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
  void initState() {
    super.initState();
    db.getFollowingLocation(widget.uid).then((value) {
      setState(() {
        userLocation = value;
        userLocation.forEach((element) {
          print(element.latitude);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserLocation>(
        create: (context) => LocationService().locationStream,
        child: Map2(
          userLocation: userLocation,
        ));
  }
}

class Map2 extends StatefulWidget {
  final List<UserLoc> userLocation;
  Map2({this.userLocation});
  @override
  _Map2State createState() => _Map2State();
}

class _Map2State extends State<Map2> {
  Database db = Database();

  List<Marker> createNewMarker(List<UserLoc> loc) {
    List<Marker> markers = [];
    loc.forEach((element) {
      markers.add(new Marker(
          point: new LatLng(element.latitude, element.longitude),
          height: 100,
          width: 100,
          builder: (context) => Material(
                color: Colors.transparent,
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Center(
                    child: ClipOval(
                      child: Image.network(
                        element.userPhoto,
                      ),
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
              )));
    });
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    var userlocation = Provider.of<UserLocation>(context);
    var user = Provider.of<FirebaseUser>(context);
    UserLoc userLocation;
    if (userlocation != null) {
      userLocation = UserLoc(
          latitude: userlocation.latitude,
          longitude: userlocation.longitude,
          username: user.displayName,
          userPhoto: user.photoUrl);
      db.storeLocation(user.uid, userLocation.latitude, userLocation.longitude);
      print(userLocation.latitude);
      print(userLocation.longitude);
    }
    return userlocation == null
        ? Loading()
        : Container(
            height: 670,
            width: 370,
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(userLocation.latitude, userLocation.longitude),
                minZoom: 16.0,
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
                  markers: createNewMarker(widget.userLocation),
                ),
              ],
            ),
          );
  }
}
