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
    id: 'service_impression_grand_format',
    title: 'Impression Grand Format',
    description: 'Banderoles, affiches, roll-up et supports publicitaires en haute résolution pour votre communication terrain.',
    iconCode: Icons.format_size.codePoint,
    features: ['Haute résolution', 'Formats personnalisés', 'Livraison rapide', 'À partir de 5 000 FCFA'],
  ),
  Service(
    id: 'service_cartes_visite',
    title: 'Cartes de Visite Premium',
    description: 'Impression professionnelle de cartes de visite avec finitions mates ou brillantes et design personnalisé.',
    iconCode: Icons.badge_outlined.codePoint,
    features: ['Papier premium', 'Finition mate ou brillante', 'Design personnalisé', '10 000 FCFA / 100 cartes'],
  ),
  Service(
    id: 'service_serigraphie',
    title: 'Sérigraphie & Textile',
    description: 'Personnalisation de t-shirts, casquettes et textiles avec une impression durable pour associations, écoles et entreprises.',
    iconCode: Icons.checkroom_rounded.codePoint,
    features: ['Impression durable', 'Tous textiles', 'Commande groupée', 'À partir de 3 000 FCFA'],
  ),
  Service(
    id: 'service_gadgets',
    title: 'Gadgets Personnalisés',
    description: 'Mugs, gourdes, porte-clés, stylos et objets publicitaires personnalisés pour vos cadeaux de marque.',
    iconCode: Icons.card_giftcard.codePoint,
    features: ['Large gamme', 'Idéal cadeaux', 'Qualité professionnelle', 'À partir de 2 500 FCFA'],
  ),
  Service(
    id: 'service_bureautique',
    title: 'Bureautique & Saisie',
    description: 'Saisie de documents, mise en page, photocopie, scan et impression rapide pour dossiers administratifs et académiques.',
    iconCode: Icons.description_rounded.codePoint,
    features: ['Rapide et précis', 'Tous formats', 'Correction incluse', '500 FCFA / page'],
  ),
  Service(
    id: 'service_cyber',
    title: 'Cybercafé Haut Débit',
    description: 'Connexion internet rapide, Wi-Fi, postes modernes et impression disponible sur place.',
    iconCode: Icons.computer_rounded.codePoint,
    features: ['Connexion rapide', 'Postes modernes', 'Impression disponible', '500 FCFA / heure'],
  ),
];
