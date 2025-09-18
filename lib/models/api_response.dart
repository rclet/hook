class ApiResponse<T> {
  final T? data;
  final String? message;
  final bool isSuccess;
  final String? error;

  const ApiResponse._({
    this.data,
    this.message,
    required this.isSuccess,
    this.error,
  });

  factory ApiResponse.success(T? data, [String? message]) {
    return ApiResponse._(
      data: data,
      message: message,
      isSuccess: true,
    );
  }

  factory ApiResponse.error(String error) {
    return ApiResponse._(
      error: error,
      isSuccess: false,
    );
  }

  bool get hasError => !isSuccess;
}

class User {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class Gig {
  final String id;
  final String title;
  final String description;
  final double price;
  final String category;
  final User seller;
  final List<String> images;
  final DateTime createdAt;

  const Gig({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.seller,
    required this.images,
    required this.createdAt,
  });

  factory Gig.fromJson(Map<String, dynamic> json) {
    return Gig(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String,
      seller: User.fromJson(json['seller'] as Map<String, dynamic>),
      images: List<String>.from(json['images'] as List),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'category': category,
      'seller': seller.toJson(),
      'images': images,
      'created_at': createdAt.toIso8601String(),
    };
  }
}