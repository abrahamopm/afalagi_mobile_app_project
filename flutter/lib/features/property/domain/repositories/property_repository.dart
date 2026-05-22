import '../entities/property_entity.dart';

abstract class PropertyRepository {
  Future<List<PropertyEntity>> getAll();
  Future<PropertyEntity> getById(String id);
  Future<PropertyEntity> create(Map<String, dynamic> body);
  Future<PropertyEntity> update(String id, Map<String, dynamic> body);
  Future<void> delete(String id);
}
