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
  //Import of polyline list maker
  GoogleMapPolyline googleMapPolyline =
  new  GoogleMapPolyline(apiKey:  "AIzaSyAfiqIZIhgw4mjdaH5eo4yfNuFYHdKlevg");

  //Text interpreter.
  String interpret(String name) {
    //name = textController.text;

    name = name.toLowerCase();

    switch (name) {
      case 'wxlr':
        return ("https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=wxlr%20hall%20Arizona%20State%20University&inputtype=textquery&fields=photos,formatted_address,name,rating,opening_hours,geometry&key=AIzaSyAfiqIZIhgw4mjdaH5eo4yfNuFYHdKlevg");
        break;
      case 'psf':
        return ("https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=psf%20building%20Arizona%20State%20University&inputtype=textquery&fields=photos,formatted_address,name,rating,opening_hours,geometry&key=AIzaSyAfiqIZIhgw4mjdaH5eo4yfNuFYHdKlevg");
        break;
      case 'sdfc':
        return ("https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=sdfc%20building%20Arizona%20State%20University&inputtype=textquery&fields=photos,formatted_address,name,rating,opening_hours,geometry&key=AIzaSyAfiqIZIhgw4mjdaH5eo4yfNuFYHdKlevg");
        break;
      case 'byeng':
        return ("https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=byeng%20building%20Arizona%20State%20University&inputtype=textquery&fields=photos,formatted_address,name,rating,opening_hours,geometry&key=AIzaSyAfiqIZIhgw4mjdaH5eo4yfNuFYHdKlevg");
        break;
      case 'byac':
        return ("https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=byac%20building%20Arizona%20State%20University&inputtype=textquery&fields=photos,formatted_address,name,rating,opening_hours,geometry&key=AIzaSyAfiqIZIhgw4mjdaH5eo4yfNuFYHdKlevg");
        break;
      case 'coor':
        return ("https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=coor%20hall%20Arizona%20State%20University&inputtype=textquery&fields=photos,formatted_address,name,rating,opening_hours,geometry&key=AIzaSyAfiqIZIhgw4mjdaH5eo4yfNuFYHdKlevg");
        break;
      case 'cpcom':
        return ("https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=cpcom%20building%20Arizona%20State%20University&inputtype=textquery&fields=photos,formatted_address,name,rating,opening_hours,geometry&key=AIzaSyAfiqIZIhgw4mjdaH5eo4yfNuFYHdKlevg");
        break;
      case 'haydn':
        return ("https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=Hayden%20library%20Arizona%20State%20University&inputtype=textquery&fields=photos,formatted_address,name,rating,opening_hours,geometry&key=AIzaSyAfiqIZIhgw4mjdaH5eo4yfNuFYHdKlevg");
        break;
      case 'neeb':
        return ("https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=neeb%20hall%20Arizona%20State%20University&inputtype=textquery&fields=photos,formatted_address,name,rating,opening_hours,geometry&key=AIzaSyAfiqIZIhgw4mjdaH5eo4yfNuFYHdKlevg");
        break;
      case 'noble':
        return ("https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=noble%20library%20Arizona%20State%20University&inputtype=textquery&fields=photos,formatted_address,name,rating,opening_hours,geometry&key=AIzaSyAfiqIZIhgw4mjdaH5eo4yfNuFYHdKlevg");
        break;
      case 'mu':
        return ("https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=memorial%20union%20Arizona%20State%20University&inputtype=textquery&fields=photos,formatted_address,name,rating,opening_hours,geometry&key=AIzaSyAfiqIZIhgw4mjdaH5eo4yfNuFYHdKlevg");
        break;
      case 'cwhal':
        return ("https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=cottonwood%20hall%20Arizona%20State%20University&inputtype=textquery&fields=photos,formatted_address,name,rating,opening_hours,geometry&key=AIzaSyAfiqIZIhgw4mjdaH5eo4yfNuFYHdKlevg");
        break;
      default:
        return ("bye");
        break;
    }
  }

  //Method to add destinations to trip
  Future<void> addDestination(String jsonPath) async{
    String jsonParameters = await loadDestinationAsset(jsonPath);
    Destination newDestination = await parseJsonForDestination(jsonParameters);
    destinations.add(newDestination);
  }



  //An array list of destinations, for all intents and purposes it is assumed
  //That the route goes from index zero destination forwards, traversing
  //The entire destinations array.
  var destinations = <Destination>{}; //TODO: MAKE FUNCTION TO ADD TO ARRAY

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
    //final googleOffices = await locations.getGoogleOffices();
    setState ( () {




      _markers.clear();
      for (final d in destinations) {
        final marker = Marker(
          markerId: MarkerId(d.name),
          position: LatLng(d.lat, d.lng),
          infoWindow: InfoWindow(
            title: d.name,
            snippet: d.address,
          ),
        );
        _markers[d.name] = marker;
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