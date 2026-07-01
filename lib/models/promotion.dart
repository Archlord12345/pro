import 'package:flutter/material.dart';

class Promotion {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isActive;

  const Promotion({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.startDate,
    this.endDate,
    this.isActive = true,
  });

  Promotion copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
  }) {
    return Promotion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
    );
  }

  // For Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'start_date': startDate?.millisecondsSinceEpoch,
      'end_date': endDate?.millisecondsSinceEpoch,
      'is_active': isActive,
    };
  }

  // From Firestore
  factory Promotion.fromMap(Map<String, dynamic> map) {
    return Promotion(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['image_url'] ?? '',
      startDate: map['start_date'] != null ? DateTime.fromMillisecondsSinceEpoch(map['start_date']) : null,
      endDate: map['end_date'] != null ? DateTime.fromMillisecondsSinceEpoch(map['end_date']) : null,
      isActive: map['is_active'] ?? true,
    );
  }
}

// Mock Promotions
final List<Promotion> proPromotions = [
  Promotion(
    id: '1',
    title: 'Soldes d\'Été',
    description: 'Jusqu\'à 30% de réduction sur tous les gadgets personnalisés !',
    imageUrl: 'https://images.unsplash.com/photo-1461696114087-397271a7aedc?q=80&w=1200&auto=format&fit=crop',
    startDate: DateTime.now(),
    endDate: DateTime.now().add(const Duration(days: 30)),
  ),
  Promotion(
    id: '2',
    title: 'Forfait Cyber',
    description: 'Achetez 5 heures, obtenez 1 heure gratuite !',
    imageUrl: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80&w=1200&auto=format&fit=crop',
    startDate: DateTime.now(),
    endDate: DateTime.now().add(const Duration(days: 15)),
  ),
  Promotion(
    id: '3',
    title: 'Impression Grand Format',
    description: 'Première commande bénéficie de -20% sur les bannières et roll-ups.',
    imageUrl: 'https://images.unsplash.com/photo-1558655146-9f40138edfeb?q=80&w=1200&auto=format&fit=crop',
    startDate: DateTime.now(),
    endDate: DateTime.now().add(const Duration(days: 20)),
  ),
];
