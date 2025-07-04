import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  // Social media URLs - replace with your actual links
  final String whatsappUrl = "https://wa.me/yourwhatsappnumber";
  final String facebookUrl = "https://facebook.com/yourpage";
  final String linkedinUrl = "https://linkedin.com/company/yourcompany";
  final String tiktokUrl = "https://tiktok.com/@yourusername";
  final String phoneNumber = "tel:+256712345678";

  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Get in touch with us',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildContactCard(
              icon: Icons.phone,
              title: 'Call Us',
              subtitle: '+256 712 345 678',
              color: Colors.green,
              onTap: () => _launchUrl(phoneNumber),
            ),
            const SizedBox(height: 16),
            _buildContactCard(
              icon: Icons.chat,
              title: 'WhatsApp',
              subtitle: 'Chat with us on WhatsApp',
              color: Colors.green,
              onTap: () => _launchUrl(whatsappUrl),
            ),
            const SizedBox(height: 16),
            _buildContactCard(
              icon: Icons.facebook,
              title: 'Facebook',
              subtitle: 'Connect with us on Facebook',
              color: Colors.blue[800]!,
              onTap: () => _launchUrl(facebookUrl),
            ),
            const SizedBox(height: 16),
            _buildContactCard(
              icon: Icons.work,
              title: 'LinkedIn',
              subtitle: 'Follow us on LinkedIn',
              color: Colors.blue[700]!,
              onTap: () => _launchUrl(linkedinUrl),
            ),
            const SizedBox(height: 16),
            _buildContactCard(
              icon: Icons.music_note,
              title: 'TikTok',
              subtitle: 'Follow us on TikTok',
              color: Colors.black,
              onTap: () => _launchUrl(tiktokUrl),
            ),
            const SizedBox(height: 32),
            const Text(
              'Our Office',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const ListTile(
              leading: Icon(Icons.location_on, color: Color(0xFF2563EB)),
              title: Text('Main Office'),
              subtitle: Text('123 Boda Street, Kampala, Uganda'),
            ),
            const ListTile(
              leading: Icon(Icons.access_time, color: Color(0xFF2563EB)),
              title: Text('Working Hours'),
              subtitle: Text('Monday - Friday: 8:00 AM - 5:00 PM\nSaturday: 9:00 AM - 2:00 PM'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}