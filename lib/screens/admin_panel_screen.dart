import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/app_provider.dart';
import '../constants.dart';
import '../models/service.dart';
import '../models/product.dart';
import '../models/cyber_session.dart';
import '../models/promotion.dart';
import '../models/review.dart';
import 'admin_login_screen.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> with SingleTickerProviderStateMixin {
  int _currentView = 0; // 0: Services, 1: Products, 2: Cyber Café, 3: Reviews
  bool _isPopulating = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _populateFirestore() async {
    setState(() => _isPopulating = true);
    final firestore = FirebaseFirestore.instance;

    try {
      WriteBatch batch = firestore.batch();
      
      for (var service in proServices) {
        DocumentReference ref = firestore.collection('services').doc(service.id);
        batch.set(ref, service.toMap());
      }

      for (var product in proProducts) {
        DocumentReference ref = firestore.collection('products').doc(product.id);
        batch.set(ref, product.toMap());
      }

      for (var ticket in proCyberTickets) {
        DocumentReference ref = firestore.collection('cyber_tickets').doc(ticket.id);
        batch.set(ref, ticket.toMap());
      }

      for (var computer in proComputers) {
        DocumentReference ref = firestore.collection('computers').doc(computer.id);
        batch.set(ref, computer.toMap());
      }

      for (var review in proReviews) {
        DocumentReference ref = firestore.collection('reviews').doc(review.id);
        batch.set(ref, review.toMap());
      }

      await batch.commit();
      
      if (mounted) {
        context.read<AppProvider>().fetchData();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Firestore peuplé avec succès !'),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: AppColors.cardPink,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isPopulating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final size = MediaQuery.of(context).size;
    final isWeb = size.width > 1000;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          // Sidebar
          Container(
            width: isWeb ? 280 : 70,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(5, 0),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Logo/Header
                  Padding(
                    padding: EdgeInsets.all(isWeb ? 24 : 12),
                    child: isWeb
                        ? Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(Icons.admin_panel_settings, color: Colors.white, size: 28),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  'Admin Pro',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(Icons.admin_panel_settings, color: Colors.white, size: 28),
                          ),
                  ),
                  const SizedBox(height: 16),
                  // Navigation Items
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: isWeb ? 16 : 8),
                      children: [
                        _buildNavItem(0, Icons.miscellaneous_services_rounded, 'Services', isWeb),
                        _buildNavItem(1, Icons.shopping_bag_rounded, 'Produits', isWeb),
                        _buildNavItem(2, Icons.computer, 'Cyber Café', isWeb),
                        _buildNavItem(3, Icons.reviews_rounded, 'Avis', isWeb),
                      ],
                    ),
                  ),
                  // Logout Button
                  Padding(
                    padding: EdgeInsets.all(isWeb ? 16 : 8),
                    child: isWeb
                        ? ListTile(
                            leading: const Icon(Icons.logout, color: Colors.white),
                            title: const Text('Déconnexion', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                            onTap: () => _logout(context),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            hoverColor: Colors.white.withValues(alpha: 0.1),
                          )
                        : IconButton(
                            icon: const Icon(Icons.logout, color: Colors.white),
                            onPressed: () => _logout(context),
                          ),
                  ),
                ],
              ),
            ),
          ),
          // Main Content
          Expanded(
            child: Column(
              children: [
                // Top Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _getViewTitle(),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh, color: AppColors.textSecondary),
                        onPressed: () => appProvider.fetchData(),
                        tooltip: 'Actualiser',
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: _isPopulating ? null : _populateFirestore,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.cardTeal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        icon: _isPopulating
                            ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Icon(Icons.upload_file, size: 20),
                        label: const Text(
                          'Peupler Firestore',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                // Content Area
                Expanded(
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: Transform.translate(
                          offset: Offset(0, _slideAnimation.value),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: _buildCurrentView(appProvider, size.width),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _currentView < 3
          ? FloatingActionButton.extended(
              onPressed: () => _showAddDialog(context),
              label: Text(_getAddButtonLabel()),
              icon: const Icon(Icons.add),
              backgroundColor: AppColors.cardTeal,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            )
          : null,
    );
  }

  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AdminLoginScreen()),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, bool isWeb) {
    final isSelected = _currentView == index;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: isWeb
          ? ListTile(
              leading: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.6),
              ),
              title: Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.8),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              selected: isSelected,
              selectedTileColor: Colors.white.withValues(alpha: 0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              hoverColor: Colors.white.withValues(alpha: 0.1),
              onTap: () {
                setState(() => _currentView = index);
                _animationController.forward(from: 0.0);
              },
            )
          : Container(
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withValues(alpha: 0.2) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: Icon(
                  icon,
                  color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.6),
                  size: 24,
                ),
                onPressed: () {
                  setState(() => _currentView = index);
                  _animationController.forward(from: 0.0);
                },
                tooltip: label,
              ),
            ),
    );
  }

  String _getViewTitle() {
    switch (_currentView) {
      case 0: return 'Gestion des Services';
      case 1: return 'Gestion des Produits';
      case 2: return 'Gestion du Cyber Café';
      case 3: return 'Gestion des Avis Clients';
      default: return '';
    }
  }

  String _getAddButtonLabel() {
    switch (_currentView) {
      case 0: return 'Ajouter Service';
      case 1: return 'Ajouter Produit';
      case 2: return 'Ajouter Ticket';
      default: return '';
    }
  }

  Widget _buildCurrentView(AppProvider provider, double width) {
    switch (_currentView) {
      case 0: return _buildServicesTable(provider, width);
      case 1: return _buildProductsTable(provider, width);
      case 2: return _buildCyberCafeSection(provider, width);
      case 3: return _buildReviewsSection(provider, width);
      default: return const SizedBox();
    }
  }

  Widget _buildServicesTable(AppProvider provider, double width) {
    final isLarge = width > 800;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isLarge)
          Expanded(
            child: ListView.builder(
              itemCount: provider.services.length,
              itemBuilder: (context, index) {
                final service = provider.services[index];
                return _buildServiceCard(service);
              },
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              itemCount: provider.services.length,
              itemBuilder: (context, index) {
                final service = provider.services[index];
                return _buildServiceCard(service);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildServiceCard(Service service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            IconData(service.iconCode, fontFamily: 'MaterialIcons'),
            color: AppColors.primary,
            size: 28,
          ),
        ),
        title: Text(
          service.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            service.description,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
              onPressed: () => _editService(service),
              tooltip: 'Modifier',
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: AppColors.cardPink, size: 20),
              onPressed: () => _deleteService(service.id),
              tooltip: 'Supprimer',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsTable(AppProvider provider, double width) {
    final isLarge = width > 800;
    final crossAxisCount = isLarge ? 4 : 2;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: provider.products.length,
      itemBuilder: (context, index) {
        final product = provider.products[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductCard(Product product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: product.imageUrl.isNotEmpty
                  ? Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          child: const Center(
                            child: Icon(Icons.image_not_supported, color: AppColors.primary, size: 40),
                          ),
                        );
                      },
                    )
                  : Container(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      child: const Center(
                        child: Icon(Icons.shopping_bag, color: AppColors.primary, size: 40),
                      ),
                    ),
            ),
          ),
          // Info
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.category,
                        style: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.7), fontSize: 12),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.priceDisplay,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue, size: 18),
                            onPressed: () => _editProduct(product),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: AppColors.cardPink, size: 18),
                            onPressed: () => _deleteProduct(product.id),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCyberCafeSection(AppProvider provider, double width) {
    final isLarge = width > 800;
    final ticketCrossAxisCount = isLarge ? 4 : 2;
    final computerCrossAxisCount = isLarge ? 6 : 3;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tickets Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.receipt_long, color: AppColors.primary, size: 24),
                    const SizedBox(width: 12),
                    const Text('Tarifs des Tickets', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 24),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: ticketCrossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: provider.cyberTickets.length,
                  itemBuilder: (context, index) => _buildTicketCardAdmin(provider.cyberTickets[index]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Computers Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.computer, color: AppColors.primary, size: 24),
                    const SizedBox(width: 12),
                    const Text('État des Ordinateurs', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 24),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: computerCrossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: provider.computers.length,
                  itemBuilder: (context, index) => _buildComputerCardAdmin(provider.computers[index]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketCardAdmin(CyberTicket ticket) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.timer, color: Colors.white, size: 32),
            const SizedBox(height: 8),
            Text(
              ticket.duration,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              ticket.priceDisplay,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.edit, size: 18, color: Colors.white),
                    onPressed: () => _editTicket(ticket),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.delete, size: 18, color: Colors.white),
                    onPressed: () => _deleteTicket(ticket.id),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComputerCardAdmin(Computer computer) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: computer.isAvailable ? AppColors.cardTeal : AppColors.cardPink,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: (computer.isAvailable ? AppColors.cardTeal : AppColors.cardPink).withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (computer.isAvailable ? AppColors.cardTeal : AppColors.cardPink).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.computer,
                size: 32,
                color: computer.isAvailable ? AppColors.cardTeal : AppColors.cardPink,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              computer.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: (computer.isAvailable ? AppColors.cardTeal : AppColors.cardPink).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                computer.isAvailable ? 'Disponible' : 'Occupé',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: computer.isAvailable ? AppColors.cardTeal : AppColors.cardPink,
                ),
              ),
            ),
            if (!computer.isAvailable && computer.currentUser != null) ...[
              const SizedBox(height: 8),
              Text(
                computer.currentUser!,
                style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 12),
            IconButton(
              icon: const Icon(Icons.edit, size: 20, color: AppColors.primary),
              onPressed: () => _toggleComputerStatus(computer),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsSection(AppProvider provider, double width) {
    return ListView.builder(
      itemCount: provider.reviews.length,
      itemBuilder: (context, index) {
        final review = provider.reviews[index];
        return _buildReviewCard(review);
      },
    );
  }

  Widget _buildReviewCard(Review review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: AppColors.accentGradient,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                review.userName.characters.first.toUpperCase(),
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      review.userName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(5, (index) => Icon(
                        index < review.rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 18,
                      )),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  review.productId,
                  style: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.7), fontSize: 12),
                ),
                const SizedBox(height: 8),
                Text(
                  review.comment,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: AppColors.cardPink, size: 20),
            onPressed: () => _deleteReview(review.id),
            tooltip: 'Supprimer',
          ),
        ],
      ),
    );
  }

  // CRUD Methods
  void _showAddDialog(BuildContext context, {Object? item}) {
    final isEdit = item != null;
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final priceController = TextEditingController();
    final durationController = TextEditingController();
    final categoryController = TextEditingController();
    final imageController = TextEditingController();

    // Pre-fill if editing
    if (isEdit) {
      if (item is Service) {
        titleController.text = item.title;
        descController.text = item.description;
      } else if (item is Product) {
        titleController.text = item.name;
        descController.text = item.description ?? '';
        priceController.text = item.priceValue.toString();
        categoryController.text = item.category;
        imageController.text = item.imageUrl;
      } else if (item is CyberTicket) {
        durationController.text = item.duration;
        priceController.text = item.price.toString();
      }
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 0,
        child: Container(
          width: 500,
          constraints: const BoxConstraints(maxHeight: 600),
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEdit ? 'Modifier ${_getItemName()}' : 'Nouveau ${_getItemName()}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_currentView == 0) ...[
                        _buildTextField(
                          controller: titleController,
                          label: 'Titre',
                          icon: Icons.title,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: descController,
                          label: 'Description',
                          icon: Icons.description,
                          maxLines: 3,
                        ),
                      ],
                      if (_currentView == 1) ...[
                        _buildTextField(
                          controller: titleController,
                          label: 'Nom',
                          icon: Icons.shopping_bag,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: categoryController,
                          label: 'Catégorie',
                          icon: Icons.category,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: descController,
                          label: 'Description',
                          icon: Icons.description,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: priceController,
                          label: 'Prix',
                          icon: Icons.attach_money,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: imageController,
                          label: 'URL Image',
                          icon: Icons.image,
                        ),
                      ],
                      if (_currentView == 2) ...[
                        _buildTextField(
                          controller: durationController,
                          label: 'Durée (ex: 1h, 2h)',
                          icon: Icons.timer,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: priceController,
                          label: 'Prix',
                          icon: Icons.attach_money,
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Annuler', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          if (_currentView == 0) {
                            if (isEdit && item is Service) {
                              // TODO: Implement update service
                            } else {
                              final newService = Service(
                                id: DateTime.now().millisecondsSinceEpoch.toString(),
                                title: titleController.text,
                                description: descController.text,
                                iconCode: Icons.business.codePoint,
                                features: [],
                              );
                              await context.read<AppProvider>().addService(newService);
                            }
                          } else if (_currentView == 1) {
                            if (isEdit && item is Product) {
                              // TODO: Implement update product
                            } else {
                              final newProduct = Product(
                                id: DateTime.now().millisecondsSinceEpoch.toString(),
                                name: titleController.text,
                                category: categoryController.text,
                                priceValue: double.tryParse(priceController.text) ?? 0,
                                priceDisplay: '${priceController.text} FCFA',
                                description: descController.text,
                                imageUrl: imageController.text,
                                rating: 0.0,
                              );
                              await context.read<AppProvider>().addProduct(newProduct);
                            }
                          } else if (_currentView == 2) {
                            if (isEdit && item is CyberTicket) {
                              // TODO: Implement update ticket
                            } else {
                              final newTicket = CyberTicket(
                                id: DateTime.now().millisecondsSinceEpoch.toString(),
                                duration: durationController.text,
                                price: double.tryParse(priceController.text) ?? 0,
                                priceDisplay: '${priceController.text} FCFA',
                              );
                              await context.read<AppProvider>().addCyberTicket(newTicket);
                            }
                          }
                          if (mounted) Navigator.pop(context);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Erreur: $e'),
                              backgroundColor: AppColors.cardPink,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        isEdit ? 'Mettre à jour' : 'Enregistrer',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getItemName() {
    switch (_currentView) {
      case 0: return 'Service';
      case 1: return 'Produit';
      case 2: return 'Ticket';
      default: return '';
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        prefixIcon: Icon(icon, color: AppColors.primary),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
    );
  }

  Future<void> _deleteService(String id) async {
    if (await _confirmDelete('ce service')) {
      await context.read<AppProvider>().deleteService(id);
    }
  }

  Future<void> _deleteProduct(String id) async {
    if (await _confirmDelete('ce produit')) {
      await context.read<AppProvider>().deleteProduct(id);
    }
  }

  Future<void> _deleteTicket(String id) async {
    if (await _confirmDelete('ce ticket')) {
      await context.read<AppProvider>().deleteCyberTicket(id);
    }
  }

  Future<void> _deleteReview(String id) async {
    if (await _confirmDelete('cet avis')) {
      await context.read<AppProvider>().deleteReview(id);
    }
  }

  Future<bool> _confirmDelete(String itemName) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              width: 400,
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.cardPink.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.delete_outline, color: AppColors.cardPink, size: 40),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Confirmer la suppression',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Êtes-vous sûr de vouloir supprimer $itemName ?',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Annuler', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.cardPink,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Supprimer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ) ??
        false;
  }

  void _editService(Service service) {
    _showAddDialog(context, item: service);
  }

  void _editProduct(Product product) {
    _showAddDialog(context, item: product);
  }

  void _editTicket(CyberTicket ticket) {
    _showAddDialog(context, item: ticket);
  }

  Future<void> _toggleComputerStatus(Computer computer) async {
    final updatedComputer = Computer(
      id: computer.id,
      name: computer.name,
      isAvailable: !computer.isAvailable,
      currentUser: !computer.isAvailable ? null : computer.currentUser,
      endTime: !computer.isAvailable ? null : computer.endTime,
    );
    await context.read<AppProvider>().updateComputer(updatedComputer);
  }
}
