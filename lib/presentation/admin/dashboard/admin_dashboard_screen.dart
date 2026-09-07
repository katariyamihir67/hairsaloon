import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const _AdminHomeTab(),
    const _AdminCalendarTab(),
    const _AdminCustomersTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.goldAccent,
        unselectedItemColor: AppColors.textSecondary,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Calendar'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Customers'),
        ],
      ),
    );
  }
}

class _AdminHomeTab extends StatelessWidget {
  const _AdminHomeTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Business Overview', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildStatCard(context, 'Today\'s Revenue', '₹ 12,450'),
              _buildStatCard(context, 'Appointments', '18'),
              _buildStatCard(context, 'New Customers', '4'),
              _buildStatCard(context, 'Pending Payments', '2'),
            ],
          ),
          const SizedBox(height: 32),
          Text('AI Business Insights', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Card(
            color: AppColors.surfaceLight,
            child: ListTile(
              leading: const Icon(Icons.auto_awesome, color: AppColors.goldAccent),
              title: const Text('Retention Alert', style: TextStyle(color: AppColors.textPrimary)),
              subtitle: const Text('12 VIP customers have not visited in 45 days. Send a personalized offer?', style: TextStyle(color: AppColors.textSecondary)),
              trailing: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12), textStyle: const TextStyle(fontSize: 12)),
                child: const Text('SEND'),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Card(
            color: AppColors.surface,
            child: ListTile(
              leading: Icon(Icons.trending_up, color: AppColors.success),
              title: Text('Hair Spa Demand', style: TextStyle(color: AppColors.textPrimary)),
              subtitle: Text('Demand increased by 18% this month.', style: TextStyle(color: AppColors.textSecondary)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value) {
    return Card(
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.goldAccent)),
          ],
        ),
      ),
    );
  }
}

class _AdminCalendarTab extends StatelessWidget {
  const _AdminCalendarTab();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Calendar Management Coming Soon', style: TextStyle(color: AppColors.textSecondary)),
    );
  }
}

class _AdminCustomersTab extends StatelessWidget {
  const _AdminCustomersTab();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('CRM & Customer List Coming Soon', style: TextStyle(color: AppColors.textSecondary)),
    );
  }
}
