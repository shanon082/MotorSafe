import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late GoogleMapController mapController;
  Location location = Location();
  LatLng? _currentPosition;
  final TextEditingController _sourceController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};

  static const String _apiKey =
      'AIzaSyA09TXaUxZHaVX2Nx9Dj4IZGK_1Ao7gk20'; // Replace with your Google Maps API key

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    LocationData locationData = await location.getLocation();
    setState(() {
      _currentPosition =
          LatLng(locationData.latitude!, locationData.longitude!);
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: _currentPosition!,
          infoWindow: const InfoWindow(title: 'Your Location'),
        ),
      );
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (_currentPosition != null) {
      mapController
          .animateCamera(CameraUpdate.newLatLngZoom(_currentPosition!, 15));
    }
  }

  Future<void> _getDirections() async {
    final String source = _sourceController.text;
    final String destination = _destinationController.text;

    if (source.isEmpty || destination.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter both source and destination')),
      );
      return;
    }

    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$source&destination=$destination&mode=driving&key=$_apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'OK') {
        final polylinePoints = data['routes'][0]['overview_polyline']['points'];
        final List<LatLng> polylineCoordinates =
            _decodePolyline(polylinePoints);

        setState(() {
          _polylines.clear();
          _polylines.add(
            Polyline(
              polylineId: const PolylineId('route'),
              points: polylineCoordinates,
              color: Colors.blue,
              width: 6,
            ),
          );

          // Add markers for source and destination
          _markers.clear();
          _markers.add(
            Marker(
              markerId: const MarkerId('source'),
              position: polylineCoordinates.first,
              infoWindow: const InfoWindow(title: 'Source'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen),
            ),
          );
          _markers.add(
            Marker(
              markerId: const MarkerId('destination'),
              position: polylineCoordinates.last,
              infoWindow: const InfoWindow(title: 'Destination'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed),
            ),
          );

          // Adjust camera to fit the route
          mapController.animateCamera(
            CameraUpdate.newLatLngBounds(
              LatLngBounds(
                southwest: LatLng(
                  polylineCoordinates
                      .map((p) => p.latitude)
                      .reduce((a, b) => a < b ? a : b),
                  polylineCoordinates
                      .map((p) => p.longitude)
                      .reduce((a, b) => a < b ? a : b),
                ),
                northeast: LatLng(
                  polylineCoordinates
                      .map((p) => p.latitude)
                      .reduce((a, b) => a > b ? a : b),
                  polylineCoordinates
                      .map((p) => p.longitude)
                      .reduce((a, b) => a > b ? a : b),
                ),
              ),
              100, // Padding
            ),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${data['status']}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch directions')),
      );
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height *
                      0.6, // Increased map height
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _currentPosition!,
                      zoom: 15,
                    ),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    markers: _markers,
                    polylines: _polylines,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _sourceController,
                        decoration: const InputDecoration(
                          labelText: 'Source',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _destinationController,
                        decoration: const InputDecoration(
                          labelText: 'Destination',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _getDirections,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.directions, color: Colors.white),
                            SizedBox(width: 10),
                            Text(
                              'Get Directions',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    _sourceController.dispose();
    _destinationController.dispose();
    mapController.dispose();
    super.dispose();
  }
}
