import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/service_repository.dart';
import '../../data/repositories/mock_service_repository.dart';
import '../../domain/entities/service_entity.dart';

// Provider for the repository
final serviceRepositoryProvider = Provider<ServiceRepository>((ref) {
  return MockServiceRepository();
});

// FutureProvider to fetch all services
final servicesProvider = FutureProvider<List<ServiceEntity>>((ref) async {
  final repository = ref.read(serviceRepositoryProvider);
  return repository.getServices();
});
