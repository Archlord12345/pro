import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants.dart';
import '../models/business_info.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  final BusinessInfo info = const BusinessInfo();

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
                    () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Text('Demander un Devis', style: AppTextStyles.subHeading),
            const SizedBox(height: 20),
            _buildTextField('Nom complet'),
            const SizedBox(height: 16),
            _buildTextField('Téléphone'),
            const SizedBox(height: 16),
            _buildTextField('Description du travail', maxLines: 4),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {},
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
    );
  }

  Widget _buildContactCard(IconData icon, String title, String line1, String line2, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
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

  Widget _buildTextField(String label, {int maxLines = 1}) {
    return TextField(
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
