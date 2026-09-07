import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/service_entity.dart';

class ServiceDetailScreen extends StatefulWidget {
  final ServiceEntity service;
  final String? heroTag;

  const ServiceDetailScreen({super.key, required this.service, this.heroTag});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final hasGallery = widget.service.galleryImages.isNotEmpty;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Service Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Gallery / 360 View Area
            Hero(
              tag: widget.heroTag ?? 'service-${widget.service.id}',
              child: Container(
                height: 300,
                color: AppColors.surfaceLight,
                child: hasGallery 
                  ? Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        PageView.builder(
                          itemCount: widget.service.galleryImages.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentImageIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            final imgPath = widget.service.galleryImages[index];
                            return imgPath.startsWith('http')
                              ? Image.network(
                                  imgPath,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => 
                                    const Center(child: Icon(Icons.broken_image, size: 50, color: AppColors.textSecondary)),
                                )
                              : Image.asset(
                                  imgPath,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => 
                                    const Center(child: Icon(Icons.broken_image, size: 50, color: AppColors.textSecondary)),
                                );
                          },
                        ),
                        // Dot indicators
                        Positioned(
                          bottom: 16,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              widget.service.galleryImages.length,
                              (index) => AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                width: _currentImageIndex == index ? 24 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: _currentImageIndex == index ? AppColors.goldAccent : Colors.white54,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : (widget.service.imageUrl.startsWith('http')
                      ? Image.network(
                          widget.service.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => 
                            const Center(child: Icon(Icons.broken_image, size: 50, color: AppColors.textSecondary)),
                        )
                      : Image.asset(
                          widget.service.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => 
                            const Center(child: Icon(Icons.broken_image, size: 50, color: AppColors.textSecondary)),
                        )),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.service.name,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        '₹${widget.service.price.toInt()}',
                        style: const TextStyle(
                          color: AppColors.goldAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.service.durationMinutes} minutes',
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          widget.service.category,
                          style: const TextStyle(color: AppColors.goldAccent, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.service.description,
                    style: const TextStyle(color: AppColors.textSecondary, height: 1.5),
                  ),
                  
                  if (hasGallery) ...[
                    const SizedBox(height: 32),
                    Text(
                      '360° Style View',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Swipe the image gallery above to view this style from different angles.',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                  
                  const SizedBox(height: 48), // Bottom padding
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              // Navigate to booking flow, optionally pre-selecting this service
              context.push('/booking'); 
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: AppColors.goldAccent,
            ),
            child: const Text(
              'BOOK THIS SERVICE',
              style: TextStyle(color: AppColors.background, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
