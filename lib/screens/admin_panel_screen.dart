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

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  int _currentView = 0; // 0: Services, 1: Products, 2: Cyber Café, 3: Reviews
  bool _isPopulating = false;

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
          const SnackBar(content: Text('Firestore peuplé avec succès !')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
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
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panneau d\'Administration Pro Informatique', 
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => appProvider.fetchData(),
          ),
          IconButton(
            icon: const Icon(Icons.upload, color: Colors.white),
            onPressed: _isPopulating ? null : _populateFirestore,
          ),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _currentView,
            onDestinationSelected: (index) => setState(() => _currentView = index),
            labelType: NavigationRailLabelType.all,
            backgroundColor: Colors.white,
            selectedIconTheme: const IconThemeData(color: AppColors.primary),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.miscellaneous_services_rounded),
                label: Text('Services'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.shopping_bag_rounded),
                label: Text('Produits'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.computer),
                label: Text('Cyber Café'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.reviews_rounded),
                label: Text('Avis'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: _buildCurrentView(appProvider),
            ),
          ),
        ],
      ),
      floatingActionButton: _currentView < 3 ? FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context),
        label: Text(_getAddButtonLabel()),
        icon: const Icon(Icons.add),
        backgroundColor: AppColors.cardTeal,
      ) : null,
    );
  }

  String _getAddButtonLabel() {
    switch (_currentView) {
      case 0: return 'Ajouter Service';
      case 1: return 'Ajouter Produit';
      case 2: return 'Ajouter Ticket';
      default: return '';
    }
  }

  Widget _buildCurrentView(AppProvider appProvider) {
    switch (_currentView) {
      case 0: return _buildServicesTable(appProvider);
      case 1: return _buildProductsTable(appProvider);
      case 2: return _buildCyberCafeSection(appProvider);
      case 3: return _buildReviewsSection(appProvider);
      default: return const SizedBox();
    }
  }

  Widget _buildServicesTable(AppProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Gestion des Services', style: AppTextStyles.heading),
        const SizedBox(height: 20),
        Expanded(
          child: SingleChildScrollView(
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Titre')),
                DataColumn(label: Text('Description')),
                DataColumn(label: Text('Actions')),
              ],
              rows: provider.services.map((service) => DataRow(cells: [
                DataCell(Text(service.title)),
                DataCell(Text(service.description, overflow: TextOverflow.ellipsis)),
                DataCell(Row(
                  children: [
                    IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _editService(service)),
                    IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteService(service.id)),
                  ],
                )),
              ])).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductsTable(AppProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Gestion des Produits', style: AppTextStyles.heading),
        const SizedBox(height: 20),
        Expanded(
          child: SingleChildScrollView(
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Nom')),
                DataColumn(label: Text('Catégorie')),
                DataColumn(label: Text('Prix')),
                DataColumn(label: Text('Actions')),
              ],
              rows: provider.products.map((product) => DataRow(cells: [
                DataCell(Text(product.name)),
                DataCell(Text(product.category)),
                DataCell(Text(product.priceDisplay)),
                DataCell(Row(
                  children: [
                    IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _editProduct(product)),
                    IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteProduct(product.id)),
                  ],
                )),
              ])).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCyberCafeSection(AppProvider provider) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Gestion du Cyber Café', style: AppTextStyles.heading),
          const SizedBox(height: 32),
          
          const Text('Tarifs des Tickets', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.3,
            ),
            itemCount: provider.cyberTickets.length,
            itemBuilder: (context, index) => _buildTicketCardAdmin(provider.cyberTickets[index]),
          ),
          const SizedBox(height: 32),

          const Text('État des Ordinateurs', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: provider.computers.length,
            itemBuilder: (context, index) => _buildComputerCardAdmin(provider.computers[index]),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection(AppProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Gestion des Avis Clients', style: AppTextStyles.heading),
        const SizedBox(height: 20),
        Expanded(
          child: SingleChildScrollView(
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Produit')),
                DataColumn(label: Text('Utilisateur')),
                DataColumn(label: Text('Note')),
                DataColumn(label: Text('Commentaire')),
                DataColumn(label: Text('Actions')),
              ],
              rows: provider.reviews.map((review) => DataRow(cells: [
                DataCell(Text(review.productId)),
                DataCell(Text(review.userName)),
                DataCell(Row(
                  children: List.generate(5, (index) => Icon(
                    index < review.rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 16,
                  )),
                )),
                DataCell(Text(review.comment, overflow: TextOverflow.ellipsis)),
                DataCell(IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteReview(review.id),
                )),
              ])).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTicketCardAdmin(CyberTicket ticket) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(ticket.duration, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            Text(ticket.priceDisplay, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(icon: const Icon(Icons.edit, size: 20, color: Colors.blue), onPressed: () => _editTicket(ticket)),
                IconButton(icon: const Icon(Icons.delete, size: 20, color: Colors.red), onPressed: () => _deleteTicket(ticket.id)),
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
        color: computer.isAvailable ? Colors.white : Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: computer.isAvailable ? AppColors.cardTeal : AppColors.cardPink, width: 2),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.computer, size: 40, color: computer.isAvailable ? AppColors.cardTeal : AppColors.cardPink),
            const SizedBox(height: 8),
            Text(computer.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Text(
              computer.isAvailable ? 'Disponible' : 'Occupé',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: computer.isAvailable ? AppColors.cardTeal : AppColors.cardPink),
            ),
            if (!computer.isAvailable && computer.currentUser != null) ...[
              const SizedBox(height: 4),
              Text(computer.currentUser!, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            ],
            const SizedBox(height: 8),
            IconButton(
              icon: const Icon(Icons.edit, size: 20, color: Colors.blue),
              onPressed: () => _toggleComputerStatus(computer),
            ),
          ],
        ),
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
      builder: (context) => AlertDialog(
        title: Text(isEdit ? 'Modifier' : _getAddDialogTitle()),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_currentView == 0) ...[
                TextField(decoration: const InputDecoration(labelText: 'Titre'), controller: titleController),
                TextField(decoration: const InputDecoration(labelText: 'Description'), controller: descController),
              ],
              if (_currentView == 1) ...[
                TextField(decoration: const InputDecoration(labelText: 'Nom'), controller: titleController),
                TextField(decoration: const InputDecoration(labelText: 'Catégorie'), controller: categoryController),
                TextField(decoration: const InputDecoration(labelText: 'Description'), controller: descController),
                TextField(decoration: const InputDecoration(labelText: 'Prix'), keyboardType: TextInputType.number, controller: priceController),
                TextField(decoration: const InputDecoration(labelText: 'URL Image'), controller: imageController),
              ],
              if (_currentView == 2) ...[
                TextField(decoration: const InputDecoration(labelText: 'Durée (ex: 1h, 2h)'), controller: durationController),
                TextField(decoration: const InputDecoration(labelText: 'Prix'), keyboardType: TextInputType.number, controller: priceController),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
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
                  SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
                );
              }
            },
            child: Text(isEdit ? 'Mettre à jour' : 'Enregistrer', style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _getAddDialogTitle() {
    switch (_currentView) {
      case 0: return 'Nouveau Service';
      case 1: return 'Nouveau Produit';
      case 2: return 'Nouveau Ticket';
      default: return '';
    }
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
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Êtes-vous sûr de vouloir supprimer $itemName ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red), onPressed: () => Navigator.pop(context, true), child: const Text('Supprimer')),
        ],
      ),
    ) ?? false;
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
