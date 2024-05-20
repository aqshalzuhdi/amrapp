part of 'model.dart';

const dbName = 'test.db';

void migrate() async {
  final db = SqliteDatabase(path: dbName);
  final migrations = SqliteMigrations()
    ..add(SqliteMigration(2, (tx) async {
      // await tx.execute(
      //     'CREATE TABLE test_data(id INTEGER PRIMARY KEY AUTOINCREMENT, data TEXT)');
      await tx.execute(
          'CREATE TABLE devices(id INTEGER PRIMARY KEY AUTOINCREMENT, amr_id TEXT, pointer_img TEXT, status INTEGER)');
    }));

  await migrations.migrate(db);
}

void insertBatch(
    {required String tableName,
    required String column,
    required String values,
    required List<Object?> parameter}) async {
  final db = SqliteDatabase(path: dbName);
  // Use execute() or executeBatch() for INSERT/UPDATE/DELETE statements
  await db.executeBatch(
      'INSERT INTO $tableName($column) values($values)', [parameter]);

  await db.close();
}

void deleteBatch(
    {required String tableName,
    required String column,
    required String values,
    required List<Object?> id}) async {
  final db = SqliteDatabase(path: dbName);
  // Use execute() or executeBatch() for INSERT/UPDATE/DELETE statements
  await db.executeBatch('DELETE FROM $tableName WHERE id = ?', [id]);

  await db.close();
}

void updateBatch(
    {required String tableName,
    required String parameter,
    required List<Object?> id}) async {
  final db = SqliteDatabase(path: dbName);
  // Use execute() or executeBatch() for INSERT/UPDATE/DELETE statements
  await db.executeBatch('UPDATE $tableName SET $parameter WHERE id = ?', [id]);

  await db.close();
}

Future<ResultSet> get({required String tableName}) async {
  final db = SqliteDatabase(path: dbName);

  var result = await db.getAll(('SELECT * FROM ') + tableName);
  await db.close();

  return result;
  // print('Results: $results');
}
