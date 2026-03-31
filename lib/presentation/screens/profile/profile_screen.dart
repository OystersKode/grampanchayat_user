import 'package:flutter/material.dart';
import '../../widgets/sidebar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5E0006),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Citizen Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.1),
                side: BorderSide(color: Colors.white.withOpacity(0.2)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              child: const Text(
                'EN/KN',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
      drawer: const AppSidebar(),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Profile Identity Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF2E1),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuAilXtv1yGO3Gm3vZOGmkWmaHfs8YeczM2ZxhV_CJicr3-6IQPnEZm-6UY4hV6PT3lkIzi1tPCm6poMrQP-hhVcYXj_TPRgUmEmURiEptrDnrIicPBnGMHuQs1G0ALo3hC98XsCFfuwy_I4MTpktXBV7DZifGrwxIZOJJV509dup-_6c2ujHSdWo4P5Cc9k9oxUvOdvZfPRGJlmyoPGyIkbVmV834MB4sQAQYJBBIBblmSTh-nMLOI2rNWRarAZcR5DbebUaGOZtiE',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'MEMBER SINCE 2018',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: Color(0xFF653D1E),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Manjunath Rao',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF370002),
                  ),
                ),
                const Text(
                  'Citizen / Farmer',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFBC0006),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Edit Profile'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC40C0C),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Details Grid
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  icon: Icons.location_on,
                  label: 'Village',
                  value: 'Shivapura',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoCard(
                  icon: Icons.language,
                  label: 'Language Preference',
                  value: 'Kannada / English',
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          
          const Text(
            'Settings & Preferences',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF241A06),
            ),
          ),
          const SizedBox(height: 16),
          
          // Settings Section
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFF2E1),
              borderRadius: BorderRadius.circular(24),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                _buildSettingsItem(
                  icon: Icons.notifications,
                  title: 'Notification Settings',
                  subtitle: 'Manage alerts for news and events',
                ),
                _buildSettingsItem(
                  icon: Icons.text_fields,
                  title: 'Accessibility Options',
                  subtitle: 'Adjust font size and contrast',
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5E0BF),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text('Medium', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
                _buildSettingsItem(
                  icon: Icons.security,
                  title: 'Privacy & Security',
                  subtitle: 'Data usage and account security',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Help Section
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF370002),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Need assistance?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Contact the Shivapura Panchayat helpdesk for profile-related queries.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Get Support'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBC0006),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required IconData icon, required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF5E0BF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF370002), size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF653D1E), fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF241A06)),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({required IconData icon, required String title, required String subtitle, Widget? trailing}) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFBC0006)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF653D1E))),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null) trailing,
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: Color(0xFF8B716E)),
        ],
      ),
      onTap: () {},
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    );
  }
}
