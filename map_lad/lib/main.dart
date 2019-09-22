import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'src/locations.dart' as locations;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';

void main(){
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
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    print("EA SPorts, it's in the game.");
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UserInputArea()),
                    );
                    //GO TO SCENE 2
                  }
                ),
              ],
            ),
            body: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: const LatLng(33.4255, -111.94),
                zoom: 14,
              ),
              markers: _markers.values.toSet(),

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
 class UserInputArea extends StatelessWidget {
  @override
   Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MatLAB'),
        backgroundColor: Colors.pink[700],
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                print("Beam me up, Scotty!");
                Navigator.pop(context);

                //GO BACK TO SCENE 1
              }
          ),
        ],
      ),
        body: Column(
    children: <Widget>[
    Text('Deliver features faster'),
    Text('Craft beautiful UIs'),
    TextFormField(
      decoration: InputDecoration(
          labelText: 'Enter your username'
      ),
    ),
    Expanded(
    child: FittedBox(
    fit: BoxFit.contain, // otherwise the logo will be tiny
    child: const FlutterLogo(),
    ),
    ),
    ],
    )
    );
 }}