import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../constants.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  int _currentView = 0; // 0 for Services, 1 for Products

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panneau d\'Administration Pro Informatique', 
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => appProvider.fetchData(),
          ),
        ],
      ),
      body: Row(
        children: [
          // Navigation Rail for Web Admin
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
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // Main Content Area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: _currentView == 0 
                ? _buildServicesTable(appProvider) 
                : _buildProductsTable(appProvider),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context),
        label: Text(_currentView == 0 ? 'Ajouter Service' : 'Ajouter Produit'),
        icon: const Icon(Icons.add),
        backgroundColor: AppColors.cardTeal,
      ),
    );
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
                    IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () {}),
                    IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () {}),
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
                    IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () {}),
                    IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () {}),
                  ],
                )),
              ])).toList(),
            ),
          ),
        ),
      ],
    );
  }

  void _showAddDialog(BuildContext context) {
    // Basic dialog placeholder for adding items
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_currentView == 0 ? 'Nouveau Service' : 'Nouveau Produit'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(decoration: InputDecoration(labelText: 'Titre/Nom')),
            TextField(decoration: InputDecoration(labelText: 'Description/Prix')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Enregistrer')),
        ],
      ),
    );
  }
}
