import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/service_provider.dart';
import '../../../domain/entities/service_entity.dart';

class ServicesListScreen extends ConsumerWidget {
  const ServicesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(servicesProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('All Services'),
          bottom: const TabBar(
            indicatorColor: AppColors.goldAccent,
            labelColor: AppColors.goldAccent,
            unselectedLabelColor: AppColors.textSecondary,
            tabs: [
              Tab(text: 'MALE'),
              Tab(text: 'FEMALE'),
            ],
          ),
        ),
        body: servicesAsync.when(
          data: (services) {
            final maleServices = services.where((s) => s.gender.toLowerCase() == 'male').toList();
            final femaleServices = services.where((s) => s.gender.toLowerCase() == 'female').toList();

            return TabBarView(
              children: [
                _buildServiceList(maleServices, context),
                _buildServiceList(femaleServices, context),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.goldAccent)),
          error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: AppColors.error))),
        ),
      ),
    );
  }

  Widget _buildServiceList(List<ServiceEntity> services, BuildContext context) {
    if (services.isEmpty) {
      return const Center(child: Text('No services found.', style: TextStyle(color: AppColors.textSecondary)));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return Card(
          color: AppColors.surface,
          margin: const EdgeInsets.only(bottom: 16),
          child: InkWell(
            onTap: () {
              context.push(
                '/service-detail',
                extra: {
                  'service': service,
                  'heroTag': 'list-service-${service.id}',
                },
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
                  child: Hero(
                    tag: 'list-service-${service.id}',
                    child: service.imageUrl.startsWith('http')
                      ? Image.network(
                          service.imageUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 100,
                            height: 100,
                            color: AppColors.surfaceLight,
                            child: const Icon(Icons.broken_image, color: AppColors.textSecondary),
                          ),
                        )
                      : Image.asset(
                          service.imageUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 100,
                            height: 100,
                            color: AppColors.surfaceLight,
                            child: const Icon(Icons.broken_image, color: AppColors.textSecondary),
                          ),
                        ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${service.durationMinutes} mins',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '₹${service.price.toInt()}',
                              style: const TextStyle(
                                color: AppColors.goldAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textSecondary),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
