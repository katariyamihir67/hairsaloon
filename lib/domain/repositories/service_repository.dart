import '../entities/service_entity.dart';

abstract class ServiceRepository {
  Future<List<ServiceEntity>> getServices();
  Future<ServiceEntity?> getServiceById(String id);
  Future<List<ServiceEntity>> getServicesByCategory(String category);
}
