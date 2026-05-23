import 'package:dio/dio.dart';
import '../../../../Core/constants/constants.dart';
import '../../../../Core/datasources/base_remote_data_source.dart';
import '../models/viewing_model.dart';

class ViewingRemoteDS extends BaseRemoteDataSource<ViewingModel> {
  ViewingRemoteDS(Dio dio)
      : super(
          dio: dio,
          endpoint: AppConstants.viewings,
          fromJson: ViewingModel.fromJson,
        );
}
