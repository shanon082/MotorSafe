import 'package:flutter/material.dart';
import 'package:motor_boda/Screens/Contact/contact.dart';
import 'package:motor_boda/Screens/history.dart';
import 'package:motor_boda/Screens/Myaccount/my_account_page.dart';

class RiderHomepage extends StatefulWidget {
  const RiderHomepage({super.key});

  @override
  State<RiderHomepage> createState() => _RiderHomepageState();
}

class _RiderHomepageState extends State<RiderHomepage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String userName = "Robert.K";
  double earnings = 250000.00;
  int completedRides = 24;
  double rating = 4.8;

  List<Map<String, dynamic>> recentRides = [
    {
      'customer': 'Thomas M.',
      'amount': 5000.00,
      'date': 'Today, 10:30 AM',
      'pickup': 'Kampala Road',
      'destination': 'Makerere University'
    },
    {
      'customer': 'Sarah J.',
      'amount': 3500.00,
      'date': 'Today, 8:15 AM',
      'pickup': 'Nakawa',
      'destination': 'Ntinda'
    },
    {
      'customer': 'David L.',
      'amount': 6000.00,
      'date': 'Yesterday, 5:45 PM',
      'pickup': 'Kisugu',
      'destination': 'Kampala Road'
    },
  ];

  void _navigateTo(String route) {
    Navigator.pop(context);
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Motor Boda Rider'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      drawer: _buildNavigationDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            _buildWelcomeSection(),
            const SizedBox(height: 24),
            
            // Stats Cards
            Row(
              children: [
                Expanded(child: _buildStatCard(
                  icon: Icons.account_balance_wallet,
                  title: 'Total Earnings',
                  value: 'UGX ${earnings.toStringAsFixed(2)}',
                  color: Colors.green,
                )),
                const SizedBox(width: 16),
                Expanded(child: _buildStatCard(
                  icon: Icons.directions_bike,
                  title: 'Completed Rides',
                  value: completedRides.toString(),
                  color: Colors.blue,
                )),
              ],
            ),
            const SizedBox(height: 16),
            _buildStatCard(
              icon: Icons.star,
              title: 'Your Rating',
              value: rating.toString(),
              color: Colors.amber,
              fullWidth: true,
            ),
            const SizedBox(height: 32),
            
            // Recent Rides Header
            const Text(
              'Recent Rides',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Recent Rides List
            _buildRidesList(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back,',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          userName,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    bool fullWidth = false,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRidesList() {
    return Column(
      children: recentRides.map((ride) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person, 
                color: Colors.blue,
              ),
            ),
            title: Text(ride['customer']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${ride['pickup']} to ${ride['destination']}'),
                Text(ride['date']),
              ],
            ),
            trailing: Text(
              'UGX ${ride['amount'].toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNavigationDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              userName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text('rider@motorboda.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: const Icon(Icons.person, size: 40),
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF2563EB),
            ),
          ),
          _createDrawerItem(
            icon: Icons.home_outlined,
            text: 'Dashboard',
            onTap: () => Navigator.pop(context),
          ),
          _createDrawerItem(
            icon: Icons.person_outline,
            text: 'My Account',
            onTap: () => _navigateTo('/account'),
          ),
          _createDrawerItem(
            icon: Icons.history,
            text: 'Ride History',
            onTap: () => _navigateTo('/history'),
          ),
          _createDrawerItem(
            icon: Icons.directions_bike,
            text: 'Ride Requests',
            onTap: () => _navigateToRideRequests(),
          ),
          const Divider(),
          _createDrawerItem(
            icon: Icons.help_outline,
            text: 'Contact Us',
            onTap: () => _navigateTo('/contact'),
          ),
          _createDrawerItem(
            icon: Icons.logout,
            text: 'Logout',
            onTap: _confirmLogout,
          ),
        ],
      ),
    );
  }

  Widget _createDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey[800],
        ),
      ),
      onTap: onTap,
    );
  }

  void _navigateToRideRequests() {
    Navigator.pop(context);
    // In a real app, you would navigate to ride requests page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ride requests page')),
    );
  }

  void _confirmLogout() {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Go back to login
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out successfully')),
              );
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}