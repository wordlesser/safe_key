import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../shared/models/password_entry.dart';
import '../crypto/encryption_service.dart';

class DatabaseService {
  DatabaseService._();
  static final DatabaseService instance = DatabaseService._();

  Database? _db;
  static const String _tableName = 'password_entries';

  Future<Database> get _database async {
    _db ??= await _initDb();
    return _db!;
  }

  /// 检测数据库文件是否实际存在于磁盘（卸载重装后文件会消失）
  Future<bool> databaseFileExists() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'safekey.db');
    return File(path).exists();
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'safekey.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            category TEXT NOT NULL,
            username TEXT NOT NULL,
            password TEXT NOT NULL,
            url TEXT DEFAULT '',
            note TEXT DEFAULT '',
            created_at INTEGER NOT NULL,
            updated_at INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  // ── CRUD ────────────────────────────────────────────────────────

  Future<void> insert(PasswordEntry entry, Uint8List keyBytes) async {
    final db = await _database;
    final encPwd = EncryptionService.encryptData(entry.password, keyBytes);
    await db.insert(
      _tableName,
      entry.toDbMap(encryptedPassword: encPwd),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> update(PasswordEntry entry, Uint8List keyBytes) async {
    final db = await _database;
    final encPwd = EncryptionService.encryptData(entry.password, keyBytes);
    await db.update(
      _tableName,
      entry.toDbMap(encryptedPassword: encPwd),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  Future<void> delete(String id) async {
    final db = await _database;
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<PasswordEntry>> getAll(Uint8List keyBytes) async {
    final db = await _database;
    final rows = await db.query(_tableName, orderBy: 'updated_at DESC');
    return rows.map((row) {
      final decPwd = EncryptionService.decryptData(
        row['password'] as String,
        keyBytes,
      );
      return PasswordEntry.fromDbMap(row, decryptedPassword: decPwd);
    }).toList();
  }

  // ── 备份 / 恢复 ────────────────────────────────────────────────

  /// 导出所有条目（密码字段仍保持加密状态），整体 JSON 再用主密码加密
  Future<String> exportEncrypted(Uint8List keyBytes) async {
    final db = await _database;
    final rows = await db.query(_tableName, orderBy: 'created_at ASC');
    final jsonStr = jsonEncode(rows);
    return EncryptionService.encryptData(jsonStr, keyBytes);
  }

  /// 从备份恢复：解密后写入数据库（覆盖同 id 条目）
  Future<int> importEncrypted(
    String encryptedBackup,
    Uint8List keyBytes, {
    bool replaceAll = false,
  }) async {
    final jsonStr = EncryptionService.decryptData(encryptedBackup, keyBytes);
    final rows = (jsonDecode(jsonStr) as List).cast<Map<String, dynamic>>();
    final db = await _database;

    if (replaceAll) {
      await db.delete(_tableName);
    }

    final batch = db.batch();
    for (final row in rows) {
      batch.insert(
        _tableName,
        row,
        conflictAlgorithm:
            replaceAll ? ConflictAlgorithm.replace : ConflictAlgorithm.ignore,
      );
    }
    await batch.commit(noResult: true);
    return rows.length;
  }

  Future<void> deleteAll() async {
    final db = await _database;
    await db.delete(_tableName);
  }

  Future<int> count() async {
    final db = await _database;
    final result = await db.rawQuery('SELECT COUNT(*) FROM $_tableName');
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
