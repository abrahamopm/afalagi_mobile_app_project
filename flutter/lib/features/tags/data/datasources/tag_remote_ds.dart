import 'package:dio/dio.dart';
import '../../../../core/constants/Constants.dart';
import '../../../../core/datasources/base_remote_data_source.dart';
import '../models/tag_model.dart';

class TagRemoteDS extends BaseRemoteDataSource<TagModel> {
  TagRemoteDS(Dio dio)
      : super(
          dio: dio,
          endpoint: AppConstants.tags,
          fromJson: TagModel.fromJson,
        );
}
