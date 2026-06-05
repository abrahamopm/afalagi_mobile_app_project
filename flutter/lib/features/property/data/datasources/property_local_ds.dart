import '../../../../core/database/database_helper.dart';
import '../../../../core/database/database_tables.dart';
import '../../../../core/datasources/base_local_data_source.dart';
import '../models/property_model.dart';

class PropertyLocalDS extends BaseLocalDataSource<PropertyModel> {
  PropertyLocalDS(DatabaseHelper dbHelper)
      : super(
          dbHelper: dbHelper,
          tableName: DatabaseTables.properties,
          fromMap: PropertyModel.fromMap,
          toMap: (p) => p.toMap(),
        );
}
