import 'package:dio/dio.dart';
import '../../../../Core/constants/constants.dart';
import '../../../../Core/datasources/base_remote_data_source.dart';
import '../models/client_model.dart';

class ClientRemoteDS extends BaseRemoteDataSource<ClientModel> {
  ClientRemoteDS(Dio dio)
      : super(
          dio: dio,
          endpoint: AppConstants.clients,
          fromJson: ClientModel.fromJson,
        );
}
