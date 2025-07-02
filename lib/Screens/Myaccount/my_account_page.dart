import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MyAccountPage extends StatelessWidget {
  const MyAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Section
          _buildAccountItem(
            context,
            icon: Icons.person_outline,
            title: 'Profile',
            onTap: () => _navigateToProfile(context),
          ),
          const Divider(),
          
          // Deposit Section
          _buildAccountItem(
            context,
            icon: Icons.account_balance_wallet,
            title: 'Deposit to Account',
            onTap: () => _navigateToDeposit(context),
          ),
          const Divider(),
          
          // Withdraw Section
          _buildAccountItem(
            context,
            icon: Icons.money_outlined,
            title: 'Withdraw from Account',
            onTap: () => _navigateToWithdraw(context),
          ),
          const Divider(),
          
          // Change Wallet Pin
          _buildAccountItem(
            context,
            icon: Icons.lock_outline,
            title: 'Change Wallet PIN',
            onTap: () => _navigateToChangePin(context),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountItem(BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF2563EB)),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _navigateToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfilePage()),
    );
  }

  void _navigateToDeposit(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DepositPage()),
    );
  }

  void _navigateToWithdraw(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WithdrawPage()),
    );
  }

  void _navigateToChangePin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChangePinPage()),
    );
  }
}

// Profile Page
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Thomas Simons');
  final _phoneController = TextEditingController(text: '+256 712 345 678');
  final _emailController = TextEditingController(text: 'tom@gmail.com');
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  File? _profileImage;
  bool _isSaving = false;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text.isNotEmpty && 
        _passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() => _isSaving = true);
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );

    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : const AssetImage('assets/profile_placeholder.png') as ImageProvider,
                  child: _profileImage == null
                      ? const Icon(Icons.camera_alt, size: 30, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(height: 24),
              
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'New Password (leave blank to keep current)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                obscureText: true,
              ),
              const SizedBox(height: 32),
              
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
                  onPressed: _isSaving ? null : _saveProfile,
                  child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Save Changes', style: TextStyle(color: Colors.white,)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Deposit Page
class DepositPage extends StatefulWidget {
  const DepositPage({super.key});

  @override
  State<DepositPage> createState() => _DepositPageState();
}

class _DepositPageState extends State<DepositPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String _selectedMethod = 'Airtel Money';
  bool _isProcessing = false;

  final List<String> _paymentMethods = [
    'Airtel Money',
    'MTN Mobile Money',
    'Bank Transfer'
  ];

  Future<void> _processDeposit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);
    
    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() => _isProcessing = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Deposit successful!')),
    );

    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deposit to Account'),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  prefixText: 'UGX ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              
              const Text(
                'Payment Method',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              
              ..._paymentMethods.map((method) => RadioListTile(
                title: Text(method),
                value: method,
                groupValue: _selectedMethod,
                onChanged: (value) {
                  setState(() {
                    _selectedMethod = value!;
                  });
                },
              )),
              const SizedBox(height: 32),
              
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
                  onPressed: _isProcessing ? null : _processDeposit,
                  child: _isProcessing
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Confirm Payment'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Withdraw Page
class WithdrawPage extends StatefulWidget {
  const WithdrawPage({super.key});

  @override
  State<WithdrawPage> createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _phoneController = TextEditingController(text: '+256 712 345 678');
  bool _isProcessing = false;

  Future<void> _processWithdrawal() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);
    
    // Simulate withdrawal processing
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() => _isProcessing = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Withdrawal successful!')),
    );

    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Withdraw from Account'),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  prefixText: 'UGX ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              
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
                  onPressed: _isProcessing ? null : _processWithdrawal,
                  child: _isProcessing
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Withdraw Funds',
                          style: TextStyle(color: Colors.white),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Change PIN Page
class ChangePinPage extends StatefulWidget {
  const ChangePinPage({super.key});

  @override
  State<ChangePinPage> createState() => _ChangePinPageState();
}

class _ChangePinPageState extends State<ChangePinPage> {
  final _formKey = GlobalKey<FormState>();
  final _oldPinController = TextEditingController();
  final _newPinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  bool _isProcessing = false;

  Future<void> _changePin() async {
    if (!_formKey.currentState!.validate()) return;

    if (_newPinController.text != _confirmPinController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PINs do not match')),
      );
      return;
    }

    setState(() => _isProcessing = true);
    
    // Simulate PIN change
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    setState(() => _isProcessing = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('PIN changed successfully')),
    );

    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _oldPinController.dispose();
    _newPinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Wallet PIN'),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _oldPinController,
                decoration: InputDecoration(
                  labelText: 'Old PIN',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                obscureText: true,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter old PIN';
                  }
                  if (value.length != 4) {
                    return 'PIN must be 4 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _newPinController,
                decoration: InputDecoration(
                  labelText: 'New PIN',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                obscureText: true,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter new PIN';
                  }
                  if (value.length != 4) {
                    return 'PIN must be 4 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _confirmPinController,
                decoration: InputDecoration(
                  labelText: 'Confirm New PIN',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                obscureText: true,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm new PIN';
                  }
                  if (value.length != 4) {
                    return 'PIN must be 4 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              
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
                  onPressed: _isProcessing ? null : _changePin,
                  child: _isProcessing
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Change PIN',
                          style: TextStyle(color: Colors.white,),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}