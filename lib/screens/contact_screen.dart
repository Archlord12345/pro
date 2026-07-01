import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants.dart';
import '../models/business_info.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final BusinessInfo info = const BusinessInfo();
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  Future<void> _launchWhatsApp() async {
    final String cleanPhone = info.whatsapp.replaceAll(RegExp(r'[^0-9]'), '');
    final String url = "https://wa.me/$cleanPhone?text=${Uri.encodeComponent("Bonjour Ets PRO INFORMATIQUE, je vous contacte depuis l'application mobile...")}";
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch WhatsApp');
    }
  }

  Future<void> _makeCall() async {
    final String cleanPhone = info.phone1.replaceAll(RegExp(r'[^0-9+]'), '');
    final Uri url = Uri(scheme: 'tel', path: cleanPhone);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch dialer');
    }
  }

  Future<void> _sendEmail() async {
    final Uri url = Uri(
      scheme: 'mailto',
      path: info.email,
      query: Uri.encodeComponent('subject=Contact depuis l\'application&body=Bonjour, ...'),
    );
    if (!await launchUrl(url)) {
      throw Exception('Could not launch email');
    }
  }

  Future<void> _submitQuote() async {
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    // Ouvre WhatsApp avec le message pré-rempli
    final String cleanPhone = info.whatsapp.replaceAll(RegExp(r'[^0-9]'), '');
    final String message = 
      "Bonjour Ets PRO INFORMATIQUE,\nJe suis ${_nameController.text}.\nTéléphone : ${_phoneController.text}\nDescription du travail : ${_descController.text}";
    final String url = "https://wa.me/$cleanPhone?text=${Uri.encodeComponent(message)}";
    
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible d\'ouvrir WhatsApp')),
      );
    } else {
      _nameController.clear();
      _phoneController.clear();
      _descController.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contactez-nous', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildContactCard(
                  Icons.location_on_rounded,
                  'Notre Siège',
                  info.address,
                  'Bafoussam, Cameroun',
                  onTap: () {}, 
                ),
                const SizedBox(height: 20),
                _buildContactCard(
                  Icons.phone_rounded,
                  'Téléphones',
                  info.phone1,
                  info.phone2,
                  onTap: _makeCall,
                ),
                const SizedBox(height: 20),
                _buildContactCard(
                  Icons.access_time_filled_rounded,
                  'Horaires',
                  info.openingHours,
                  'Fermé les jours fériés',
                ),
                const SizedBox(height: 40),
                const Text('Action Rapide', style: AppTextStyles.subHeading),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        'WhatsApp',
                        Icons.chat_bubble_rounded,
                        const Color(0xFF25D366),
                        _launchWhatsApp,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildActionButton(
                        'Email',
                        Icons.email_rounded,
                        AppColors.primary,
                        _sendEmail,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                const Text('Demander un Devis', style: AppTextStyles.subHeading),
                const SizedBox(height: 20),
                _buildTextField('Nom complet', controller: _nameController),
                const SizedBox(height: 16),
                _buildTextField('Téléphone', controller: _phoneController),
                const SizedBox(height: 16),
                _buildTextField('Description du travail', controller: _descController, maxLines: 4),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _submitQuote,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('Soumettre la demande', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard(IconData icon, String title, String line1, String line2, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: AppColors.primary, size: 28),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(line1, style: AppTextStyles.body),
                  Text(line2, style: AppTextStyles.body),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, {TextEditingController? controller, int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
  }
}
