import '../../../../core/network/network_info.dart';
import '../../../../core/repositories/cached_repository.dart';
import '../../domain/entities/viewing_entity.dart';
import '../../domain/repositories/viewing_repository.dart';
import '../datasources/viewing_local_ds.dart';
import '../datasources/viewing_remote_ds.dart';
import '../models/viewing_model.dart';

class ViewingRepositoryImpl extends CachedRepository<ViewingEntity, ViewingModel>
    implements ViewingRepository {
  ViewingRepositoryImpl({
    required ViewingRemoteDS remote,
    required ViewingLocalDS local,
    required super.networkInfo,
  }) : super(
          remote: remote,
          local: local,
        );
}
