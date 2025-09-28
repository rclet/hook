import 'package:json_annotation/json_annotation.dart';
import 'auth_models.dart';
import 'api_response.dart'; // Import existing Gig model

part 'models.g.dart';

@JsonSerializable()
class Order {
  final int id;
  final int gigId;
  final int userId;
  final int sellerId;
  final String status;
  final double amount;
  final String? requirements;
  final String? notes;
  final UpdatedGig? gig;
  final AuthUser? user;
  final AuthUser? seller;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  const Order({
    required this.id,
    required this.gigId,
    required this.userId,
    required this.sellerId,
    required this.status,
    required this.amount,
    this.requirements,
    this.notes,
    this.gig,
    this.user,
    this.seller,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);
}

@JsonSerializable()
class CreateOrderRequest {
  @JsonKey(name: 'gig_id')
  final int gigId;
  final String? requirements;

  const CreateOrderRequest({
    required this.gigId,
    this.requirements,
  });

  factory CreateOrderRequest.fromJson(Map<String, dynamic> json) => 
      _$CreateOrderRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreateOrderRequestToJson(this);
}

@JsonSerializable()
class Notification {
  final int id;
  final int userId;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final Map<String, dynamic>? data;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  const Notification({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    this.data,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) => 
      _$NotificationFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationToJson(this);
}

@JsonSerializable()
class Payment {
  final int id;
  final int orderId;
  final int userId;
  final double amount;
  final String method; // bkash, card, etc
  final String status; // pending, completed, failed, refunded
  final String? transactionId;
  final String? gatewayResponse;
  final Order? order;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  const Payment({
    required this.id,
    required this.orderId,
    required this.userId,
    required this.amount,
    required this.method,
    required this.status,
    this.transactionId,
    this.gatewayResponse,
    this.order,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => 
      _$PaymentFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentToJson(this);
}

@JsonSerializable()
class PaymentRequest {
  @JsonKey(name: 'order_id')
  final int orderId;
  final String method;
  final double amount;
  final String? customerPhone;

  const PaymentRequest({
    required this.orderId,
    required this.method,
    required this.amount,
    this.customerPhone,
  });

  factory PaymentRequest.fromJson(Map<String, dynamic> json) => 
      _$PaymentRequestFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentRequestToJson(this);
}

@JsonSerializable()
class Category {
  final int id;
  final String name;
  final String slug;
  final String? description;
  final String? icon;
  final bool isActive;
  @JsonKey(name: 'gigs_count')
  final int gigsCount;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  const Category({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.icon,
    required this.isActive,
    required this.gigsCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) => 
      _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}

// Update the existing Gig model to match backend API structure
@JsonSerializable()
class UpdatedGig {
  final int id;
  final String title;
  final String description;
  final double price;
  final int categoryId;
  final int userId;
  final String status;
  final List<String> images;
  final List<String> tags;
  final int deliveryTime;
  final int revisions;
  final Category? category;
  final AuthUser? user;
  @JsonKey(name: 'orders_count')
  final int ordersCount;
  @JsonKey(name: 'average_rating')
  final double? averageRating;
  @JsonKey(name: 'reviews_count')
  final int reviewsCount;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  const UpdatedGig({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.userId,
    required this.status,
    required this.images,
    required this.tags,
    required this.deliveryTime,
    required this.revisions,
    this.category,
    this.user,
    required this.ordersCount,
    this.averageRating,
    required this.reviewsCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UpdatedGig.fromJson(Map<String, dynamic> json) => 
      _$UpdatedGigFromJson(json);
  Map<String, dynamic> toJson() => _$UpdatedGigToJson(this);
}

@JsonSerializable()
class Review {
  final int id;
  final int gigId;
  final int userId;
  final int orderId;
  final int rating;
  final String? comment;
  final AuthUser? user;
  final Order? order;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  const Review({
    required this.id,
    required this.gigId,
    required this.userId,
    required this.orderId,
    required this.rating,
    this.comment,
    this.user,
    this.order,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) => 
      _$ReviewFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewToJson(this);
}