import '../../../../Core/database/database_helper.dart';
import '../../../../Core/database/database_tables.dart';
import '../../../../Core/datasources/base_local_data_source.dart';
import '../models/client_model.dart';

class ClientLocalDS extends BaseLocalDataSource<ClientModel> {
  ClientLocalDS(DatabaseHelper dbHelper)
      : super(
          dbHelper: dbHelper,
          tableName: DatabaseTables.clients,
          fromMap: ClientModel.fromMap,
          toMap: (c) => c.toMap(),
        );
}
