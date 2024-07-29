import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  static final DB instance = DB._init();

  static Database? _database;

  DB._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('children.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
CREATE TABLE children (
  id $idType,
  name $textType,
  nationalId $textType,
  dob $textType,
  email $textType,
  password $textType,
  surgeryInfo $textType,
  parentId $textType
)
''');
  }

  Future<void> addChild(Map<String, dynamic> child) async {
    final db = await instance.database;
    await db.insert('children', child);
  }

  Future<List<Map<String, dynamic>>> getChildrenByParentId(String parentId) async {
    final db = await instance.database;
    final result = await db.query(
      'children',
      where: 'parentId = ?',
      whereArgs: [parentId],
    );

    return result;
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
