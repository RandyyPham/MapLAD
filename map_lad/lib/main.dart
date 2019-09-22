import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'src/locations.dart' as locations;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'src/locations.dart' as locations;
import 'data/destination_parser.dart';
import 'dart:async' show Future;
import 'package:google_map_polyline/google_map_polyline.dart';

class Lecture{
  String location;
  bool m,t,w,th,f;
  Lecture(this.location,this.m,this.t,this.w,this.th,this.f);
  bool classToday(){
    //Treats today as Friday for the sake of demo.
    return f;
  }
}
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

class DestinationHandler {
  static List<Destination> destinations = [];



  //Returns the closer destination to the user among a and b, using the zero indez for user location.
  //Adds closest to destination list
  static Future<void> whichIsCloser(String aIn, String bIn) async{
    String path1 = interpret(aIn);
    String jsonParameters = await loadDestinationAsset(path1);
    Destination a = await parseJsonForDestination(jsonParameters);

    String path = interpret(bIn);
    String jsonP = await loadDestinationAsset(path);
    Destination b = await parseJsonForDestination(jsonP);
    var distanceA = sqrt(((a.lat - destinations[0].lat) * (a.lat - destinations[0].lat)) + ((a.lng - destinations[0].lng) * (a.lng - destinations[0].lng)));
    var distanceB = sqrt(((b.lat - destinations[0].lat) * (b.lat - destinations[0].lat)) + ((b.lng - destinations[0].lng) * (b.lng - destinations[0].lng)));
    if(distanceA < distanceB){
      setDestination(aIn);
    }else{
      setDestination(bIn);
    }
  }

  //Method to add destinations to trip
  static Future<void> addDestination(String jsonPath) async {
    String path = interpret(jsonPath);
    String jsonParameters = await loadDestinationAsset(path);
    Destination newDestination = await parseJsonForDestination(jsonParameters);
    await destinations.add(newDestination);
    print("HHHHHHH");
    print(destinations[destinations.length-1].name);
    print(destinations[destinations.length-1].address);
    print(destinations[destinations.length-1].lat);
    print(destinations[destinations.length-1].lng);
  }

  //Sets the first place you want to be (index 1) to the new destination.
  //Moving everything else back.
  static Future<void> setDestination(String jsonPath) async {
    String path = interpret(jsonPath);
    String jsonParameters = await loadDestinationAsset(path);
    Destination newDestination = await parseJsonForDestination(jsonParameters);
    destinations.insert(1, newDestination);
    print("GGGGGGGGGG");
    print(destinations[1].name);
    print(destinations[1].address);
    print(destinations[1].lat);
    print(destinations[1].lng);
  }

  //Deletes the destination in the 1 spot, or the most recently added destination
  static Future<void> undoDestination() async {
    await destinations.removeAt(1);
  }

    //Adds class to the set of destinations if it is active today.
    static Future<void> addClass(Lecture lecture) {
      if (lecture.classToday()) {
        addDestination(lecture.location);
      } else {
        print('no');
      }
    }

  //Sets the user to the chosen position
  // (Our version of moving for the demo)
  // You have arrived at a location if your new location was your previous goal
  //This removes the location that was previously the goal from the list.
  static Future<void> setUser(String jsonPath) async {
    String path = interpret(jsonPath);
    String jsonParameters = await loadDestinationAsset(path);
    Destination newDestination = await parseJsonForDestination(
        jsonParameters);
    Destination previousDestination = destinations[1];
    destinations[0] = newDestination;
    if (previousDestination == destinations[0]) {
      destinations.removeAt(1);
    }
    print("FFFFFFFFFFF");
    print(destinations[0].name);
    print(destinations[0].address);
    print(destinations[0].lat);
    print(destinations[0].lng);
  }


  DestinationHandler();
}

Future<void> main() async {
  runApp(MaterialApp(
    title: 'MapLAD',
    home: MapViewer(),
  ));
}

class MapViewer extends StatefulWidget {
  @override
  MapViewerState createState() => MapViewerState();
}

class MapViewerState extends State<MapViewer> {







