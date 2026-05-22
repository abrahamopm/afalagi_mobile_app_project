import '../../../../core/network/network_info.dart';
import '../../../../core/repositories/cached_repository.dart';
import '../../domain/entities/tag_entity.dart';
import '../../domain/repositories/tag_repository.dart';
import '../datasources/tag_local_ds.dart';
import '../datasources/tag_remote_ds.dart';
import '../models/tag_model.dart';

class TagRepositoryImpl extends CachedRepository<TagEntity, TagModel>
    implements TagRepository {
  TagRepositoryImpl({
    required TagRemoteDS remote,
    required TagLocalDS local,
    required NetworkInfo networkInfo,
  }) : super(
          remote: remote,
          local: local,
          networkInfo: networkInfo,
        );
}
