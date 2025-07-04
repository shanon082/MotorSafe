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
  bool _showRidersList = false;
  String? _selectedRiderId;
  String? _selectedPaymentMethod;
  final List<String> _paymentMethods = [
    'Cash on Delivery',
    'Mobile Money',
    'Wallet Balance'
  ];

  // Sample rider data - replace with real data from your backend
  List<Map<String, dynamic>> nearbyRiders = [
    {
      'id': 'r1',
      'name': 'Robert K.',
      'phone': '+256712345678',
      'bodaNumber': 'BODA123',
      'position': const LatLng(0.3136, 32.5811), // Sample coordinates near Kampala
      'available': true,
      'rating': 4.5,
    },
    {
      'id': 'r2',
      'name': 'Sarah M.',
      'phone': '+256712345679',
      'bodaNumber': 'BODA124',
      'position': const LatLng(0.3140, 32.5820),
      'available': true,
      'rating': 4.8,
    },
    {
      'id': 'r3',
      'name': 'David L.',
      'phone': '+256712345680',
      'bodaNumber': 'BODA125',
      'position': const LatLng(0.3130, 32.5805),
      'available': false,
      'rating': 4.2,
    },
  ];

  // static const String _apiKey = 'AIzaSyA09TXaUxZHaVX2Nx9Dj4IZGK_1Ao7gk20';

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    _fetchNearbyRiders();
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
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
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

  Future<void> _fetchNearbyRiders() async {
    // In a real app, this would fetch from your backend API
    await Future.delayed(const Duration(seconds: 1));
    
    if (!mounted) return;
    setState(() {
      // Add rider markers to the map
      for (var rider in nearbyRiders) {
        if (rider['available']) {
          _markers.add(
            Marker(
              markerId: MarkerId(rider['id']),
              position: rider['position'],
              infoWindow: InfoWindow(
                title: rider['name'],
                snippet: 'Boda: ${rider['bodaNumber']}',
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
            ),
          );
        }
      }
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (_currentPosition != null) {
      mapController.animateCamera(CameraUpdate.newLatLngZoom(_currentPosition!, 15));
    }
  }

  void _toggleRidersList() {
    setState(() {
      _showRidersList = !_showRidersList;
    });
  }

  void _selectRider(String riderId) {
    setState(() {
      _selectedRiderId = riderId;
    });
  }

  void _selectPaymentMethod(String? method) {
    setState(() {
      _selectedPaymentMethod = method;
    });
  }

  Future<void> _confirmRide() async {
    if (_selectedRiderId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a rider')),
      );
      return;
    }

    if (_sourceController.text.isEmpty || _destinationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both source and destination')),
      );
      return;
    }

    if (_selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a payment method')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Simulate API call to book ride
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ride booked successfully! Rider notified.')),
      );

      // Reset form
      setState(() {
        _selectedRiderId = null;
        _selectedPaymentMethod = null;
        _showRidersList = false;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to book ride. Please try again.')),
      );
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book a Ride'),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_search),
            onPressed: _toggleRidersList,
            tooltip: 'Show nearby riders',
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
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
                        labelText: 'Pickup Location',
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
                    
                    // Payment method selection
                    DropdownButtonFormField<String>(
                      value: _selectedPaymentMethod,
                      decoration: InputDecoration(
                        labelText: 'Payment Method',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      items: _paymentMethods
                          .map((method) => DropdownMenuItem(
                                value: method,
                                child: Text(method),
                              ))
                          .toList(),
                      onChanged: _selectPaymentMethod,
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
                        onPressed: _isLoading ? null : _confirmRide,
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                'Confirm Ride',
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          // Nearby riders bottom sheet
          if (_showRidersList) _buildRidersList(),
        ],
      ),
    );
  }

  Widget _buildRidersList() {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Available Riders Nearby',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: nearbyRiders.where((r) => r['available']).length,
                  itemBuilder: (context, index) {
                    final rider = nearbyRiders.where((r) => r['available']).toList()[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: _selectedRiderId == rider['id'] 
                          ? const Color(0xFF2563EB).withOpacity(0.1)
                          : Colors.white,
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFF2563EB),
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        title: Text(rider['name']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Phone: ${rider['phone']}'),
                            Text('Boda No: ${rider['bodaNumber']}'),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 16),
                                Text(' ${rider['rating'].toString()}'),
                              ],
                            ),
                          ],
                        ),
                        trailing: _selectedRiderId == rider['id']
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : null,
                        onTap: () => _selectRider(rider['id']),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      setState(() => _showRidersList = false);
                      if (_selectedRiderId != null) {
                        // Zoom to selected rider on map
                        final rider = nearbyRiders.firstWhere(
                          (r) => r['id'] == _selectedRiderId);
                        mapController.animateCamera(
                          CameraUpdate.newLatLngZoom(rider['position'], 16));
                      }
                    },
                    child: const Text('Select Rider', 
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
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