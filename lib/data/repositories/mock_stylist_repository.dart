import '../../domain/entities/stylist_entity.dart';
import '../../domain/repositories/stylist_repository.dart';

class MockStylistRepository implements StylistRepository {
  final List<StylistEntity> _stylists = [
    StylistEntity(
      id: '1',
      name: 'Rahul Sharma',
      specialization: 'Hair Color & Styling',
      experienceYears: 8,
      rating: 4.9,
      reviewsCount: 340,
      imageUrl: 'assets/images/stylist.jpg',
    ),
    StylistEntity(
      id: '2',
      name: 'Anita Desai',
      specialization: 'Bridal & Spa',
      experienceYears: 12,
      rating: 4.8,
      reviewsCount: 512,
      imageUrl: 'assets/images/stylist.jpg', // Placeholder
    ),
  ];

  @override
  Future<List<StylistEntity>> getStylists() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _stylists;
  }

  @override
  Future<StylistEntity?> getStylistById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _stylists.firstWhere((stylist) => stylist.id == id);
    } catch (e) {
      return null;
    }
  }
}
