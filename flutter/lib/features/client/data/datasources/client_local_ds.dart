import '../../../../core/database/database_helper.dart';
import '../../../../core/database/database_tables.dart';
import '../../../../core/datasources/base_local_data_source.dart';
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
