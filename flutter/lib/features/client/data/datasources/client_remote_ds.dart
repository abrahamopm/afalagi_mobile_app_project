import 'package:dio/dio.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/datasources/base_remote_data_source.dart';
import '../models/client_model.dart';

class ClientRemoteDS extends BaseRemoteDataSource<ClientModel> {
  ClientRemoteDS(Dio dio)
      : super(
          dio: dio,
          endpoint: AppConstants.clients,
          fromJson: ClientModel.fromJson,
        );
}
