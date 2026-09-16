import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/app_drawer.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.surface,
              child: Icon(Icons.person, size: 50, color: AppColors.goldAccent),
            ),
            const SizedBox(height: 16),
            Text('Kartik Patel', style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: 4),
            const Text('+91 98765 43210', style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => context.push('/edit-profile'),
              icon: const Icon(Icons.edit, size: 16, color: AppColors.background),
              label: const Text('Edit Profile', style: TextStyle(color: AppColors.background, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.goldAccent,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
            const SizedBox(height: 32),
            _buildHairPassport(context),
            const SizedBox(height: 24),
            _buildActionItem(context, Icons.history, 'Appointment History'),
            _buildActionItem(context, Icons.card_giftcard, 'My Rewards (2,450 pts)'),
            _buildActionItem(context, Icons.star_border, 'Membership: ELITE'),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => context.go('/login'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                ),
                child: const Text('LOGOUT'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHairPassport(BuildContext context) {
    return Card(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.goldAccent.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.badge, color: AppColors.goldAccent),
                SizedBox(width: 12),
                Text('HAIR PASSPORT', style: TextStyle(color: AppColors.goldAccent, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
              ],
            ),
            const SizedBox(height: 16),
            _buildPassportRow('Hair Type', 'Wavy'),
            _buildPassportRow('Current Length', 'Medium'),
            _buildPassportRow('Last Visit', '12 August 2026'),
            _buildPassportRow('Recommended Next Visit', 'Within 10 days'),
          ],
        ),
      ),
    );
  }

  Widget _buildPassportRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: AppColors.textSecondary)),
          Text(value, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildActionItem(BuildContext context, IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: AppColors.goldAccent),
      title: Text(title, style: const TextStyle(color: AppColors.textPrimary)),
      trailing: const Icon(Icons.arrow_forward_ios, color: AppColors.textSecondary, size: 16),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$title is coming soon!')),
        );
      },
    );
  }
}
