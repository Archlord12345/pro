import 'dart:convert';
import 'package:flutter/material.dart';

class Service {
  final String id;
  final String title;
  final String description;
  final int iconCode;
  final List<String> features;

  Service({
    required this.id,
    required this.title,
    required this.description,
    required this.iconCode,
    required this.features,
  });

  IconData get icon => IconData(iconCode, fontFamily: 'MaterialIcons');

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon_code': iconCode,
      'features': jsonEncode(features),
    };
  }

  factory Service.fromMap(Map<String, dynamic> map) {
    return Service(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      iconCode: map['icon_code'],
      features: List<String>.from(jsonDecode(map['features'])),
    );
  }

  factory Service.fromSupabase(Map<String, dynamic> map) {
     return Service(
      id: map['id'].toString(),
      title: map['title'],
      description: map['description'],
      iconCode: map['icon_code'],
      features: List<String>.from(map['features'] ?? []),
    );
  }
}

final List<Service> proServices = [
  Service(
    id: '1',
    title: 'Impression Grand Format',
    description: 'Qualité haute définition pour votre communication visuelle.',
    iconCode: Icons.format_size.codePoint,
    features: ['Banderoles', 'Roll-ups', 'Affiches publicitaires', 'Autocollants'],
  ),
  Service(
    id: '2',
    title: 'Infographie & Design',
    description: 'Création graphique professionnelle pour tous vos supports.',
    iconCode: Icons.design_services.codePoint,
    features: ['Logos', 'Flyers', 'Cartes de visite', 'Maquettes'],
  ),
  Service(
    id: '3',
    title: 'Gadgets Personnalisés',
    description: 'Idéal pour vos cadeaux d\'entreprise et événements.',
    iconCode: Icons.card_giftcard.codePoint,
    features: ['T-shirts', 'Casquettes', 'Mugs', 'Stylos & Porte-clés'],
  ),
  Service(
    id: '4',
    title: 'Bureautique & Cyber',
    description: 'Services complets de secrétariat et accès internet.',
    iconCode: Icons.print.codePoint,
    features: ['Saisie & Reliure', 'Plastification', 'Photocopie', 'Scan'],
  ),
];
