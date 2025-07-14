import 'package:flutter/material.dart';

class RiderRequestsPage extends StatefulWidget {
  const RiderRequestsPage({super.key});

  @override
  State<RiderRequestsPage> createState() => _RiderRequestsPageState();
}

class _RiderRequestsPageState extends State<RiderRequestsPage> {
  List<Map<String, dynamic>> rideRequests = [
    {
      'id': 'req1',
      'customer': 'Thomas M.',
      'pickup': 'Kampala Road',
      'destination': 'Makerere University',
      'distance': '2.5 km',
      'fare': 5000.00,
      'time': '2 mins ago',
    },
    {
      'id': 'req2',
      'customer': 'Sarah J.',
      'pickup': 'Nakawa',
      'destination': 'Ntinda',
      'distance': '3.2 km',
      'fare': 3500.00,
      'time': '5 mins ago',
    },
    {
      'id': 'req3',
      'customer': 'David L.',
      'pickup': 'Kisugu',
      'destination': 'Kampala Road',
      'distance': '5.1 km',
      'fare': 6000.00,
      'time': '10 mins ago',
    },
  ];

  void _acceptRequest(String requestId) {
    setState(() {
      rideRequests.removeWhere((req) => req['id'] == requestId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ride request accepted')),
    );
  }

  void _rejectRequest(String requestId) {
    setState(() {
      rideRequests.removeWhere((req) => req['id'] == requestId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ride request rejected')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride Requests'),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: rideRequests.length,
        itemBuilder: (context, index) {
          final request = rideRequests[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        request['customer'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        request['time'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'From: ${request['pickup']}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'To: ${request['destination']}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Distance: ${request['distance']}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        'UGX ${request['fare'].toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            side: const BorderSide(color: Colors.red),
                          ),
                          onPressed: () => _rejectRequest(request['id']),
                          child: const Text(
                            'Reject',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () => _acceptRequest(request['id']),
                          child: const Text(
                            'Accept',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}