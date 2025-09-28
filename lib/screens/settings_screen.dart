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
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.go('/home'),
          icon: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: const Icon(Icons.arrow_back_rounded),
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16.w),
            child: IconButton(
              onPressed: () {
                _showResetDialog(context);
              },
              icon: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: const Icon(Icons.refresh_rounded),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Enhanced Profile Header
          Container(
            margin: EdgeInsets.only(bottom: 20.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 3.w,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 30.r,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person_rounded,
                            size: 30.sp,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'John Doe',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'john.doe@example.com',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.edit_rounded,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Curved bottom design
                Container(
                  height: 24.h,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.r),
                      topRight: Radius.circular(24.r),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                // Account Settings Section
                _buildSectionHeader('Account Settings'),
                _buildSettingsItem(
                  icon: Icons.person_rounded,
                  title: 'Edit Profile',
                  subtitle: 'Update your personal information',
                  onTap: () {},
                ),
                _buildSettingsItem(
                  icon: Icons.security_rounded,
                  title: 'Privacy & Security',
                  subtitle: 'Manage your privacy settings',
                  onTap: () {},
                ),
                _buildSettingsItem(
                  icon: Icons.payment_rounded,
                  title: 'Payment Settings',
                  subtitle: 'Manage payment methods and billing',
                  onTap: () {},
                ),
                
                SizedBox(height: 24.h),
                
                // App Preferences Section
                _buildSectionHeader('App Preferences'),
                _buildSwitchItem(
                  icon: Icons.notifications_rounded,
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
                  icon: Icons.dark_mode_rounded,
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
                  icon: Icons.language_rounded,
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
                  icon: Icons.attach_money_rounded,
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
                  icon: Icons.help_rounded,
                  title: 'Help Center',
                  subtitle: 'Get help and find answers',
                  onTap: () {},
                ),
                _buildSettingsItem(
                  icon: Icons.feedback_rounded,
                  title: 'Send Feedback',
                  subtitle: 'Help us improve the app',
                  onTap: () {},
                ),
                _buildSettingsItem(
                  icon: Icons.description_rounded,
                  title: 'Terms of Service',
                  subtitle: 'Read our terms and conditions',
                  onTap: () {},
                ),
                _buildSettingsItem(
                  icon: Icons.privacy_tip_rounded,
                  title: 'Privacy Policy',
                  subtitle: 'Learn about our privacy practices',
                  onTap: () {},
                ),
                
                SizedBox(height: 24.h),
                
                // App Info Section
                _buildSectionHeader('App Information'),
                _buildSettingsItem(
                  icon: Icons.info_rounded,
                  title: 'About Pipit',
                  subtitle: 'Version 1.0.0',
                  onTap: () {
                    _showAboutDialog(context);
                  },
                ),
                _buildSettingsItem(
                  icon: Icons.system_update_rounded,
                  title: 'Check for Updates',
                  subtitle: 'Keep your app up to date',
                  onTap: () {},
                ),
                
                SizedBox(height: 32.h),
                
                // Developer/Debug Section (only show in debug mode)
                if (const bool.fromEnvironment('dart.vm.product') == false) ...[
                  _buildSectionHeader('Developer Options'),
                  _buildSettingsItem(
                    icon: Icons.bug_report_rounded,
                    title: 'Debug Information',
                    subtitle: 'View debug logs and information',
                    onTap: () {},
                  ),
                  _buildSettingsItem(
                    icon: Icons.api_rounded,
                    title: 'API Settings',
                    subtitle: 'Configure API endpoints',
                    onTap: () {},
                  ),
                ],
                
                SizedBox(height: 40.h), // Extra padding at bottom
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h, top: 8.h),
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 20.h,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
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
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        leading: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 22.sp,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        trailing: Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Icon(
            Icons.chevron_right_rounded,
            color: Theme.of(context).colorScheme.primary,
            size: 20.sp,
          ),
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
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        leading: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 22.sp,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        trailing: Transform.scale(
          scale: 0.8,
          child: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Theme.of(context).colorScheme.primary,
          ),
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
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        leading: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 22.sp,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: DropdownButton<String>(
            value: value,
            underline: const SizedBox(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                onChanged(newValue);
              }
            },
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Row(
            children: [
              Icon(
                Icons.refresh_rounded,
                color: Theme.of(context).colorScheme.primary,
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              const Text('Reset Settings'),
            ],
          ),
          content: const Text('Are you sure you want to reset all settings to their default values?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _notificationsEnabled = true;
                  _darkModeEnabled = false;
                  _selectedLanguage = 'English';
                  _selectedCurrency = 'USD';
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Settings reset successfully'),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Pipit',
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2024 Nupuit Platform. All rights reserved.',
      applicationIcon: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(
          Icons.flight_takeoff_rounded,
          color: Colors.white,
          size: 32.sp,
        ),
      ),
      children: [
        SizedBox(height: 16.h),
        Text(
          'Pipit is a mobile-first Flutter application that connects freelancers with clients through the Nupuit platform, powered by Rclet API.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            height: 1.5,
          ),
        ),
        SizedBox(height: 16.h),
        Wrap(
          spacing: 8.w,
          children: [
            Chip(
              label: const Text('Flutter'),
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            Chip(
              label: const Text('Material 3'),
              backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            Chip(
              label: const Text('Rclet API'),
              backgroundColor: Theme.of(context).colorScheme.tertiary.withOpacity(0.1),
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}