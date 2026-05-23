import '../../../../core/repositories/cached_repository.dart';
import '../../domain/entities/client_entity.dart';
import '../../domain/repositories/client_repository.dart';
import '../datasources/client_local_ds.dart';
import '../datasources/client_remote_ds.dart';
import '../models/client_model.dart';

class ClientRepositoryImpl extends CachedRepository<ClientEntity, ClientModel>
    implements ClientRepository {
  ClientRepositoryImpl({
    required ClientRemoteDS remote,
    required ClientLocalDS local,
    required super.networkInfo,
  }) : super(
          remote: remote,
          local: local,
        );
}
