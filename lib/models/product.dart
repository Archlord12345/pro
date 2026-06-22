class Product {
  final String id;
  final String name;
  final String category;
  final String priceDisplay;
  final double priceValue;
  final String imageUrl;
  final double rating;
  final String? description;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.priceDisplay,
    required this.priceValue,
    required this.imageUrl,
    required this.rating,
    this.description,
  });

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

  factory Product.fromSupabase(Map<String, dynamic> map) {
    return Product(
      id: map['id'].toString(),
      name: map['name'],
      category: map['category'],
      priceDisplay: map['price_display'] ?? map['price'] ?? '',
      priceValue: (map['price_value'] as num?)?.toDouble() ?? 0.0,
      imageUrl: map['image_url'] ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 5.0,
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
    priceDisplay: 'Sur devis',
    priceValue: 0,
    imageUrl: 'https://images.unsplash.com/photo-1588850561407-ed78c282e89b?q=80&w=600&auto=format&fit=crop',
    rating: 4.7,
    description: 'Impression haute définition sur bâche résistante aux intempéries.',
  ),
  Product(
    id: '4',
    name: 'Casquette Brodée',
    category: 'Gadgets',
    priceDisplay: 'À partir de 8 000 FCFA',
    priceValue: 8000,
    imageUrl: 'https://images.unsplash.com/photo-1588850561407-ed78c282e89b?q=80&w=600&auto=format&fit=crop',
    rating: 4.6,
    description: 'Casquette avec broderie personnalisée de haute précision.',
  ),
];
