import '../../../../core/network/network_info.dart';
import '../../../../core/repositories/cached_repository.dart';
import '../../domain/entities/property_entity.dart';
import '../../domain/repositories/property_repository.dart';
import '../datasources/property_local_ds.dart';
import '../datasources/property_remote_ds.dart';
import '../models/property_model.dart';

class PropertyRepositoryImpl extends CachedRepository<PropertyEntity, PropertyModel>
    implements PropertyRepository {
  PropertyRepositoryImpl({
    required PropertyRemoteDS remote,
    required PropertyLocalDS local,
    required super.networkInfo,
  }) : super(
          remote: remote,
          local: local,
        );
}
