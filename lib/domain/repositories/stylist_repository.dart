import '../entities/stylist_entity.dart';

abstract class StylistRepository {
  Future<List<StylistEntity>> getStylists();
  Future<StylistEntity?> getStylistById(String id);
}
