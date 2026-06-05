import 'package:dio/dio.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/datasources/base_remote_data_source.dart';
import '../models/viewing_model.dart';

class ViewingRemoteDS extends BaseRemoteDataSource<ViewingModel> {
  ViewingRemoteDS(Dio dio)
      : super(
          dio: dio,
          endpoint: AppConstants.viewings,
          fromJson: ViewingModel.fromJson,
        );
}
