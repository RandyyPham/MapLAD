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



Future<void> main() async {
  runApp(MaterialApp(
    title: 'MapLAD',
    home: MapViewer(),
  ));
}

class MapViewer extends StatefulWidget {
  @override
  _MapViewerState createState() => _MapViewerState();
}

class _MapViewerState extends State<MapViewer> {





  List<Destination> destinations = [];

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
      if (lecture.classToday()) {
        addDestination(lecture.location);
      } else {

      }
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
                //TODO: NEAREST LIBRARY (HAYDEN OR NOBLE)

                  icon: Icon(Icons.book),
                  onPressed: () {
                    print("EA SPorts, it's in the game.");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserInputArea()),
                    );
                    //GO TO SCENE 2
                  }),
              IconButton(
                //TODO: ADDS MU TO NAVIGATION
                  icon: Icon(Icons.fastfood),
                  onPressed: () {
                    print("EA Errrrr, it's in the game.");
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
              decoration: InputDecoration(labelText: 'Enter your class'),
              controller: demoController,
            ),
            FloatingActionButton(
              child: Icon(Icons.subdirectory_arrow_right),
              backgroundColor: Colors.pink,
              splashColor: Colors.pinkAccent,
              onPressed: () {
                print(demoController.text);
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
              Lecture lecture = new Lecture(
                  lectureController.text, M, T, W, Th, F);
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
