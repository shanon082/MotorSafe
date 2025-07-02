import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  late GoogleMapController mapController;
  Location location = Location();
  LatLng? _currentPosition;
  final TextEditingController _sourceController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  bool _isLoading = true;

  static const String _apiKey = 'AIzaSyA09TXaUxZHaVX2Nx9Dj4IZGK_1Ao7gk20';

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
      if (!serviceEnabled) {
        setState(() => _isLoading = false);
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        setState(() => _isLoading = false);
        return;
      }
    }

    try {
      LocationData locationData = await location.getLocation();
      setState(() {
        _currentPosition = LatLng(locationData.latitude!, locationData.longitude!);
        _markers.add(
          Marker(
            markerId: const MarkerId('current_location'),
            position: _currentPosition!,
            infoWindow: const InfoWindow(title: 'Your Location'),
          ),
        );
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to get current location')),
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (_currentPosition != null) {
      mapController.animateCamera(CameraUpdate.newLatLngZoom(_currentPosition!, 15));
    }
  }

  Future<void> _getDirections() async {
    final String source = _sourceController.text;
    final String destination = _destinationController.text;

    if (source.isEmpty || destination.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both source and destination')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final String url =
          'https://maps.googleapis.com/maps/api/directions/json?origin=$source&destination=$destination&mode=driving&key=$_apiKey';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'OK') {
          final polylinePoints = data['routes'][0]['overview_polyline']['points'];
          final List<LatLng> polylineCoordinates = _decodePolyline(polylinePoints);

          setState(() {
            _polylines.clear();
            _polylines.add(
              Polyline(
                polylineId: const PolylineId('route'),
                points: polylineCoordinates,
                color: const Color(0xFF2563EB),
                width: 5,
              ),
            );

            _markers.clear();
            _markers.add(
              Marker(
                markerId: const MarkerId('source'),
                position: polylineCoordinates.first,
                infoWindow: InfoWindow(title: source),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
              ),
            );
            _markers.add(
              Marker(
                markerId: const MarkerId('destination'),
                position: polylineCoordinates.last,
                infoWindow: InfoWindow(title: destination),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
              ),
            );

            mapController.animateCamera(
              CameraUpdate.newLatLngBounds(
                LatLngBounds(
                  southwest: LatLng(
                    polylineCoordinates.map((p) => p.latitude).reduce((a, b) => a < b ? a : b),
                    polylineCoordinates.map((p) => p.longitude).reduce((a, b) => a < b ? a : b),
                  ),
                  northeast: LatLng(
                    polylineCoordinates.map((p) => p.latitude).reduce((a, b) => a > b ? a : b),
                    polylineCoordinates.map((p) => p.longitude).reduce((a, b) => a > b ? a : b),
                  ),
                ),
                100,
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred while getting directions')),
      );
    } finally {
      setState(() => _isLoading = false);
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
      appBar: AppBar(
        title: const Text('Location & Directions'),
        backgroundColor: const Color(0xFF2563EB), 
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _currentPosition ?? const LatLng(0, 0),
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
                        decoration: InputDecoration(
                          labelText: 'Source',
                          prefixIcon: const Icon(Icons.location_on),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _destinationController,
                        decoration: InputDecoration(
                          labelText: 'Destination',
                          prefixIcon: const Icon(Icons.flag),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _isLoading ? null : _getDirections,
                          child: _isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.directions, color: Colors.white),
                                    SizedBox(width: 8),
                                    Text(
                                      'Get Directions',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
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