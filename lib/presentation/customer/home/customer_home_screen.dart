import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/service_provider.dart';
import '../../../domain/entities/service_entity.dart';
import '../../widgets/app_drawer.dart';

class CustomerHomeScreen extends ConsumerWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsyncValue = ref.watch(servicesProvider);

    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Good Morning';
    } else if (hour < 17) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Elite Salon'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$greeting, Kartik',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 24),
            _buildAppointmentCard(context),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'EXPLORE SERVICES',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: () => context.push('/services'),
                  child: const Text('View All', style: TextStyle(color: AppColors.goldAccent)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildServiceList(servicesAsyncValue),
            const SizedBox(height: 32),
            _buildAIBanner(context),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildAIBanner(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/ai-consultation'),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2C2C2C), Color(0xFF1E1E1E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.goldAccent.withOpacity(0.3), width: 1),
        ),
        child: Row(
          children: [
            const Icon(Icons.auto_awesome, color: AppColors.goldAccent, size: 40),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('AI Hair Consultation', style: TextStyle(color: AppColors.goldAccent, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Discover your perfect style with AI', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: AppColors.textSecondary, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(BuildContext context) {
    return Card(
      color: AppColors.surfaceLight,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'NEXT APPOINTMENT',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.goldAccent,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 12),
            Text('Saturday\n4:30 PM', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Haircut + Hair Spa', style: Theme.of(context).textTheme.bodyLarge),
            Text('Stylist: Rahul', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('View Appointment'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceList(AsyncValue<List<ServiceEntity>> servicesAsyncValue) {
    return servicesAsyncValue.when(
      data: (services) {
        return SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return GestureDetector(
                onTap: () {
                  context.push(
                    '/service-detail',
                    extra: {
                      'service': service,
                      'heroTag': 'home-service-${service.id}',
                    },
                  );
                },
                child: Container(
                  width: 110,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          child: Hero(
                            tag: 'home-service-${service.id}',
                            child: service.imageUrl.startsWith('http')
                                ? Image.network(
                                    service.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, color: AppColors.textSecondary),
                                  )
                                : Image.asset(
                                    service.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, color: AppColors.textSecondary),
                                  ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          service.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.textPrimary, fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Text('Error: $err', style: const TextStyle(color: AppColors.error)),
    );
  }
}
