// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      id: json['id'] as int,
      gigId: json['gigId'] as int,
      userId: json['userId'] as int,
      sellerId: json['sellerId'] as int,
      status: json['status'] as String,
      amount: (json['amount'] as num).toDouble(),
      requirements: json['requirements'] as String?,
      notes: json['notes'] as String?,
      gig: json['gig'] == null
          ? null
          : UpdatedGig.fromJson(json['gig'] as Map<String, dynamic>),
      user: json['user'] == null
          ? null
          : AuthUser.fromJson(json['user'] as Map<String, dynamic>),
      seller: json['seller'] == null
          ? null
          : AuthUser.fromJson(json['seller'] as Map<String, dynamic>),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'gigId': instance.gigId,
      'userId': instance.userId,
      'sellerId': instance.sellerId,
      'status': instance.status,
      'amount': instance.amount,
      'requirements': instance.requirements,
      'notes': instance.notes,
      'gig': instance.gig,
      'user': instance.user,
      'seller': instance.seller,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

CreateOrderRequest _$CreateOrderRequestFromJson(Map<String, dynamic> json) =>
    CreateOrderRequest(
      gigId: json['gig_id'] as int,
      requirements: json['requirements'] as String?,
    );

Map<String, dynamic> _$CreateOrderRequestToJson(CreateOrderRequest instance) =>
    <String, dynamic>{
      'gig_id': instance.gigId,
      'requirements': instance.requirements,
    };

Notification _$NotificationFromJson(Map<String, dynamic> json) => Notification(
      id: json['id'] as int,
      userId: json['userId'] as int,
      title: json['title'] as String,
      message: json['message'] as String,
      type: json['type'] as String,
      isRead: json['isRead'] as bool,
      data: json['data'] as Map<String, dynamic>?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'message': instance.message,
      'type': instance.type,
      'isRead': instance.isRead,
      'data': instance.data,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

Payment _$PaymentFromJson(Map<String, dynamic> json) => Payment(
      id: json['id'] as int,
      orderId: json['orderId'] as int,
      userId: json['userId'] as int,
      amount: (json['amount'] as num).toDouble(),
      method: json['method'] as String,
      status: json['status'] as String,
      transactionId: json['transactionId'] as String?,
      gatewayResponse: json['gatewayResponse'] as String?,
      order: json['order'] == null
          ? null
          : Order.fromJson(json['order'] as Map<String, dynamic>),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'userId': instance.userId,
      'amount': instance.amount,
      'method': instance.method,
      'status': instance.status,
      'transactionId': instance.transactionId,
      'gatewayResponse': instance.gatewayResponse,
      'order': instance.order,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

PaymentRequest _$PaymentRequestFromJson(Map<String, dynamic> json) =>
    PaymentRequest(
      orderId: json['order_id'] as int,
      method: json['method'] as String,
      amount: (json['amount'] as num).toDouble(),
      customerPhone: json['customerPhone'] as String?,
    );

Map<String, dynamic> _$PaymentRequestToJson(PaymentRequest instance) =>
    <String, dynamic>{
      'order_id': instance.orderId,
      'method': instance.method,
      'amount': instance.amount,
      'customerPhone': instance.customerPhone,
    };

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      isActive: json['isActive'] as bool,
      gigsCount: json['gigs_count'] as int,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'description': instance.description,
      'icon': instance.icon,
      'isActive': instance.isActive,
      'gigs_count': instance.gigsCount,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

UpdatedGig _$UpdatedGigFromJson(Map<String, dynamic> json) => UpdatedGig(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      categoryId: json['categoryId'] as int,
      userId: json['userId'] as int,
      status: json['status'] as String,
      images: (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      deliveryTime: json['deliveryTime'] as int,
      revisions: json['revisions'] as int,
      category: json['category'] == null
          ? null
          : Category.fromJson(json['category'] as Map<String, dynamic>),
      user: json['user'] == null
          ? null
          : AuthUser.fromJson(json['user'] as Map<String, dynamic>),
      ordersCount: json['orders_count'] as int,
      averageRating: (json['average_rating'] as num?)?.toDouble(),
      reviewsCount: json['reviews_count'] as int,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$UpdatedGigToJson(UpdatedGig instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price,
      'categoryId': instance.categoryId,
      'userId': instance.userId,
      'status': instance.status,
      'images': instance.images,
      'tags': instance.tags,
      'deliveryTime': instance.deliveryTime,
      'revisions': instance.revisions,
      'category': instance.category,
      'user': instance.user,
      'orders_count': instance.ordersCount,
      'average_rating': instance.averageRating,
      'reviews_count': instance.reviewsCount,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

Review _$ReviewFromJson(Map<String, dynamic> json) => Review(
      id: json['id'] as int,
      gigId: json['gigId'] as int,
      userId: json['userId'] as int,
      orderId: json['orderId'] as int,
      rating: json['rating'] as int,
      comment: json['comment'] as String?,
      user: json['user'] == null
          ? null
          : AuthUser.fromJson(json['user'] as Map<String, dynamic>),
      order: json['order'] == null
          ? null
          : Order.fromJson(json['order'] as Map<String, dynamic>),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$ReviewToJson(Review instance) => <String, dynamic>{
      'id': instance.id,
      'gigId': instance.gigId,
      'userId': instance.userId,
      'orderId': instance.orderId,
      'rating': instance.rating,
      'comment': instance.comment,
      'user': instance.user,
      'order': instance.order,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };