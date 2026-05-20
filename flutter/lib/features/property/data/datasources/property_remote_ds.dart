import 'package:dio/dio.dart';
import '../../../../core/constants/Constants.dart';
import '../../../../core/datasources/base_remote_data_source.dart';
import '../models/property_model.dart';

class PropertyRemoteDS extends BaseRemoteDataSource<PropertyModel> {
  PropertyRemoteDS(Dio dio)
      : super(
          dio: dio,
          endpoint: AppConstants.properties,
          fromJson: PropertyModel.fromJson,
        );
}
