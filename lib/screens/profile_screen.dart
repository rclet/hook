import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/business_services.dart';
import '../models/auth_models.dart';
import '../models/models.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AuthUser? currentUser;
  List<UpdatedGig> userGigs = [];
  List<Order> userOrders = [];
  bool isLoading = true;
  bool isEditMode = false;
  String? error;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final authService = context.read<AuthService>();
      final gigService = context.read<GigService>();
      final orderService = context.read<OrderService>();

      // Load user profile
      currentUser = await authService.getCurrentUser();

      if (currentUser != null) {
        _nameController.text = currentUser!.name;
        _phoneController.text = currentUser!.phone ?? '';

        // Load user's gigs and orders in parallel
        final futures = await Future.wait([
          gigService.getMyGigs(limit: 5),
          orderService.getMyOrders(limit: 5),
        ]);

        final gigsResponse = futures[0];
        final ordersResponse = futures[1];

        if (gigsResponse.isSuccess && gigsResponse.data != null) {
          userGigs = gigsResponse.data as List<UpdatedGig>;
        }

        if (ordersResponse.isSuccess && ordersResponse.data != null) {
          userOrders = ordersResponse.data as List<Order>;
        }
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Failed to load profile: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _updateProfile() async {
    if (currentUser == null) return;

    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final authService = context.read<AuthService>();
      final request = ProfileUpdateRequest(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim().isEmpty 
            ? null 
            : _phoneController.text.trim(),
      );

      final response = await authService.updateProfile(request);

      if (mounted) {
        if (response.isSuccess && response.data != null) {
          setState(() {
            currentUser = response.data!;
            isEditMode = false;
            isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message ?? 'Profile updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          setState(() {
            error = response.error;
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = 'Profile update failed: $e';
          isLoading = false;
        });
      }
    }
  }

  Future<void> _handleLogout() async {
    try {
      final authService = context.read<AuthService>();
      await authService.logout();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logged out successfully'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
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
          if (!isEditMode && currentUser != null)
            IconButton(
              onPressed: () {
                setState(() {
                  isEditMode = true;
                });
              },
              icon: const Icon(Icons.edit),
            ),
          if (isEditMode) ...[
            TextButton(
              onPressed: () {
                setState(() {
                  isEditMode = false;
                  // Reset form
                  if (currentUser != null) {
                    _nameController.text = currentUser!.name;
                    _phoneController.text = currentUser!.phone ?? '';
                  }
                });
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: isLoading ? null : _updateProfile,
              child: const Text('Save'),
            ),
          ],
        ],
      ),
      body: isLoading && currentUser == null
          ? const Center(child: CircularProgressIndicator())
          : error != null && currentUser == null
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48.sp,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          error!,
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16.h),
                        ElevatedButton(
                          onPressed: _loadUserData,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadUserData,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      children: [
                        // Profile Header
                        Container(
                          padding: EdgeInsets.all(24.w),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Avatar
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 50.r,
                                    backgroundColor: Theme.of(context).colorScheme.primary,
                                    backgroundImage: currentUser?.avatar != null
                                        ? NetworkImage(currentUser!.avatar!)
                                        : null,
                                    child: currentUser?.avatar == null
                                        ? Icon(
                                            Icons.person,
                                            size: 50.sp,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                  if (isEditMode)
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          // TODO: Implement avatar upload
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(8.w),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.primary,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 2,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.camera_alt,
                                            size: 16.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(height: 16.h),
                              // Name (editable in edit mode)
                              if (isEditMode)
                                TextFormField(
                                  controller: _nameController,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.headlineMedium,
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    hintText: 'Full Name',
                                  ),
                                )
                              else
                                Text(
                                  currentUser?.name ?? 'Unknown User',
                                  style: Theme.of(context).textTheme.headlineMedium,
                                ),
                              SizedBox(height: 8.h),
                              // Email
                              Text(
                                currentUser?.email ?? '',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                ),
                              ),
                              // Phone (editable in edit mode)
                              if (isEditMode) ...[
                                SizedBox(height: 16.h),
                                TextFormField(
                                  controller: _phoneController,
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.phone,
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    hintText: 'Phone Number (Optional)',
                                  ),
                                ),
                              ] else if (currentUser?.phone != null) ...[
                                SizedBox(height: 4.h),
                                Text(
                                  currentUser!.phone!,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                  ),
                                ),
                              ],
                              if (!isEditMode) ...[
                                SizedBox(height: 16.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildStatItem(context, 'Gigs', '${userGigs.length}'),
                                    _buildStatItem(context, 'Orders', '${userOrders.length}'),
                                    _buildStatItem(context, 'Joined', _formatJoinDate()),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                        if (!isEditMode) ...[
                          SizedBox(height: 24.h),
                          // Quick Actions
                          Row(
                            children: [
                              Expanded(
                                child: _buildQuickAction(
                                  context,
                                  icon: Icons.work_outline,
                                  title: 'My Gigs',
                                  count: userGigs.length,
                                  onTap: () {
                                    // TODO: Navigate to my gigs screen
                                  },
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: _buildQuickAction(
                                  context,
                                  icon: Icons.shopping_bag_outlined,
                                  title: 'Orders',
                                  count: userOrders.length,
                                  onTap: () {
                                    // TODO: Navigate to orders screen
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),
                          // Profile Options
                          _buildProfileOption(
                            context,
                            icon: Icons.work,
                            title: 'My Gigs',
                            subtitle: 'Manage your services',
                            onTap: () {},
                          ),
                          _buildProfileOption(
                            context,
                            icon: Icons.shopping_bag,
                            title: 'Orders',
                            subtitle: 'View your order history',
                            onTap: () {},
                          ),
                          _buildProfileOption(
                            context,
                            icon: Icons.star,
                            title: 'Reviews',
                            subtitle: 'See your reviews and ratings',
                            onTap: () {},
                          ),
                          _buildProfileOption(
                            context,
                            icon: Icons.payment,
                            title: 'Payments',
                            subtitle: 'Manage payment methods',
                            onTap: () {},
                          ),
                          _buildProfileOption(
                            context,
                            icon: Icons.notifications,
                            title: 'Notifications',
                            subtitle: 'Manage notification preferences',
                            onTap: () {},
                          ),
                          _buildProfileOption(
                            context,
                            icon: Icons.help,
                            title: 'Help & Support',
                            subtitle: 'Get help and contact support',
                            onTap: () {},
                          ),
                          _buildProfileOption(
                            context,
                            icon: Icons.settings,
                            title: 'Settings',
                            subtitle: 'App preferences and account settings',
                            onTap: () => context.go('/settings'),
                          ),
                          SizedBox(height: 32.h),
                          // Logout Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                _showLogoutDialog(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.error,
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              child: const Text(
                                'Logout',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                        SizedBox(height: 32.h),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAction(
    BuildContext context, {
    required IconData icon,
    required String title,
    required int count,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24.sp,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    count.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
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
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        leading: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 24.sp,
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

  String _formatJoinDate() {
    if (currentUser?.createdAt == null) return '0';
    try {
      final date = DateTime.parse(currentUser!.createdAt);
      final now = DateTime.now();
      final difference = now.difference(date).inDays;
      
      if (difference < 30) {
        return '${difference}d';
      } else if (difference < 365) {
        return '${(difference / 30).floor()}m';
      } else {
        return '${(difference / 365).floor()}y';
      }
    } catch (e) {
      return '0';
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _handleLogout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}