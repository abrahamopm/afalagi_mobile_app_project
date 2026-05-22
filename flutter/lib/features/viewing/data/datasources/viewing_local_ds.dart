import '../../../../core/database/database_helper.dart';
import '../../../../core/database/database_tables.dart';
import '../../../../core/datasources/base_local_data_source.dart';
import '../models/viewing_model.dart';

class ViewingLocalDS extends BaseLocalDataSource<ViewingModel> {
  ViewingLocalDS(DatabaseHelper dbHelper)
      : super(
          dbHelper: dbHelper,
          tableName: DatabaseTables.viewings,
          fromMap: ViewingModel.fromMap,
          toMap: (v) => v.toMap(),
        );
}
