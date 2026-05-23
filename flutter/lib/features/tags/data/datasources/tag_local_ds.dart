import '../../../../Core/database/database_helper.dart';
import '../../../../Core/database/database_tables.dart';
import '../../../../Core/datasources/base_local_data_source.dart';
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
