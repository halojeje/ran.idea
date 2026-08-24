import 'package:path/path.dart';
import 'package:ran_idea_flutter/day_20/models/usermodel.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();

  factory DBHelper() {
    return _instance;
  }

  DBHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final pathDatabase = join(databasePath, 'ran_idea.db');

    return await openDatabase(pathDatabase, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        nomor_hp TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');
    print(">>> TABEL USERS BERHASIL DIBUAT DILOKASI SQLITE <<<");
  }

  // REGISTRASI USER (FIXED) //
  Future<bool> registerUser(UserModelSQL user) async {
    try {
      final db = await database;

      // Konversi ke Map
      final userMap = user.toMap();

      // HApus key 'id' agar SQLite otomatis generate AUTOINCREMENT ID!
      userMap.remove('id');

      // Bersihkan email dan password
      userMap['email'] = user.email.toLowerCase().trim();
      userMap['password'] = user.password.trim();

      final result = await db.insert(
        'users',
        userMap,
        conflictAlgorithm: ConflictAlgorithm.abort,
      );

      print(">>> SUCCESS REGISTER: User ID $result tersimpan! <<<");
      return result > 0;
    } catch (e) {
      print('>>> ERROR REGISTER USER: $e <<<');
      return false;
    }
  }

  // LOGIN //
  Future<UserModelSQL?> loginUser(String email, String password) async {
    try {
      final db = await database;

      final cleanEmail = email.toLowerCase().trim();
      final cleanPassword = password.trim();

      print(">>> COBA LOGIN: $cleanEmail | Pass: $cleanPassword <<<");

      final result = await db.query(
        'users',
        where: 'LOWER(TRIM(email)) = ? AND TRIM(password) = ?',
        whereArgs: [cleanEmail, cleanPassword],
        limit: 1,
      );

      if (result.isNotEmpty) {
        print(">>> SUCCESS LOGIN: User ditemukan! <<<");
        return UserModelSQL.fromMap(result.first);
      } else {
        print(">>> GAGAL LOGIN: Data tidak ada di database! <<<");
      }
      return null;
    } catch (e) {
      print('>>> ERROR LOGIN USER: $e <<<');
      return null;
    }
  }

  Future<List<UserModelSQL>> getUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      orderBy: 'id DESC',
    );

    return List.generate(maps.length, (index) {
      return UserModelSQL.fromMap(maps[index]);
    });
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }
}