    @override
    Widget build(BuildContext context) => MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('MapLAD'),
            backgroundColor: Colors.pink[700],
            actions: <Widget>[
              IconButton(
                //TODO: CLASS SCHEDULE MAKER

                  icon: Icon(Icons.code),
                  onPressed: () {
                    print("EA SPorts, it's in the game.");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DemoArea()),
                    );
                    //GO TO SCENE 2
                  }),
              IconButton(
                //TODO: LOCATION SETTER FOR DEMO

                  icon: Icon(Icons.school),
                  onPressed: () {
                    print("EA SPorts, it's in the game.");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ClassSchedulerArea()),
                    );
                    //GO TO SCENE 2
                  }),
              IconButton(
                //TODO: NEAREST LIBRARY
                  icon: Icon(Icons.book),
                  onPressed: () {
                    print("EA Errrrr, it's in the game.");

                    //Set Next step in navigation to nearest food.
                    //GO TO SCENE 2
                  }),
              IconButton(
                //TODO: ADDS MU TO NAVIGATION
                  icon: Icon(Icons.fastfood),
                  onPressed: () {
                    print("EA Errrrr, it's in the game.");
                    DestinationHandler.setDestination("mu");
                    //Set Next step in navigation to nearest food.
                    //GO TO SCENE 2
                  }),
              IconButton(
                //TODO: ADDS STARBUCKS TO NAVIGATION
                  icon: Icon(Icons.star),
                  onPressed: () {
                    print("EA Errrrr, it's in the game.");
                    //Set Next step in navigation to nearest food.
                    //GO TO SCENE 2
                  }),

              IconButton(
                //TODO: REMOVED CURRENT NAVIGATION TARGET
                  icon: Icon(Icons.undo),
                  onPressed: () {
                    print("EA Errrrr, it's in the game.");
                    DestinationHandler.undoDestination();
                    //Set Next step in navigation to nearest food.
                    //GO TO SCENE 2
                  }),
            ],
          ),
          body: GoogleMap(
            onMapCreated: onMapCreated,
            initialCameraPosition: CameraPosition(
              target: const LatLng(33.4255, -111.94),
              zoom: 14,
            ),
            markers: _markers.values.toSet(),
            polylines: _polyline.values.toSet(),
          )
      ),
    );






    final Map<String, Marker> _markers = {};
  final Map<String, Polyline>_polyline = {};
  //Import of polyline list maker
  GoogleMapPolyline googleMapPolyline =
  new GoogleMapPolyline(apiKey: "AIzaSyAfiqIZIhgw4mjdaH5eo4yfNuFYHdKlevg");

    Future<void> onMapCreated(GoogleMapController controller) async {
      List<Polyline> routes = [];
      print("testttttt");
      await DestinationHandler.addDestination("cwhal");
      await DestinationHandler.addDestination("byac");
      await DestinationHandler.addDestination("byeng");
      await DestinationHandler.addDestination("noble");
      for (var i = 0; i < DestinationHandler.destinations.length; i++) {
        if (i < DestinationHandler.destinations.length - 1) {
          var polyline = Polyline(
            polylineId: PolylineId("From " + DestinationHandler.destinations[i].name + " to " +
                DestinationHandler.destinations[i + 1].name),
            visible: true,
            points: await googleMapPolyline.getCoordinatesWithLocation(
                origin: LatLng(DestinationHandler.destinations[i].lat, DestinationHandler.destinations[i].lng),
                destination: LatLng(
                    DestinationHandler.destinations[i + 1].lat, DestinationHandler.destinations[i + 1].lng),
                mode: RouteMode.walking),
            color: Colors.pink,
          );
          await routes.add(polyline);
          //_polyline["From "+destinations[i].name+" to "+destinations[i+1].name] = polyline;
        }
      }
      setState(() {
        print("THE NUMBER IS" + DestinationHandler.destinations.length.toString());
        _markers.clear();
        _polyline.clear();
        for (var i = 0; i < DestinationHandler.destinations.length; i++) {
          print("ZZZZZZZZZZZZZZ");
          final marker = Marker(
            markerId: MarkerId(DestinationHandler.destinations[i].name),
            position: LatLng(DestinationHandler.destinations[i].lat, DestinationHandler.destinations[i].lng),
            infoWindow: InfoWindow(
              title: DestinationHandler.destinations[i].name,
              snippet: DestinationHandler.destinations[i].address,
            ),
          );
          _markers[DestinationHandler.destinations[i].name] = marker;
          if (i < DestinationHandler.destinations.length - 1) {
            _polyline["From " + DestinationHandler.destinations[i].name + " to " +
                DestinationHandler.destinations[i + 1].name] = routes[i];
            // _polyline["From "+destinations[i].name+" to "+destinations[i+1].name] = polyline
          }

        }
        //ONLY WAY TO REFRESH MAP QUICKLY
        onMapCreated(controller);
      });

  }

}

class UserInputArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('You have spare time! Where to?'),
          backgroundColor: Colors.pink[700],
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  print("Beam me up, Scotty!");

                  Navigator.pop(context);

                  //GO BACK TO SCENE 1
                }),
          ],
        ),
        body: Column(
          children: <Widget>[
            Text('Deliver features faster'),
            Text('Craft beautiful UIs'),
            TextFormField(
              decoration: InputDecoration(labelText: 'Enter your username'),
            ),
            Expanded(
              child: FittedBox(
                fit: BoxFit.contain, // otherwise the logo will be tiny
                child: const FlutterLogo(),
              ),
            ),
          ],
        ));
  }
}

class FoodInputArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('You want some food?'),
          backgroundColor: Colors.pink[700],
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  print("Beam me up, Scotty!");
                  Navigator.pop(context);

                  //GO BACK TO SCENE 1
                }),
          ],
        ),
        body: Column(
          children: <Widget>[
            Text('Deliver features faster'),
            Text('Craft beautiful UIs'),
            TextFormField(
              decoration: InputDecoration(labelText: 'Enter your username'),
            ),
            Expanded(
              child: FittedBox(
                fit: BoxFit.contain, // otherwise the logo will be tiny
                child: const FlutterLogo(),
              ),
            ),
          ],
        ));
  }
}

class DemoArea extends StatelessWidget {

  var demoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('MapLAD Class Scheduler'),
          backgroundColor: Colors.pink[700],
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  print("Scheduling");
                  Navigator.pop(context);

                  //GO BACK TO SCENE 1
                }),
          ],
        ),
        body: Column(
          children: <Widget>[
            Text('Deliver features faster'),
            Text('Craft beautiful UIs'),
            TextField(
              decoration: InputDecoration(labelText: 'Enter your location'),
              controller: demoController,
            ),
            FloatingActionButton(
              child: Icon(Icons.subdirectory_arrow_right),
              backgroundColor: Colors.pink,
              splashColor: Colors.pinkAccent,
              onPressed: () {
                DestinationHandler.setUser(demoController.text);

                // do some function with the user input
              }
            ),
            /*Expanded(
              child: FittedBox(
                fit: BoxFit.contain, // otherwise the logo will be tiny
                child: const FlutterLogo(),
              ),
            ),*/
          ],
        ));
  }
}

class ClassSchedulerArea extends StatelessWidget {

  var lectureController = TextEditingController();
  String className;
  bool M = false;
  bool T = false;
  bool W = false;
  bool Th = false;
  bool F = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Where are you?'),
        backgroundColor: Colors.pink[700],
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                print("Beam me up, Scotty!");
                Navigator.pop(context);
                /*Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoadingScreen()));*/
              }
          )
        ],
        //Navigator.pop(context);

        //GO BACK TO SCENE 1
      ),
      body: Column(
        children: <Widget>[
          Text(''),
          Text('Enjoy Arizona State University :)'),
          TextField(
            controller: lectureController,
            decoration: InputDecoration(
                labelText: 'Enter your location please'),

          ),

          Row(
            children: <Widget>[
              FlatButton(
                color: Colors.pinkAccent,
                onPressed: () {
                  M = !M;
                },
                child: Text(
                  "m",
                ),
              ),
              FlatButton(
                color: Colors.pinkAccent,
                onPressed: () {
                  T = !T;
                },
                child: Text(
                  "t",
                ),
              ),
              FlatButton(
                color: Colors.pinkAccent,
                onPressed: () {
                  W = !W;
                },
                child: Text(
                  "w",
                ),
              )


            ],
          ),
          Row(
            children: <Widget>[
              FlatButton(
                color: Colors.pinkAccent,
                onPressed: () {
                  Th = !Th;
                },
                child: Text(
                  "th",
                ),
              ),
              FlatButton(
                color: Colors.pinkAccent,
                onPressed: () {
                  F = !F;
                },
                child: Text(
                  "f",
                ),
              ),
            ],
          ),
          FloatingActionButton(
            backgroundColor: Colors.lightGreenAccent,
            onPressed: () {
              Lecture lecture = new Lecture(lectureController.text, M, T, W, Th, F);
              DestinationHandler.addClass(lecture);
              M = false;
              T = false;
              W = false;
              Th = false;
              F = false;
              //TODO: ADD DESTINATION ADDER HERE!
            },
          ),
        ],
      ),
    );
    @override
    State<StatefulWidget> createState() {
      // TODO: implement createState
      return null;
    }
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return null;
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(''),
          //backgroundColor: Colors.pink[700],
          /*actions: <Widget>[
            IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  print("Beam me up, Scotty!");
                  Navigator.pop(context);

                  //GO BACK TO SCENE 1
                }),
          ],*/
        ),
        body: Column(
          children: <Widget>[
            //Text('Deliver features faster'),
            //Text('Craft beautiful UIs'),
            /*TextFormField(
              decoration: InputDecoration(labelText: 'Enter your username'),
            ),*/
            Expanded(
              child: RichText(
                text: TextSpan(
                  text: 'Loading...',
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan> [
                    TextSpan(text: '', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0)),
                  ],
                ),
              ),
              /*child: FittedBox(
                fit: BoxFit.contain, // otherwise the logo will be tiny
                child: const FlutterLogo(),
              ),*/
            ),
          ],
        ));
  }
}
