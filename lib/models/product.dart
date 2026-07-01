import 'review.dart';

class Product {
  final String id;
  final String name;
  final String category;
  final String priceDisplay;
  final double priceValue;
  final String imageUrl;
  final double rating;
  final String? description;
  final List<Review> reviews;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.priceDisplay,
    required this.priceValue,
    required this.imageUrl,
    required this.rating,
    this.description,
    this.reviews = const [],
  });

  // Calculate average rating from reviews
  double get calculatedRating {
    if (reviews.isEmpty) return rating;
    final total = reviews.fold<double>(0, (sum, r) => sum + r.rating);
    return total / reviews.length;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price_display': priceDisplay,
      'price_value': priceValue,
      'image_url': imageUrl,
      'rating': rating,
      'description': description,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      priceDisplay: map['price_display'] ?? map['price'] ?? '',
      priceValue: (map['price_value'] as num?)?.toDouble() ?? 0.0,
      imageUrl: map['image_url'] ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      description: map['description'],
    );
  }
}

final List<Product> proProducts = [
  Product(
    id: '1',
    name: 'T-Shirt Premium',
    category: 'Gadgets',
    priceDisplay: 'À partir de 5 500 FCFA',
    priceValue: 5500,
    imageUrl: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?q=80&w=600&auto=format&fit=crop',
    rating: 4.8,
    description: 'T-shirt de haute qualité avec impression personnalisée durable.',
  ),
  Product(
    id: '2',
    name: 'Mug Personnalisé',
    category: 'Gadgets',
    priceDisplay: 'À partir de 3 300 FCFA',
    priceValue: 3300,
    imageUrl: 'https://images.unsplash.com/photo-1517256673644-36ad362442c6?q=80&w=600&auto=format&fit=crop',
    rating: 4.9,
    description: 'Mug en céramique avec votre photo ou logo. Résistant au lave-vaisselle.',
  ),
  Product(
    id: '3',
    name: 'Bannière Grand Format',
    category: 'Impression',
    priceDisplay: 'À partir de 10 000 FCFA/m²',
    priceValue: 10000,
    imageUrl: 'https://images.unsplash.com/photo-1588850561407-ed78c282e89b?q=80&w=600&auto=format&fit=crop',
    rating: 4.7,
    description: 'Impression haute définition sur bâche résistante aux intempéries.',
  ),
  Product(
    id: '4',
    name: 'Roll-Up Professionnel',
    category: 'Impression',
    priceDisplay: 'À partir de 35 000 FCFA',
    priceValue: 35000,
    imageUrl: 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?q=80&w=600&auto=format&fit=crop',
    rating: 4.9,
    description: 'Roll-up compact avec impression HD, parfait pour vos événements.',
  ),
  Product(
    id: '5',
    name: 'Casquette Brodée',
    category: 'Gadgets',
    priceDisplay: 'À partir de 8 000 FCFA',
    priceValue: 8000,
    imageUrl: 'https://images.unsplash.com/photo-1588850561407-ed78c282e89b?q=80&w=600&auto=format&fit=crop',
    rating: 4.6,
    description: 'Casquette avec broderie personnalisée de haute précision.',
  ),
  Product(
    id: '6',
    name: 'Carte de Visite Premium',
    category: 'Impression',
    priceDisplay: 'À partir de 15 000 FCFA/100 pièces',
    priceValue: 15000,
    imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=600&auto=format&fit=crop',
    rating: 4.8,
    description: 'Cartes de visite sur papier glacé ou mat, finition professionnelle.',
  ),
  Product(
    id: '7',
    name: 'Flyer A5/A4',
    category: 'Impression',
    priceDisplay: 'À partir de 25 000 FCFA/100 pièces',
    priceValue: 25000,
    imageUrl: 'https://images.unsplash.com/photo-1480694313141-fce5e697ee25?q=80&w=600&auto=format&fit=crop',
    rating: 4.7,
    description: 'Flyers en couleur, qualité offset ou numérique selon la quantité.',
  ),
  Product(
    id: '8',
    name: 'Stylo Personnalisé',
    category: 'Gadgets',
    priceDisplay: 'À partir de 500 FCFA/stylo',
    priceValue: 500,
    imageUrl: 'https://images.unsplash.com/photo-1506630448388-4e683c67ddb0?q=80&w=600&auto=format&fit=crop',
    rating: 4.5,
    description: 'Stylos avec impression du logo de votre entreprise, par lot de 100.',
  ),
];
