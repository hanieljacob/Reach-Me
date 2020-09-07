import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:reach_me/components/loading.dart';
import 'package:reach_me/models/UserLocation.dart';
import 'package:reach_me/services/location.dart';

class MapScreen extends StatefulWidget {
  final Position position;
  MapScreen({this.position});
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Position position;
  LocationOptions locationOptions = LocationOptions();
  MapController controller = MapController();

  @override
  void initState() {
    super.initState();
    position = widget.position;
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserLocation>(
        create: (context) => LocationService().locationStream, child: Map2());
  }
}

class Map2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var userLocation = Provider.of<UserLocation>(context);
    // print(userLocation.latitude);
    // print(userLocation.longitude);
    return userLocation == null
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
                  markers: [
                    new Marker(
                        point: new LatLng(
                            userLocation.latitude, userLocation.longitude),
                        height: 200,
                        width: 200,
                        builder: (context) => Material(
                              color: Colors.transparent,
                              child: IconButton(
                                icon: Icon(Icons.location_on),
                                color: Colors.red,
                                iconSize: 60,
                                onPressed: () {
                                  print('icon tapped');
                                },
                              ),
                            )),
                  ],
                ),
              ],
            ),
          );
  }
}
