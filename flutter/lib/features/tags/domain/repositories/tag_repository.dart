import '../entities/tag_entity.dart';

abstract class TagRepository {
  Future<List<TagEntity>> getAll();
  Future<TagEntity> getById(String id);
  Future<TagEntity> create(Map<String, dynamic> body);
  Future<TagEntity> update(String id, Map<String, dynamic> body);
  Future<void> delete(String id);
}
