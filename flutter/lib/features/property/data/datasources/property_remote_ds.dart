import 'package:dio/dio.dart';
import '../../../../Core/constants/constants.dart';
import '../../../../Core/datasources/base_remote_data_source.dart';
import '../models/property_model.dart';

class PropertyRemoteDS extends BaseRemoteDataSource<PropertyModel> {
  PropertyRemoteDS(Dio dio)
      : super(
          dio: dio,
          endpoint: AppConstants.properties,
          fromJson: PropertyModel.fromJson,
        );
}
