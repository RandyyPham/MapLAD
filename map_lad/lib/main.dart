import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'src/locations.dart' as locations;
import 'data/destination_parser.dart';
import 'dart:async' show Future;
import 'package:google_map_polyline/google_map_polyline.dart';

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

  GoogleMapPolyline googleMapPolyline =
  new  GoogleMapPolyline(apiKey:  "AIzaSyAfiqIZIhgw4mjdaH5eo4yfNuFYHdKlevg");


  //An array list of destinations, for all intents and purposes it is assumed
  //That the route goes from index zero destination forwards, traversing
  //The entire destinations array.
  var destinations = <Future<Destination>>{}; //TODO: MAKE FUNCTION TO ADD TO ARRAY

  final Map<String, Marker> _markers = {};
  final Map<String, Polyline>_polyline={};

  Future<void> _onMapCreated(GoogleMapController controller) async {

    var polyline = Polyline(
      polylineId: PolylineId("Yes"),
      visible: true,
      points: await googleMapPolyline.getCoordinatesWithLocation(
          origin: LatLng(40.677939, -73.941755),
          destination: LatLng(40.698432, -73.924038),
          mode:  RouteMode.driving),
      color: Colors.pink,
    );
/*    final polyline = await Polyline(color: Colors.pink, endCap: Cap.roundCap, startCap: Cap.squareCap,geodesic: true,patterns: ,
        polylineId: PolylineId("This line"),visible: true, width: 1000,
        points: await googleMapPolyline.getCoordinatesWithLocation(
            origin: LatLng(40.677939, -73.941755),
            destination: LatLng(40.698432, -73.924038),
            mode:  RouteMode.driving)

    );*/

   /* await googleMapPolyline.getCoordinatesWithLocation(
        origin: LatLng(40.677939, -73.941755),
        destination: LatLng(40.698432, -73.924038),
        mode:  RouteMode.driving);*/

    String a = await loadDestinationAsset();
    Destination destination = parseJsonForDestination(a);
    print(destination.name +" IT WORKS");
    final googleOffices = await locations.getGoogleOffices();
    setState ( () {




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
      _polyline["Brooklyn"] = polyline;
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
        polylines: _polyline.values.toSet(),
      ),
    ),
  );
}