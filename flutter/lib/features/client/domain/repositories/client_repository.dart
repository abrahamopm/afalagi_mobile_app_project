import '../entities/client_entity.dart';

abstract class ClientRepository {
  Future<List<ClientEntity>> getAll();
  Future<ClientEntity> getById(String id);
  Future<ClientEntity> create(Map<String, dynamic> body);
  Future<ClientEntity> update(String id, Map<String, dynamic> body);
  Future<void> delete(String id);
}
