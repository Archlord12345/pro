import 'package:flutter/material.dart';

class Review {
  final String id;
  final String productId;
  final String userId;
  final String userName;
  final double rating; // 1.0 to 5.0
  final String comment;
  final DateTime timestamp;

  const Review({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.timestamp,
  });

  Review copyWith({
    String? id,
    String? productId,
    String? userId,
    String? userName,
    double? rating,
    String? comment,
    DateTime? timestamp,
  }) {
    return Review(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  // For Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': productId,
      'user_id': userId,
      'user_name': userName,
      'rating': rating,
      'comment': comment,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  // From Firestore
  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'] ?? '',
      productId: map['product_id'] ?? '',
      userId: map['user_id'] ?? '',
      userName: map['user_name'] ?? '',
      rating: map['rating']?.toDouble() ?? 0.0,
      comment: map['comment'] ?? '',
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
    );
  }
}

// Mock Reviews
final List<Review> proReviews = [
  Review(
    id: '1',
    productId: '1',
    userId: 'user1',
    userName: 'Jean Dupont',
    rating: 5.0,
    comment: 'Qualité exceptionnelle ! La personnalisation est parfaite.',
    timestamp: DateTime.now().subtract(const Duration(days: 5)),
  ),
  Review(
    id: '2',
    productId: '1',
    userId: 'user2',
    userName: 'Marie Claire',
    rating: 4.5,
    comment: 'Très bon rapport qualité-prix. Livraison rapide.',
    timestamp: DateTime.now().subtract(const Duration(days: 3)),
  ),
  Review(
    id: '3',
    productId: '2',
    userId: 'user3',
    userName: 'Paul Martin',
    rating: 4.0,
    comment: 'Mug très résistant et design sympa.',
    timestamp: DateTime.now().subtract(const Duration(days: 1)),
  ),
];
