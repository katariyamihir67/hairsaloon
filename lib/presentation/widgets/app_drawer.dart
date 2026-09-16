import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.toString();

    return Drawer(
      backgroundColor: AppColors.background,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 60, bottom: 20, left: 20, right: 20),
            color: AppColors.surface,
            width: double.infinity,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/images/stylist.jpg'), // Placeholder user image
                ),
                SizedBox(height: 16),
                Text(
                  'Kartik',
                  style: TextStyle(
                    color: AppColors.goldAccent,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Premium Member',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildDrawerItem(
                  context: context,
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home,
                  title: 'Home',
                  route: '/customer-home',
                  currentRoute: currentRoute,
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.cut_outlined,
                  activeIcon: Icons.cut,
                  title: 'Services',
                  route: '/services',
                  currentRoute: currentRoute,
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.calendar_today_outlined,
                  activeIcon: Icons.calendar_today,
                  title: 'Appointments',
                  route: '/booking',
                  currentRoute: currentRoute,
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.auto_awesome_outlined,
                  activeIcon: Icons.auto_awesome,
                  title: 'AI Try-on',
                  route: '/ai-consultation',
                  currentRoute: currentRoute,
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  title: 'Profile',
                  route: '/profile',
                  currentRoute: currentRoute,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text('Logout', style: TextStyle(color: Colors.redAccent)),
              onTap: () {
                context.go('/login');
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required IconData activeIcon,
    required String title,
    required String route,
    required String currentRoute,
  }) {
    final isSelected = currentRoute == route;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.goldAccent.withOpacity(0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          isSelected ? activeIcon : icon,
          color: isSelected ? AppColors.goldAccent : AppColors.textPrimary,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? AppColors.goldAccent : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: () {
          // Close drawer
          Navigator.pop(context);
          // Navigate if not already on the selected route
          if (!isSelected) {
            context.go(route);
          }
        },
      ),
    );
  }
}
