import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/service_provider.dart';
import '../../../domain/entities/service_entity.dart';
import '../widgets/app_drawer.dart';

class ServicesListScreen extends ConsumerWidget {
  const ServicesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(servicesProvider);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.background,
        drawer: const AppDrawer(),
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          title: Text(
            'Our Services',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.goldAccent,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
          ),
          centerTitle: true,
          bottom: TabBar(
            isScrollable: true,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: AppColors.goldAccent.withOpacity(0.15),
              border: Border.all(color: AppColors.goldAccent, width: 1),
            ),
            labelColor: AppColors.goldAccent,
            unselectedLabelColor: AppColors.textSecondary,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
            indicatorPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: -16),
            padding: const EdgeInsets.only(bottom: 8),
            tabs: const [
              Tab(text: 'HAIRCUTS & STYLING'),
              Tab(text: 'COLOR BAR'),
              Tab(text: 'TREATMENT & SPA'),
              Tab(text: 'BRIDAL EVENTS'),
            ],
          ),
        ),
        body: servicesAsync.when(
          data: (services) {
            final haircuts = services.where((s) => s.category == 'Haircuts and Styling').toList();
            final colorBar = services.where((s) => s.category == 'Color Bar').toList();
            final spa = services.where((s) => s.category == 'Treatment and Spa').toList();
            final bridal = services.where((s) => s.category == 'Bridal Events').toList();

            return TabBarView(
              children: [
                _buildServiceList(haircuts, context),
                _buildServiceList(colorBar, context),
                _buildServiceList(spa, context),
                _buildServiceList(bridal, context),
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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.spa_outlined, size: 64, color: AppColors.goldAccent.withOpacity(0.5)),
            const SizedBox(height: 16),
            const Text('New services coming soon.', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
            border: Border.all(color: AppColors.surfaceLight, width: 1),
          ),
          child: Material(
            color: Colors.transparent,
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
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.goldAccent.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Hero(
                          tag: 'list-service-${service.id}',
                          child: service.imageUrl.startsWith('http')
                              ? Image.network(
                                  service.imageUrl,
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  service.imageUrl,
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    width: 90,
                                    height: 90,
                                    color: AppColors.surfaceLight,
                                    child: const Icon(Icons.broken_image, color: AppColors.goldAccent),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service.name,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.3,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
                              const SizedBox(width: 4),
                              Text(
                                '${service.durationMinutes} mins',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '₹${service.price.toInt()}',
                                style: const TextStyle(
                                  color: AppColors.goldAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.goldAccent.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: AppColors.goldAccent.withOpacity(0.3)),
                                ),
                                child: const Text(
                                  'Book',
                                  style: TextStyle(
                                    color: AppColors.goldAccent,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
