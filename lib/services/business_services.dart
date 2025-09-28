import '../models/api_response.dart';
import '../models/models.dart';
import '../models/auth_models.dart';
import 'enhanced_api_service.dart';

class GigService {
  final ApiService _apiService;

  GigService(this._apiService);

  // Get all gigs with optional filters
  Future<ApiResponse<List<UpdatedGig>>> getGigs({
    int? categoryId,
    String? search,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    String? sortOrder,
    int page = 1,
    int perPage = 20,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };

    if (categoryId != null) queryParams['category_id'] = categoryId;
    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    if (minPrice != null) queryParams['min_price'] = minPrice;
    if (maxPrice != null) queryParams['max_price'] = maxPrice;
    if (sortBy != null) queryParams['sort_by'] = sortBy;
    if (sortOrder != null) queryParams['sort_order'] = sortOrder;

    return await _apiService.get<List<UpdatedGig>>(
      '/gigs',
      queryParams: queryParams,
      fromJson: (json) {
        final gigsList = json['data'] as List? ?? json['gigs'] as List? ?? [];
        return gigsList
            .map((g) => UpdatedGig.fromJson(g as Map<String, dynamic>))
            .toList();
      },
    );
  }

  // Get single gig by ID
  Future<ApiResponse<UpdatedGig>> getGig(int id) async {
    return await _apiService.get<UpdatedGig>(
      '/gigs/$id',
      fromJson: (json) => UpdatedGig.fromJson(json),
    );
  }

  // Get gigs by category
  Future<ApiResponse<List<UpdatedGig>>> getGigsByCategory(
    int categoryId, {
    int page = 1,
    int perPage = 20,
  }) async {
    return getGigs(
      categoryId: categoryId,
      page: page,
      perPage: perPage,
    );
  }

  // Search gigs
  Future<ApiResponse<List<UpdatedGig>>> searchGigs(
    String query, {
    int page = 1,
    int perPage = 20,
  }) async {
    return getGigs(
      search: query,
      page: page,
      perPage: perPage,
    );
  }

  // Get featured gigs
  Future<ApiResponse<List<UpdatedGig>>> getFeaturedGigs({
    int limit = 10,
  }) async {
    return await _apiService.get<List<UpdatedGig>>(
      '/gigs/featured',
      queryParams: {'limit': limit},
      fromJson: (json) {
        final gigsList = json['data'] as List? ?? json['gigs'] as List? ?? [];
        return gigsList
            .map((g) => UpdatedGig.fromJson(g as Map<String, dynamic>))
            .toList();
      },
    );
  }

  // Get user's own gigs
  Future<ApiResponse<List<UpdatedGig>>> getMyGigs({
    int page = 1,
    int perPage = 20,
  }) async {
    return await _apiService.get<List<UpdatedGig>>(
      '/gigs/my-gigs',
      queryParams: {
        'page': page,
        'per_page': perPage,
      },
      fromJson: (json) {
        final gigsList = json['data'] as List? ?? json['gigs'] as List? ?? [];
        return gigsList
            .map((g) => UpdatedGig.fromJson(g as Map<String, dynamic>))
            .toList();
      },
    );
  }

  // Get gig reviews
  Future<ApiResponse<List<Review>>> getGigReviews(
    int gigId, {
    int page = 1,
    int perPage = 10,
  }) async {
    return await _apiService.get<List<Review>>(
      '/gigs/$gigId/reviews',
      queryParams: {
        'page': page,
        'per_page': perPage,
      },
      fromJson: (json) {
        final reviewsList = json['data'] as List? ?? json['reviews'] as List? ?? [];
        return reviewsList
            .map((r) => Review.fromJson(r as Map<String, dynamic>))
            .toList();
      },
    );
  }
}

class CategoryService {
  final ApiService _apiService;

  CategoryService(this._apiService);

  // Get all categories
  Future<ApiResponse<List<Category>>> getCategories() async {
    return await _apiService.get<List<Category>>(
      '/categories',
      fromJson: (json) {
        final categoriesList = json['data'] as List? ?? json['categories'] as List? ?? [];
        return categoriesList
            .map((c) => Category.fromJson(c as Map<String, dynamic>))
            .toList();
      },
    );
  }

  // Get single category
  Future<ApiResponse<Category>> getCategory(int id) async {
    return await _apiService.get<Category>(
      '/categories/$id',
      fromJson: (json) => Category.fromJson(json),
    );
  }
}

class OrderService {
  final ApiService _apiService;

  OrderService(this._apiService);

  // Create new order
  Future<ApiResponse<Order>> createOrder(CreateOrderRequest request) async {
    return await _apiService.post<Order>(
      '/orders',
      data: request.toJson(),
      fromJson: (json) => Order.fromJson(json),
    );
  }

