import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../services/enhanced_api_service.dart';
import '../services/auth_service.dart';
import '../models/api_response.dart';
import '../widgets/gig_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Gig> gigs = [];
  bool isLoading = true;
  String? error;
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    _loadGigs();
    _checkAdminStatus();
  }

  Future<void> _checkAdminStatus() async {
    try {
      final authService = context.read<AuthService>();
      final admin = await authService.isAdmin();
      setState(() {
        isAdmin = admin;
      });
    } catch (e) {
      // Ignore error
    }
  }

  Future<void> _loadGigs() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final apiService = context.read<ApiService>();
      final response = await apiService.get<List<Gig>>(
        '/gigs',
        fromJson: (json) {
          final gigsList = json['gigs'] as List;
          return gigsList.map((g) => Gig.fromJson(g as Map<String, dynamic>)).toList();
        },
      );

      if (response.isSuccess && response.data != null) {
        setState(() {
          gigs = response.data!;
          isLoading = false;
        });
      } else {
        setState(() {
          error = response.error ?? 'Failed to load gigs';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Network error: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.flight_takeoff_rounded,
              size: 28.sp,
              color: Colors.white,
            ),
            SizedBox(width: 8.w),
            const Text('Pipit'),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        actions: [
          if (isAdmin)
            Container(
              margin: EdgeInsets.only(right: 8.w),
              child: IconButton(
                onPressed: () => context.go('/admin'),
                icon: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: const Icon(Icons.admin_panel_settings_rounded),
                ),
              ),
            ),
          Container(
            margin: EdgeInsets.only(right: 8.w),
            child: IconButton(
              onPressed: () => context.go('/profile'),
              icon: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: const Icon(Icons.person_rounded),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 16.w),
            child: IconButton(
              onPressed: () => context.go('/settings'),
              icon: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: const Icon(Icons.settings_rounded),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadGigs,
        child: CustomScrollView(
          slivers: [
            // Enhanced Hero Section
            SliverToBoxAdapter(
              child: Container(
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16.h),
                          Text(
                            'Find Your Perfect\nFreelancer',
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              height: 1.2,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            'Discover amazing gigs from talented professionals\nacross various categories',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                              height: 1.4,
                            ),
                          ),
                          SizedBox(height: 24.h),
                          
                          // Enhanced Search Bar
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'What service are you looking for?',
                                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                                prefixIcon: Container(
                                  margin: EdgeInsets.all(12.w),
                                  child: Icon(
                                    Icons.search_rounded,
                                    color: Theme.of(context).colorScheme.primary,
                                    size: 24.sp,
                                  ),
                                ),
                                suffixIcon: Container(
                                  margin: EdgeInsets.all(8.w),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Handle search
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context).colorScheme.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12.r),
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                                    ),
                                    child: const Text(
                                      'Search',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 18.h,
                                ),
                              ),
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
            ),
                  ],
                ),
              ),
            ),
            
            // Categories Section
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Categories',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    SizedBox(height: 12.h),
                    SizedBox(
                      height: 100.h,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildCategoryCard('Design', Icons.palette),
                          _buildCategoryCard('Development', Icons.code),
                          _buildCategoryCard('Writing', Icons.edit),
                          _buildCategoryCard('Marketing', Icons.campaign),
                          _buildCategoryCard('Video', Icons.videocam),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Gigs Section
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  'Featured Gigs',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),

            // Gigs List
            if (isLoading)
              SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.w),
                    child: const CircularProgressIndicator(),
                  ),
                ),
              )
            else if (error != null)
              SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.w),
                    child: Column(
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
                          onPressed: _loadGigs,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index < gigs.length) {
                      return GigCard(gig: gigs[index]);
                    }
                    return null;
                  },
                  childCount: gigs.length,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String title, IconData icon) {
    return Container(
      width: 80.w,
      margin: EdgeInsets.only(right: 12.w),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 32.sp,
            color: Theme.of(context).colorScheme.primary,
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            style: Theme.of(context).textTheme.labelMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}