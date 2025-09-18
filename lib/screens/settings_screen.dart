import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'English';
  String _selectedCurrency = 'USD';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          onPressed: () => context.go('/home'),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          // Account Settings Section
          _buildSectionHeader('Account Settings'),
          _buildSettingsItem(
            icon: Icons.person,
            title: 'Edit Profile',
            subtitle: 'Update your personal information',
            onTap: () {},
          ),
          _buildSettingsItem(
            icon: Icons.security,
            title: 'Privacy & Security',
            subtitle: 'Manage your privacy settings',
            onTap: () {},
          ),
          _buildSettingsItem(
            icon: Icons.payment,
            title: 'Payment Settings',
            subtitle: 'Manage payment methods and billing',
            onTap: () {},
          ),

          SizedBox(height: 24.h),

          // App Preferences Section
          _buildSectionHeader('App Preferences'),
          _buildSwitchItem(
            icon: Icons.notifications,
            title: 'Push Notifications',
            subtitle: 'Receive notifications about orders and messages',
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          _buildSwitchItem(
            icon: Icons.dark_mode,
            title: 'Dark Mode',
            subtitle: 'Switch to dark theme',
            value: _darkModeEnabled,
            onChanged: (value) {
              setState(() {
                _darkModeEnabled = value;
              });
            },
          ),
          _buildDropdownItem(
            icon: Icons.language,
            title: 'Language',
            subtitle: 'Choose your preferred language',
            value: _selectedLanguage,
            items: ['English', 'বাংলা', 'العربية', 'Español'],
            onChanged: (value) {
              setState(() {
                _selectedLanguage = value;
              });
            },
          ),
          _buildDropdownItem(
            icon: Icons.attach_money,
            title: 'Currency',
            subtitle: 'Select default currency',
            value: _selectedCurrency,
            items: ['USD', 'BDT', 'EUR', 'GBP'],
            onChanged: (value) {
              setState(() {
                _selectedCurrency = value;
              });
            },
          ),

          SizedBox(height: 24.h),

          // Support Section
          _buildSectionHeader('Support & Legal'),
          _buildSettingsItem(
            icon: Icons.help,
            title: 'Help Center',
            subtitle: 'Get help and find answers',
            onTap: () {},
          ),
          _buildSettingsItem(
            icon: Icons.feedback,
            title: 'Send Feedback',
            subtitle: 'Help us improve the app',
            onTap: () {},
          ),
          _buildSettingsItem(
            icon: Icons.description,
            title: 'Terms of Service',
            subtitle: 'Read our terms and conditions',
            onTap: () {},
          ),
          _buildSettingsItem(
            icon: Icons.privacy_tip,
            title: 'Privacy Policy',
            subtitle: 'Learn about our privacy practices',
            onTap: () {},
          ),

          SizedBox(height: 24.h),

          // App Info Section
          _buildSectionHeader('App Information'),
          _buildSettingsItem(
            icon: Icons.info,
            title: 'About Pipit',
            subtitle: 'Version 1.0.0',
            onTap: () {
              _showAboutDialog(context);
            },
          ),
          _buildSettingsItem(
            icon: Icons.update,
            title: 'Check for Updates',
            subtitle: 'Keep your app up to date',
            onTap: () {},
          ),

          SizedBox(height: 32.h),

          // Developer/Debug Section (only show in debug mode)
          if (const bool.fromEnvironment('dart.vm.product') == false) ...[
            _buildSectionHeader('Developer Options'),
            _buildSettingsItem(
              icon: Icons.bug_report,
              title: 'Debug Information',
              subtitle: 'View debug logs and information',
              onTap: () {},
            ),
            _buildSettingsItem(
              icon: Icons.api,
              title: 'API Settings',
              subtitle: 'Configure API endpoints',
              onTap: () {},
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h, top: 8.h),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        leading: Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 20.sp,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        leading: Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 20.sp,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildDropdownItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        leading: Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 20.sp,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: DropdownButton<String>(
          value: value,
          underline: const SizedBox(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Pipit',
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2024 Nupuit Platform. All rights reserved.',
      children: [
        SizedBox(height: 16.h),
        Text(
          'Pipit is a mobile-first Flutter application that connects freelancers with clients through the Nupuit platform, powered by Rclet API.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}