  // Get user orders
  Future<ApiResponse<List<Order>>> getMyOrders({
    String? status,
    int page = 1,
    int perPage = 20,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };
    
    if (status != null) queryParams['status'] = status;

    return await _apiService.get<List<Order>>(
      '/orders/my-orders',
      queryParams: queryParams,
      fromJson: (json) {
        final ordersList = json['data'] as List? ?? json['orders'] as List? ?? [];
        return ordersList
            .map((o) => Order.fromJson(o as Map<String, dynamic>))
            .toList();
      },
    );
  }

  // Get orders as seller
  Future<ApiResponse<List<Order>>> getSellerOrders({
    String? status,
    int page = 1,
    int perPage = 20,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };
    
    if (status != null) queryParams['status'] = status;

    return await _apiService.get<List<Order>>(
      '/orders/seller-orders',
      queryParams: queryParams,
      fromJson: (json) {
        final ordersList = json['data'] as List? ?? json['orders'] as List? ?? [];
        return ordersList
            .map((o) => Order.fromJson(o as Map<String, dynamic>))
            .toList();
      },
    );
  }

  // Get single order
  Future<ApiResponse<Order>> getOrder(int id) async {
    return await _apiService.get<Order>(
      '/orders/$id',
      fromJson: (json) => Order.fromJson(json),
    );
  }

  // Update order status
  Future<ApiResponse<Order>> updateOrderStatus(int id, String status) async {
    return await _apiService.put<Order>(
      '/orders/$id/status',
      data: {'status': status},
      fromJson: (json) => Order.fromJson(json),
    );
  }
}

class NotificationService {
  final ApiService _apiService;

  NotificationService(this._apiService);

  // Get user notifications
  Future<ApiResponse<List<Notification>>> getNotifications({
    bool? onlyUnread,
    int page = 1,
    int perPage = 20,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };
    
    if (onlyUnread != null) queryParams['only_unread'] = onlyUnread;

    return await _apiService.get<List<Notification>>(
      '/notifications',
      queryParams: queryParams,
      fromJson: (json) {
        final notificationsList = json['data'] as List? ?? json['notifications'] as List? ?? [];
        return notificationsList
            .map((n) => Notification.fromJson(n as Map<String, dynamic>))
            .toList();
      },
    );
  }

  // Mark notification as read
  Future<ApiResponse<Notification>> markAsRead(int id) async {
    return await _apiService.put<Notification>(
      '/notifications/$id/mark-read',
      fromJson: (json) => Notification.fromJson(json),
    );
  }

  // Mark all notifications as read
  Future<ApiResponse<void>> markAllAsRead() async {
    return await _apiService.put<void>('/notifications/mark-all-read');
  }

  // Get unread notifications count
  Future<ApiResponse<int>> getUnreadCount() async {
    return await _apiService.get<int>(
      '/notifications/unread-count',
      fromJson: (json) => json['count'] as int,
    );
  }
}

class PaymentService {
  final ApiService _apiService;

  PaymentService(this._apiService);

  // Create payment
  Future<ApiResponse<Payment>> createPayment(PaymentRequest request) async {
    return await _apiService.post<Payment>(
      '/payments',
      data: request.toJson(),
      fromJson: (json) => Payment.fromJson(json),
    );
  }

  // Get payment details
  Future<ApiResponse<Payment>> getPayment(int id) async {
    return await _apiService.get<Payment>(
      '/payments/$id',
      fromJson: (json) => Payment.fromJson(json),
    );
  }

  // Get user payments
  Future<ApiResponse<List<Payment>>> getMyPayments({
    String? status,
    int page = 1,
    int perPage = 20,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };
    
    if (status != null) queryParams['status'] = status;

    return await _apiService.get<List<Payment>>(
      '/payments/my-payments',
      queryParams: queryParams,
      fromJson: (json) {
        final paymentsList = json['data'] as List? ?? json['payments'] as List? ?? [];
        return paymentsList
            .map((p) => Payment.fromJson(p as Map<String, dynamic>))
            .toList();
      },
    );
  }

  // Process bKash payment (demo/test)
  Future<ApiResponse<Map<String, dynamic>>> processBkashPayment({
    required int orderId,
    required double amount,
    required String customerPhone,
  }) async {
    return await _apiService.post<Map<String, dynamic>>(
      '/payments/bkash/create',
      data: {
        'order_id': orderId,
        'amount': amount,
        'customer_phone': customerPhone,
      },
      fromJson: (json) => json,
    );
  }

  // Execute bKash payment
  Future<ApiResponse<Map<String, dynamic>>> executeBkashPayment({
    required String paymentId,
  }) async {
    return await _apiService.post<Map<String, dynamic>>(
      '/payments/bkash/execute',
      data: {'payment_id': paymentId},
      fromJson: (json) => json,
    );
  }

  // Query bKash payment
  Future<ApiResponse<Map<String, dynamic>>> queryBkashPayment({
    required String paymentId,
  }) async {
    return await _apiService.post<Map<String, dynamic>>(
      '/payments/bkash/query',
      data: {'payment_id': paymentId},
      fromJson: (json) => json,
    );
  }
}