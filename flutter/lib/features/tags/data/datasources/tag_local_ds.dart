import '../../../../core/database/database_helper.dart';
import '../../../../core/database/database_tables.dart';
import '../../../../core/datasources/base_local_data_source.dart';
import '../models/tag_model.dart';

class TagLocalDS extends BaseLocalDataSource<TagModel> {
  TagLocalDS(DatabaseHelper dbHelper)
      : super(
          dbHelper: dbHelper,
          tableName: DatabaseTables.tags,
          fromMap: TagModel.fromMap,
          toMap: (t) => t.toMap(),
        );
}
