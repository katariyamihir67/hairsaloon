import '../../domain/entities/service_entity.dart';
import '../../domain/repositories/service_repository.dart';

class MockServiceRepository implements ServiceRepository {
  final List<ServiceEntity> _services = [
    // MALE SERVICES
    ServiceEntity(
      id: 'm1',
      name: 'Men\'s Signature Fade',
      category: 'Haircut',
      gender: 'Male',
      description: 'Premium fade haircut with precision styling and wash. Gives a sharp and clean look.',
      price: 1200.0,
      durationMinutes: 45,
      imageUrl: 'assets/images/mens_signature_fade_1788719100547.jpg',
      galleryImages: [
        'assets/images/mens_signature_fade_1788719100547.jpg',
        'assets/images/mens_signature_fade_1788719100547.jpg', // Duplicated for gallery effect
      ],
    ),
    ServiceEntity(
      id: 'm2',
      name: 'Gentleman\'s Classic Cut',
      category: 'Haircut',
      gender: 'Male',
      description: 'A timeless classic scissor cut, tailored to your head shape.',
      price: 1500.0,
      durationMinutes: 45,
      imageUrl: 'assets/images/mens_classic_cut_1788719114039.jpg',
      galleryImages: [
        'assets/images/mens_classic_cut_1788719114039.jpg',
      ],
    ),
    ServiceEntity(
      id: 'm3',
      name: 'Luxury Beard Trim & Spa',
      category: 'Beard',
      gender: 'Male',
      description: 'Complete beard grooming with hot towel and essential oils.',
      price: 800.0,
      durationMinutes: 30,
      imageUrl: 'assets/images/mens_beard_trim_1788719124431.jpg',
      galleryImages: [
        'assets/images/mens_beard_trim_1788719124431.jpg',
      ],
    ),
    ServiceEntity(
      id: 'm4',
      name: 'Buzz Cut & Line Up',
      category: 'Haircut',
      gender: 'Male',
      description: 'Sharp buzz cut with precise line up.',
      price: 900.0,
      durationMinutes: 30,
      imageUrl: 'assets/images/mens_buzz_cut_1788719143321.jpg',
      galleryImages: [
        'assets/images/mens_buzz_cut_1788719143321.jpg',
      ],
    ),
    ServiceEntity(
      id: 'm5',
      name: 'Men\'s Hair Spa & Massage',
      category: 'Hair Spa',
      gender: 'Male',
      description: 'Relaxing head massage and deep conditioning spa treatment.',
      price: 1800.0,
      durationMinutes: 60,
      imageUrl: 'assets/images/spa.jpg', // Fallback to existing spa image
      galleryImages: [
        'assets/images/spa.jpg',
      ],
    ),
    // FEMALE SERVICES
    ServiceEntity(
      id: 'f1',
      name: 'Women\'s Signature Layer Cut',
      category: 'Haircut',
      gender: 'Female',
      description: 'Beautiful layered haircut with blow dry setting.',
      price: 1800.0,
      durationMinutes: 60,
      imageUrl: 'assets/images/womens_layer_cut_1788719425375.jpg',
      galleryImages: [
        'assets/images/womens_layer_cut_1788719425375.jpg',
        'assets/images/womens_layer_cut_1788719425375.jpg', // Duplicated for gallery effect
      ],
    ),
    ServiceEntity(
      id: 'f2',
      name: 'Keratin Hair Spa',
      category: 'Hair Spa',
      gender: 'Female',
      description: 'Deep conditioning keratin treatment for smooth, frizz-free hair.',
      price: 3500.0,
      durationMinutes: 90,
      imageUrl: 'assets/images/womens_keratin_spa_1788719436978.jpg',
      galleryImages: [
        'assets/images/womens_keratin_spa_1788719436978.jpg',
      ],
    ),
    ServiceEntity(
      id: 'f3',
      name: 'Balayage Color',
      category: 'Hair Color',
      gender: 'Female',
      description: 'Premium custom balayage color transformation.',
      price: 6000.0,
      durationMinutes: 120,
      imageUrl: 'assets/images/womens_balayage_1788719448747.jpg',
      galleryImages: [
        'assets/images/womens_balayage_1788719448747.jpg',
        'assets/images/womens_balayage_1788719448747.jpg', // Duplicated for gallery effect
      ],
    ),
    ServiceEntity(
      id: 'f4',
      name: 'Bob Cut & Styling',
      category: 'Haircut',
      gender: 'Female',
      description: 'Chic bob cut with professional styling and setting.',
      price: 2000.0,
      durationMinutes: 60,
      imageUrl: 'assets/images/womens_bob_cut_1788719460463.jpg',
      galleryImages: [
        'assets/images/womens_bob_cut_1788719460463.jpg',
      ],
    ),
    ServiceEntity(
      id: 'f5',
      name: 'Bridal Hair Styling',
      category: 'Styling',
      gender: 'Female',
      description: 'Elegant updo and bridal styling with accessories.',
      price: 5000.0,
      durationMinutes: 120,
      imageUrl: 'assets/images/haircut.jpg', // Fallback to existing image
      galleryImages: [
        'assets/images/haircut.jpg',
      ],
    ),
  ];

  @override
  Future<List<ServiceEntity>> getServices() async {
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network
    return _services;
  }

  @override
  Future<ServiceEntity?> getServiceById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _services.firstWhere((service) => service.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<ServiceEntity>> getServicesByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _services.where((service) => service.category == category).toList();
  }
}
