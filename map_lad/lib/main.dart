import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'src/locations.dart' as locations;
import 'data/destination_parser.dart';
import 'dart:async' show Future;
import 'package:google_map_polyline/google_map_polyline.dart';

Future<void> main() async {
  runApp(MyApp());
  //Calls the method to print the json file.
  //loadDestination();
}
class Lecture{
  String location;
  bool m,t,w,th,f;
  Lecture(this.location,this.m,this.t,this.w,this.th,this.f);
  bool classToday(){
    //Treats today as Friday for the sake of demo.
    return f;
  }
}
class MyApp extends StatefulWidget {
  @override



  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Destination> destinations = [];

  final Map<String, Marker> _markers = {};
  final Map<String, Polyline>_polyline = {};
  //Import of polyline list maker
  GoogleMapPolyline googleMapPolyline =
  new GoogleMapPolyline(apiKey: "AIzaSyAfiqIZIhgw4mjdaH5eo4yfNuFYHdKlevg");

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

  //Returns the closer destination to the user among a and b, using the zero indez for user location.
  Destination whichIsCloser(Destination a, Destination b){
    var distanceA = sqrt(((a.lat - destinations[0].lat) * (a.lat - destinations[0].lat)) + ((a.lng - destinations[0].lng) * (a.lng - destinations[0].lng)));
    var distanceB = sqrt(((b.lat - destinations[0].lat) * (b.lat - destinations[0].lat)) + ((b.lng - destinations[0].lng) * (b.lng - destinations[0].lng)));
    if(distanceA < distanceB){
      return a;
    }else{
      return b;
    }
  }
  
  //Method to add destinations to trip
  Future<void> addDestination(String jsonPath) async {
    String path = interpret(jsonPath);
    String jsonParameters = await loadDestinationAsset(path);
    Destination newDestination = await parseJsonForDestination(jsonParameters);
    destinations.add(newDestination);
  }

  //Sets the first place you want to be (index 1) to the new destination.
  //Moving everything else back.
  Future<void> setDestination(String jsonPath) async {
    String path = interpret(jsonPath);
    String jsonParameters = await loadDestinationAsset(path);
    Destination newDestination = await parseJsonForDestination(jsonParameters);
    destinations.insert(1, newDestination);
  }

  //Deletes the destination in the 1 spot, or the most recently added destination
  Future<void> undoDestination(String jsonPath) async {
    String path = interpret(jsonPath);
    String jsonParameters = await loadDestinationAsset(path);
    Destination newDestination = await parseJsonForDestination(jsonParameters);
    destinations.removeAt(1);

    //Adds class to the set of destinations if it is active today.
    Future<void> addClass(Lecture lecture) {
      if(lecture.classToday()){
        addDestination(lecture.location);
      }else{

      }
    }
    //Sets the user to the chosen position
    // (Our version of moving for the demo)
    // You have arrived at a location if your new location was your previous goal
    //This removes the location that was previously the goal from the list.
    Future<void> setUser(String jsonPath) async {
      String path = interpret(jsonPath);
      String jsonParameters = await loadDestinationAsset(path);
      Destination newDestination = await parseJsonForDestination(
          jsonParameters);
      Destination previousDestination = destinations[1];
      destinations[0] = newDestination;
      if (previousDestination == destinations[0]) {
        destinations.removeAt(1);
      }
    }


    //An array list of destinations, for all intents and purposes it is assumed
    //That the route goes from index zero destination forwards, traversing
    //The entire destinations array.


    Future<void> onMapCreated(GoogleMapController controller) async {
      List<Polyline> routes = [];
      for (var i = 0; i < destinations.length; i++) {
        if (i < destinations.length - 1) {
          final polyline = Polyline(
            polylineId: PolylineId("From " + destinations[i].name + " to " +
                destinations[i + 1].name),
            visible: true,
            points: await googleMapPolyline.getCoordinatesWithLocation(
                origin: LatLng(destinations[i].lat, destinations[i].lng),
                destination: LatLng(
                    destinations[i + 1].lat, destinations[i + 1].lng),
                mode: RouteMode.walking),
            color: Colors.pink,
          );
          routes.add(polyline);
          //_polyline["From "+destinations[i].name+" to "+destinations[i+1].name] = polyline;
        }
      }
      setState(() {
        _markers.clear();
        _polyline.clear();
        for (var i = 0; i < destinations.length; i++) {
          final marker = Marker(
            markerId: MarkerId(destinations[i].name),
            position: LatLng(destinations[i].lat, destinations[i].lng),
            infoWindow: InfoWindow(
              title: destinations[i].name,
              snippet: destinations[i].address,
            ),
          );
          _markers[destinations[i].name] = marker;
          if (i < destinations.length - 1) {
            _polyline["From " + destinations[i].name + " to " +
                destinations[i + 1].name] = routes[i];
            // _polyline["From "+destinations[i].name+" to "+destinations[i+1].name] = polyline
          }
        }
        /*var polyline = Polyline(
      polylineId: PolylineId("Yes"),
      visible: true,
      points: await googleMapPolyline.getCoordinatesWithLocation(
          origin: LatLng(40.677939, -73.941755),
          destination: LatLng(40.698432, -73.924038),
          mode:  RouteMode.driving),
      color: Colors.pink,
    );*/


/*      for (final d in destinations) {
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
      _polyline["to " + d.name] = polyline;
    }*/

      });

      @override
      Widget build(BuildContext context) =>
          MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                title: const Text('Google Office Locations'),
                backgroundColor: Colors.green[700],
              ),
              body: GoogleMap(
                onMapCreated: onMapCreated,
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

    @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}
