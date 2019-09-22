import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'src/locations.dart' as locations;
import 'data/destination_parser.dart';
import 'dart:async' show Future;


Future<void> main() async {
  runApp(MyApp());
  //Calls the method to print the json file.
  loadDestination();
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //An array list of destinations, for all intents and purposes it is assumed
  //That the route goes from index zero destination forwards, traversing
  //The entire destinations array.
  var destinations = <Future<Destination>>{}; //TODO: MAKE FUNCTION TO ADD TO ARRAY

  final Map<String, Marker> _markers = {};
  Future<void> _onMapCreated(GoogleMapController controller) async {
    String a = await loadDestinationAsset();
    Destination destination = parseJsonForDestination(a);
    print(destination.name +" IT WORKS");
    final googleOffices = await locations.getGoogleOffices();
    setState(() {
      _markers.clear();
      //for (final office in googleOffices.offices) {
        final marker = Marker(
          markerId: MarkerId(destination.name),
          position: LatLng(destination.lat, destination.lng),
          infoWindow: InfoWindow(
            title: destination.name,
            snippet: destination.address,
          ),
        );
        _markers[destination.name] = marker;
      //}
    });
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: const Text('Google Office Locations'),
        backgroundColor: Colors.green[700],
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: const LatLng(0, 0),
          zoom: 2,
        ),
        markers: _markers.values.toSet(),
      ),
    ),
  );
}