class ServiceEntity {
  final String id;
  final String name;
  final String category;
  final String gender;
  final String description;
  final double price;
  final int durationMinutes;
  final String imageUrl;
  final List<String> galleryImages;

  ServiceEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.gender,
    required this.description,
    required this.price,
    required this.durationMinutes,
    required this.imageUrl,
    this.galleryImages = const [],
  });
}
