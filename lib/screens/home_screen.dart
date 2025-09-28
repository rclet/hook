import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../services/business_services.dart';
import '../services/auth_service.dart';
import '../models/models.dart';
import '../models/auth_models.dart';
import '../widgets/gig_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<UpdatedGig> gigs = [];
  List<Category> categories = [];
  AuthUser? currentUser;
  bool isLoading = true;
  String? error;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      // Load user profile
      final authService = context.read<AuthService>();
      currentUser = await authService.getCurrentUser();

      // Load featured gigs and categories in parallel
      final futures = await Future.wait([
        context.read<GigService>().getFeaturedGigs(limit: 10),
        context.read<CategoryService>().getCategories(),
      ]);

      if (mounted) {
        final gigsResponse = futures[0];
        final categoriesResponse = futures[1];

        if (gigsResponse.isSuccess && gigsResponse.data != null) {
          gigs = gigsResponse.data as List<UpdatedGig>;
        } else {
          error = gigsResponse.error ?? 'Failed to load gigs';
        }

        if (categoriesResponse.isSuccess && categoriesResponse.data != null) {
          categories = categoriesResponse.data as List<Category>;
        }

        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = 'Network error: $e';
          isLoading = false;
        });
      }
    }
  }

  Future<void> _searchGigs(String query) async {
    if (query.trim().isEmpty) {
      _loadInitialData();
      return;
    }

    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final gigService = context.read<GigService>();
      final response = await gigService.searchGigs(query.trim());

      if (mounted) {
        if (response.isSuccess && response.data != null) {
          setState(() {
            gigs = response.data!;
            isLoading = false;
          });
        } else {
          setState(() {
            error = response.error ?? 'Search failed';
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = 'Search error: $e';
          isLoading = false;
        });
      }
    }
  }

  Future<void> _loadGigsByCategory(int categoryId) async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final gigService = context.read<GigService>();
      final response = await gigService.getGigsByCategory(categoryId);

      if (mounted) {
        if (response.isSuccess && response.data != null) {
          setState(() {
            gigs = response.data!;
            isLoading = false;
          });
        } else {
          setState(() {
            error = response.error ?? 'Failed to load category gigs';
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = 'Network error: $e';
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
        title: const Text('Pipit'),
        actions: [
          IconButton(
            onPressed: () => context.go('/profile'),
            icon: const Icon(Icons.person),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'profile':
                  context.go('/profile');
                  break;
                case 'settings':
                  context.go('/settings');
                  break;
                case 'logout':
                  _handleLogout();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Profile'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.logout, color: Colors.red),
                  title: Text('Logout', style: TextStyle(color: Colors.red)),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadInitialData,
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
                    // Welcome message
                    if (currentUser != null) ...[
                      Text(
                        'Welcome back, ${currentUser!.name.split(' ').first}!',
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
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
                    ] else ...[
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
                    ],
                    SizedBox(height: 16.h),
                    
                    // Search bar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search for gigs...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    _loadInitialData();
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                        ),
                        onSubmitted: _searchGigs,
                        onChanged: (value) {
                          setState(() {}); // Rebuild to show/hide clear button
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Categories Section
            if (categories.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Categories',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          TextButton(
                            onPressed: _loadInitialData,
                            child: const Text('Show All'),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      SizedBox(
                        height: 100.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            return _buildCategoryCard(category);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // Gigs Section Header
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _searchController.text.isNotEmpty 
                          ? 'Search Results' 
                          : 'Featured Gigs',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    if (gigs.isNotEmpty && _searchController.text.isEmpty)
                      TextButton(
                        onPressed: () {
                          // TODO: Navigate to all gigs screen
                        },
                        child: const Text('View All'),
                      ),
                  ],
                ),
              ),
            ),

            // Loading/Error/Gigs List
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
                          onPressed: _loadInitialData,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else if (gigs.isEmpty)
              SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.w),
                    child: Column(
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 48.sp,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          _searchController.text.isNotEmpty
                              ? 'No gigs found for "${_searchController.text}"'
                              : 'No gigs available',
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
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
                      return UpdatedGigCard(gig: gigs[index]);
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

  Widget _buildCategoryCard(Category category) {
    return GestureDetector(
      onTap: () => _loadGigsByCategory(category.id),
      child: Container(
        width: 90.w,
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
            // Use category icon if available, otherwise use default
            Icon(
              _getCategoryIcon(category.name),
              size: 32.sp,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(height: 8.h),
            Text(
              category.name,
              style: Theme.of(context).textTheme.labelMedium,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (category.gigsCount > 0) ...[
              SizedBox(height: 2.h),
              Text(
                '${category.gigsCount} gigs',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.grey[600],
                  fontSize: 10.sp,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'design':
        return Icons.palette;
      case 'development':
      case 'programming':
        return Icons.code;
      case 'writing':
        return Icons.edit;
      case 'marketing':
        return Icons.campaign;
      case 'video':
        return Icons.videocam;
      case 'music':
        return Icons.music_note;
      case 'business':
        return Icons.business;
      case 'lifestyle':
        return Icons.lifestyle;
      default:
        return Icons.work;
    }
  }
}