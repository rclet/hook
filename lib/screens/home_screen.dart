import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
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

  @override
  void initState() {
    super.initState();
    _loadGigs();
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
        title: const Text('Pipit'),
        actions: [
          IconButton(
            onPressed: () => context.go('/profile'),
            icon: const Icon(Icons.person),
          ),
          IconButton(
            onPressed: () => context.go('/settings'),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadGigs,
        child: CustomScrollView(
          slivers: [
            // Hero Section
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(16.w),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to Pipit',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Discover amazing gigs from talented freelancers',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search for gigs...',
                          prefixIcon: const Icon(Icons.search),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
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