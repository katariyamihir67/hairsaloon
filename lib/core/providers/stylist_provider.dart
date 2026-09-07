import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/stylist_repository.dart';
import '../../data/repositories/mock_stylist_repository.dart';
import '../../domain/entities/stylist_entity.dart';

final stylistRepositoryProvider = Provider<StylistRepository>((ref) {
  return MockStylistRepository();
});

final stylistsProvider = FutureProvider<List<StylistEntity>>((ref) async {
  final repository = ref.read(stylistRepositoryProvider);
  return repository.getStylists();
});
