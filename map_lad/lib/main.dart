import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'src/locations.dart' as locations;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //final Map<String, Marker> _markers = {};

  var textController = TextEditingController();

  /*Future<void> _onMapCreated(GoogleMapController controller) async {
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
  }*/

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
              TextField(
                controller: textController,
              ),
              FloatingActionButton(
                onPressed: () {
                  interpret(textController.text);
                },
                child: Icon(Icons.android),
              ),
            ],

          ),
        ),
      );

  String interpret(String name) {

    name = textController.text;

    name = name.toLowerCase();

    switch(name) {
      case 'wxlr':
        print("Randy was here");
        return ("Hi");
        break;
      case 'psf':
        return ("Hi");
        break;
      case 'sdfc':
        return ("Hi");
        break;
      case 'byeng':
        return ("Hi");
        break;
      case 'byac':
        return ("Hi");
        break;
      case 'coor':
        return ("Hi");
        break;
      case 'cpcom':
        return ("Hi");
        break;
      case 'haydn':
        return ("Hi");
        break;
      case 'neeb':
        return ("Hi");
        break;
      case 'noble':
        return ("Hi");
        break;
      case 'mu':
        return ("Hi");
        break;
      case 'cwhal':
        return ("Hi");
        break;
      default:
        return ("bye");
        break;
    }
  }
}