import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'src/locations.dart' as locations;
import 'package:sliding_up_panel/sliding_up_panel.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Map<String, Marker> _markers = {};

  Future<void> _onMapCreated(GoogleMapController controller) async {
    final googleOffices = await locations.getGoogleOffices();
    setState(() {
      _markers.clear();
      for (final office in googleOffices.offices) {
        final marker = Marker(
          markerId: MarkerId(office.name),
          position: LatLng(office.lat, office.lng),
          infoWindow: InfoWindow(
            title: office.name,
            snippet: office.address,
          ),
        );
        _markers[office.name] = marker;
      }
    });
  }

  @override
  Widget build(BuildContext context) =>
      MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text('MapLAD'),
              backgroundColor: Colors.pink[700],
            ),
            body: Column(
              children: <Widget>[
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: const LatLng(33.4255, -111.94),
                    zoom: 14,
                  ),
                  markers: _markers.values.toSet(),
                ),
                SlidingUpPanel(
                  panel: Center(
                    child: Text("This is a slide up panel"),
                  ),
                  body: Center(
                    child: Text("This is the body of the slide up panel"),
                  ),
                )
              ],
            )
          /*children: <Widget>[
              Container(
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: const LatLng(33.4255, -111.94),
                    zoom: 14,
                  ),
                  markers: _markers.values.toSet(),
                ),
              ),
              Container(
                child: Center(child: Text("Page 2?")),
                color: Colors.green,
              ),
              Container(
                child: Center(child: Text("Page 3 bby")),
                color: Colors.blue,
              ),
            ],*/
        ),
      );
}
