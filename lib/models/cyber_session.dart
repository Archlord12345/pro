import 'package:flutter/material.dart';

class CyberTicket {
  final String id;
  final String duration; // e.g., "1h", "2h", "5h", "Journée"
  final double price;
  final String priceDisplay;

  const CyberTicket({
    required this.id,
    required this.duration,
    required this.price,
    required this.priceDisplay,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'duration': duration,
      'price': price,
      'priceDisplay': priceDisplay,
    };
  }

  factory CyberTicket.fromMap(Map<String, dynamic> map) {
    return CyberTicket(
      id: map['id'] ?? '',
      duration: map['duration'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      priceDisplay: map['priceDisplay'] ?? '',
    );
  }

  CyberTicket copyWith({
    String? id,
    String? duration,
    double? price,
    String? priceDisplay,
  }) {
    return CyberTicket(
      id: id ?? this.id,
      duration: duration ?? this.duration,
      price: price ?? this.price,
      priceDisplay: priceDisplay ?? this.priceDisplay,
    );
  }
}

class Computer {
  final String id;
  final String name; // e.g., "PC 1", "PC 2"
  final bool isAvailable;
  final String? currentUser;
  final DateTime? endTime;

  const Computer({
    required this.id,
    required this.name,
    this.isAvailable = true,
    this.currentUser,
    this.endTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isAvailable': isAvailable,
      'currentUser': currentUser,
      'endTime': endTime?.millisecondsSinceEpoch,
    };
  }

  factory Computer.fromMap(Map<String, dynamic> map) {
    return Computer(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      isAvailable: map['isAvailable'] ?? true,
      currentUser: map['currentUser'],
      endTime: map['endTime'] != null ? DateTime.fromMillisecondsSinceEpoch(map['endTime']) : null,
    );
  }

  Computer copyWith({
    String? id,
    String? name,
    bool? isAvailable,
    String? currentUser,
    DateTime? endTime,
  }) {
    return Computer(
      id: id ?? this.id,
      name: name ?? this.name,
      isAvailable: isAvailable ?? this.isAvailable,
      currentUser: currentUser ?? this.currentUser,
      endTime: endTime ?? this.endTime,
    );
  }
}

// Predefined tickets
final List<CyberTicket> proCyberTickets = [
  const CyberTicket(
    id: 't1',
    duration: '1 Heure',
    price: 500,
    priceDisplay: '500 FCFA',
  ),
  const CyberTicket(
    id: 't2',
    duration: '2 Heures',
    price: 900,
    priceDisplay: '900 FCFA',
  ),
  const CyberTicket(
    id: 't3',
    duration: '5 Heures',
    price: 2000,
    priceDisplay: '2 000 FCFA',
  ),
  const CyberTicket(
    id: 't4',
    duration: 'Journée',
    price: 3500,
    priceDisplay: '3 500 FCFA',
  ),
];

// Predefined computers
final List<Computer> proComputers = [
  const Computer(id: 'pc1', name: 'PC 1', isAvailable: true),
  const Computer(id: 'pc2', name: 'PC 2', isAvailable: true),
  const Computer(id: 'pc3', name: 'PC 3', isAvailable: false, currentUser: 'Client A'),
  const Computer(id: 'pc4', name: 'PC 4', isAvailable: true),
  const Computer(id: 'pc5', name: 'PC 5', isAvailable: false, currentUser: 'Client B'),
  const Computer(id: 'pc6', name: 'PC 6', isAvailable: true),
];
