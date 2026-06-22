import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _supabase = Supabase.instance.client;
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = _supabase.auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _user == null ? _buildAuthPlaceholder() : _buildProfileView(),
    );
  }

  Widget _buildAuthPlaceholder() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.notifications_active_outlined, size: 60, color: AppColors.primary),
            ),
            const SizedBox(height: 24),
            const Text(
              'Restez Connecté',
              style: AppTextStyles.subHeading,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Créez un compte pour recevoir des notifications sur nos nouveaux produits, arrivages et promotions exclusives.',
              style: AppTextStyles.body,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to Login/Sign up
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Se connecter / S\'inscrire', 
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {},
              child: const Text('Continuer en tant qu\'invité', 
                style: TextStyle(color: AppColors.textSecondary)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 40),
          const CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.primary,
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(_user?.email ?? 'Utilisateur', style: AppTextStyles.subHeading),
          const SizedBox(height: 32),
          _buildProfileItem(Icons.history, 'Historique des commandes'),
          _buildProfileItem(Icons.notifications_outlined, 'Paramètres des notifications'),
          _buildProfileItem(Icons.help_outline, 'Aide & Support'),
          const SizedBox(height: 32),
          _buildProfileItem(Icons.logout, 'Déconnexion', color: Colors.red, onTap: () async {
            await _supabase.auth.signOut();
            setState(() { _user = null; });
          }),
        ],
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, {Color? color, VoidCallback? onTap}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: color ?? AppColors.primary),
      title: Text(title, style: TextStyle(color: color ?? AppColors.textPrimary)),
      trailing: const Icon(Icons.chevron_right, size: 20),
    );
  }
}
