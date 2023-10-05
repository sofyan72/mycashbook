import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;
  static const int _databaseVersion = 1;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'buku_kas.db');
    // print('Database path: $path');

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE pemasukan(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tanggal TEXT NOT NULL,
        nominal INTEGER NOT NULL,
        keterangan TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE pengeluaran(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tanggal_pengeluaran TEXT NOT NULL,
        nominal_pengeluaran INTEGER NOT NULL,
        keterangan_pengeluaran TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE User (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT,
        password TEXT
      )
    ''');

    // Add an initial user (username: 'user', password: 'password')
    await db.rawInsert('INSERT INTO User (username, password) VALUES (?, ?)',
        ['user', 'user']);
  }

  Future<int> updatePassword(String username, String newPassword) async {
    Database db = await instance.database;

    return await db.update(
      'User',
      {'password': newPassword},
      where: 'username = ?',
      whereArgs: [username],
    );
  }

  Future<int> insertPemasukan(Map<String, dynamic> pemasukan) async {
    Database db = await instance.database;
    return await db.insert('pemasukan', pemasukan);
  }

  Future<int> insertPengeluaran(Map<String, dynamic> pengeluaran) async {
    Database db = await instance.database;
    return await db.insert('pengeluaran', pengeluaran);
  }

  Future<List<Map<String, dynamic>>> getPemasukan() async {
    Database db = await instance.database;
    return await db.query('pemasukan');
  }

  Future<List<Map<String, dynamic>>> getPengeluaran() async {
    Database db = await instance.database;
    return await db.query('pengeluaran');
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    Database db = await instance.database;
    return await db.insert('User', user);
  }

  Future<Map<String, dynamic>?> getUser(
      String username, String password) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query(
      'User',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<int> getTotalPemasukan() async {
    Database db = await instance.database;

    final result =
        await db.rawQuery('SELECT SUM(nominal) as total FROM pemasukan');

    int total = Sqflite.firstIntValue(result)!;
    return total;
  }

  Future<int> getTotalPengeluaran() async {
    Database db = await instance.database;

    final result = await db
        .rawQuery('SELECT SUM(nominal_pengeluaran) as total FROM pengeluaran');

    int total = Sqflite.firstIntValue(result)!;
    return total;
  }
}
