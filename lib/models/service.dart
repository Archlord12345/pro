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

  // For SQLite (features stored as JSON string)
  factory Service.fromMap(Map<String, dynamic> map) {
    List<String> featureList;
    if (map['features'] is String) {
      featureList = List<String>.from(jsonDecode(map['features']));
    } else if (map['features'] is List) {
      featureList = List<String>.from(map['features']);
    } else {
      featureList = [];
    }
    return Service(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      iconCode: map['icon_code'],
      features: featureList,
    );
  }
}

final List<Service> proServices = [
  Service(
    id: '1',
    title: 'Impression Grand Format',
    description: 'Banderoles, Roll-ups, Affiches publicitaires, Autocollants. Qualité haute définition pour votre communication.',
    iconCode: Icons.format_size.codePoint,
    features: ['Banderoles', 'Roll-ups', 'Affiches publicitaires', 'Autocollants'],
  ),
  Service(
    id: '2',
    title: 'Infographie & Design',
    description: 'Création de logos, flyers, dépliants, cartes de visite et maquettes professionnelles.',
    iconCode: Icons.design_services.codePoint,
    features: ['Logos', 'Flyers', 'Dépliants', 'Cartes de visite', 'Maquettes'],
  ),
  Service(
    id: '3',
    title: 'Gadgets Personnalisés',
    description: 'T-shirts, Casquettes, Stylos, Mugs, Porte-clés. Idéal pour vos cadeaux d\'entreprise.',
    iconCode: Icons.card_giftcard.codePoint,
    features: ['T-shirts', 'Casquettes', 'Stylos', 'Mugs', 'Porte-clés'],
  ),
  Service(
    id: '4',
    title: 'Cyber Café / Bureautique',
    description: 'Saisie, reliure, plastification, photocopie, scan, et accès internet haut débit.',
    iconCode: Icons.print.codePoint,
    features: ['Saisie', 'Reliure', 'Plastification', 'Photocopie', 'Scan', 'Accès internet'],
  ),
];
