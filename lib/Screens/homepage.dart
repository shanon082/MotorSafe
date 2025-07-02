import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String userName = "Thomas.M.A";
  double walletBalance = 1000.00;
  List<Map<String, dynamic>> recentActivities = [
    {
      'type': 'ride',
      'amount': 3500.00,
      'date': 'Today, 10:30 AM',
      'status': 'completed'
    },
    {
      'type': 'deposit',
      'amount': 5000.00,
      'date': 'Yesterday, 4:15 PM',
      'status': 'completed'
    },
    {
      'type': 'ride',
      'amount': 2000.00,
      'date': 'Yesterday, 8:45 AM',
      'status': 'completed'
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
        title: const Text('Motor Boda'),
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
            
            // Wallet Balance Card
            _buildWalletCard(),
            const SizedBox(height: 24),
            
            // Action Cards Row
            Row(
              children: [
                Expanded(child: _buildActionCard(
                  icon: Icons.directions_bike,
                  title: 'Order Ride',
                  color: const Color(0xFF2563EB),
                  onTap: () => _navigateTo('/location'),
                )),
                const SizedBox(width: 16),
                Expanded(child: _buildActionCard(
                  icon: Icons.money,
                  title: 'Initiate Transaction',
                  color: Colors.green,
                  onTap: () => _navigateTo('/account'),
                )),
              ],
            ),
            const SizedBox(height: 32),
            
            // Recent Activity Header
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Recent Activity List
            _buildActivityList(),
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

  Widget _buildWalletCard() {
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
            const Text(
              'Wallet Balance',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'UGX ${walletBalance.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: const BorderSide(color: Color(0xFF2563EB)),
                ),
                onPressed: () => _navigateTo('/wallet'),
                child: const Text(
                  'View Wallet',
                  style: TextStyle(color: Color(0xFF2563EB)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 28, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityList() {
    return Column(
      children: recentActivities.map((activity) {
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
                color: activity['type'] == 'ride'
                    ? Colors.blue.withOpacity(0.1)
                    : Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                activity['type'] == 'ride' 
                    ? Icons.directions_bike 
                    : Icons.account_balance_wallet,
                color: activity['type'] == 'ride' ? Colors.blue : Colors.green,
              ),
            ),
            title: Text(
              activity['type'] == 'ride' ? 'Boda Ride' : 'Wallet Deposit',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(activity['date']),
            trailing: Text(
              'UGX ${activity['amount'].toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: activity['type'] == 'ride' ? Colors.red : Colors.green,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // Navigation Drawer 
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
            accountEmail: Text('user@motorboda.com'),
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
            text: 'Home',
            onTap: () => Navigator.pop(context),
          ),
          _createDrawerItem(
            icon: Icons.person_outline,
            text: 'My Account',
            onTap: () => _navigateTo('/account'),
          ),
          _createDrawerItem(
            icon: Icons.history,
            text: 'History',
            onTap: () => _navigateTo('/history'),
          ),
          _createDrawerItem(
            icon: Icons.location_on_outlined,
            text: 'Location',
            onTap: () => _navigateTo('/location'),
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

  // void _navigateTo(String route) {
  //   Navigator.pop(context); // Close drawer if open
  //   // Implement your navigation logic here
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text('Navigating to $route'),
  //       duration: const Duration(milliseconds: 500),
  //     ),
  //   );
  // }

  void _confirmLogout() {
    Navigator.pop(context); // Close drawer
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
              Navigator.pop(context); // Close dialog
              // Implement logout logic here
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