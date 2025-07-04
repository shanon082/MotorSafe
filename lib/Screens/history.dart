import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatelessWidget {
  HistoryPage({super.key});

  // Sample history data - replace with your actual data
  final List<Map<String, dynamic>> historyItems = [
    {
      'type': 'ride',
      'amount': 350.00,
      'date': DateTime.now().subtract(const Duration(hours: 2)),
      'status': 'completed',
      'driver': 'Robert K.',
      'pickup': 'Kampala Road',
      'destination': 'Makerere University',
      'duration': '15 mins',
    },
    {
      'type': 'deposit',
      'amount': 500.00,
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'status': 'completed',
      'method': 'Airtel Money',
      'reference': 'TX12345678',
    },
    {
      'type': 'withdrawal',
      'amount': 200.00,
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'status': 'completed',
      'method': 'MTN Mobile Money',
      'phone': '+256712345678',
    },
    {
      'type': 'ride',
      'amount': 420.00,
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'status': 'cancelled',
      'driver': 'Sarah M.',
      'pickup': 'Nakawa',
      'destination': 'Ntinda',
      'reason': 'Driver unavailable',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: historyItems.length,
        itemBuilder: (context, index) {
          final item = historyItems[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              onTap: () => _showHistoryDetails(context, item),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _getTypeColor(item['type']).withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getTypeIcon(item['type']),
                  color: _getTypeColor(item['type']),
                ),
              ),
              title: Text(
                _getTypeTitle(item['type']),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                DateFormat('MMM dd, yyyy - hh:mm a').format(item['date']),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'KES ${item['amount'].toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: item['type'] == 'withdrawal' ? Colors.red : Colors.green,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getStatusColor(item['status']).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item['status'].toString().toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        color: _getStatusColor(item['status']),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'ride':
        return Colors.blue;
      case 'deposit':
        return Colors.green;
      case 'withdrawal':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'ride':
        return Icons.directions_bike;
      case 'deposit':
        return Icons.account_balance_wallet;
      case 'withdrawal':
        return Icons.money;
      default:
        return Icons.history;
    }
  }

  String _getTypeTitle(String type) {
    switch (type) {
      case 'ride':
        return 'Boda Ride';
      case 'deposit':
        return 'Wallet Deposit';
      case 'withdrawal':
        return 'Withdrawal';
      default:
        return 'Activity';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _showHistoryDetails(BuildContext context, Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getTypeColor(item['type']).withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getTypeIcon(item['type']),
                      color: _getTypeColor(item['type']),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getTypeTitle(item['type']),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        DateFormat('MMM dd, yyyy - hh:mm a').format(item['date']),
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildDetailRow('Status', item['status'].toString().toUpperCase(),
                  _getStatusColor(item['status'])),
              const SizedBox(height: 12),
              _buildDetailRow('Amount', 
                  'KES ${item['amount'].toStringAsFixed(2)}',
                  item['type'] == 'withdrawal' ? Colors.red : Colors.green),
              
              if (item['type'] == 'ride') ...[
                const SizedBox(height: 12),
                _buildDetailRow('Driver', item['driver'], Colors.black),
                const SizedBox(height: 12),
                _buildDetailRow('Pickup', item['pickup'], Colors.black),
                const SizedBox(height: 12),
                _buildDetailRow('Destination', item['destination'], Colors.black),
                const SizedBox(height: 12),
                _buildDetailRow('Duration', item['duration'], Colors.black),
              ],
              
              if (item['type'] == 'deposit') ...[
                const SizedBox(height: 12),
                _buildDetailRow('Method', item['method'], Colors.black),
                const SizedBox(height: 12),
                _buildDetailRow('Reference', item['reference'], Colors.black),
              ],
              
              if (item['type'] == 'withdrawal') ...[
                const SizedBox(height: 12),
                _buildDetailRow('Method', item['method'], Colors.black),
                const SizedBox(height: 12),
                _buildDetailRow('Phone', item['phone'], Colors.black),
              ],
              
              if (item['status'] == 'cancelled' && item['reason'] != null) ...[
                const SizedBox(height: 12),
                _buildDetailRow('Reason', item['reason'], Colors.red),
              ],
              
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}