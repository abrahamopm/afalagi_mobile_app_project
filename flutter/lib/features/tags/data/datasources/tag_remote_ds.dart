import 'package:dio/dio.dart';
import '../../../../Core/constants/constants.dart';
import '../../../../Core/datasources/base_remote_data_source.dart';
import '../models/tag_model.dart';

class TagRemoteDS extends BaseRemoteDataSource<TagModel> {
  TagRemoteDS(Dio dio)
      : super(
          dio: dio,
          endpoint: AppConstants.tags,
          fromJson: TagModel.fromJson,
        );
}
