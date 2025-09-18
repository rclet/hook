import 'package:flutter_test/flutter_test.dart';
import 'package:pipit/models/api_response.dart';

void main() {
  group('User Model Tests', () {
    test('User.fromJson should parse JSON correctly', () {
      final json = {
        'id': '123',
        'name': 'John Doe',
        'email': 'john@example.com',
        'avatar': 'https://example.com/avatar.jpg',
        'created_at': '2024-01-01T00:00:00.000Z',
      };

      final user = User.fromJson(json);

      expect(user.id, '123');
      expect(user.name, 'John Doe');
      expect(user.email, 'john@example.com');
      expect(user.avatar, 'https://example.com/avatar.jpg');
      expect(user.createdAt, DateTime.parse('2024-01-01T00:00:00.000Z'));
    });

    test('User.toJson should serialize correctly', () {
      final user = User(
        id: '123',
        name: 'John Doe',
        email: 'john@example.com',
        avatar: 'https://example.com/avatar.jpg',
        createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
      );

      final json = user.toJson();

      expect(json['id'], '123');
      expect(json['name'], 'John Doe');
      expect(json['email'], 'john@example.com');
      expect(json['avatar'], 'https://example.com/avatar.jpg');
      expect(json['created_at'], '2024-01-01T00:00:00.000Z');
    });
  });

  group('Gig Model Tests', () {
    test('Gig.fromJson should parse JSON correctly', () {
      final json = {
        'id': 'gig123',
        'title': 'Test Gig',
        'description': 'A test gig description',
        'price': 50.0,
        'category': 'Design',
        'seller': {
          'id': '123',
          'name': 'John Doe',
          'email': 'john@example.com',
          'avatar': null,
          'created_at': '2024-01-01T00:00:00.000Z',
        },
        'images': ['image1.jpg', 'image2.jpg'],
        'created_at': '2024-01-01T00:00:00.000Z',
      };

      final gig = Gig.fromJson(json);

      expect(gig.id, 'gig123');
      expect(gig.title, 'Test Gig');
      expect(gig.description, 'A test gig description');
      expect(gig.price, 50.0);
      expect(gig.category, 'Design');
      expect(gig.seller.name, 'John Doe');
      expect(gig.images.length, 2);
      expect(gig.images, ['image1.jpg', 'image2.jpg']);
    });

    test('Gig.toJson should serialize correctly', () {
      final seller = User(
        id: '123',
        name: 'John Doe',
        email: 'john@example.com',
        createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
      );

      final gig = Gig(
        id: 'gig123',
        title: 'Test Gig',
        description: 'A test gig description',
        price: 50.0,
        category: 'Design',
        seller: seller,
        images: ['image1.jpg', 'image2.jpg'],
        createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
      );

      final json = gig.toJson();

      expect(json['id'], 'gig123');
      expect(json['title'], 'Test Gig');
      expect(json['price'], 50.0);
      expect(json['category'], 'Design');
      expect(json['seller']['name'], 'John Doe');
      expect(json['images'], ['image1.jpg', 'image2.jpg']);
    });
  });
}