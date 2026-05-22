import '../entities/viewing_entity.dart';

abstract class ViewingRepository {
  Future<List<ViewingEntity>> getAll();
  Future<ViewingEntity> getById(String id);
  Future<ViewingEntity> create(Map<String, dynamic> body);
  Future<ViewingEntity> update(String id, Map<String, dynamic> body);
  Future<void> delete(String id);
}
