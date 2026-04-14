import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/visit_model.dart';

abstract class VisitLocalDataSource {
  Future<List<VisitModel>> getAllVisits();
  Future<void> insertVisit(VisitModel visit);
  Future<void> updateVisit(VisitModel visit);
  Future<void> deleteVisit(int id);
}

class VisitLocalDataSourceImpl implements VisitLocalDataSource {
  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'visits.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE visits (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            visited_person_name TEXT NOT NULL,
            visitor_name TEXT NOT NULL,
            visit_date TEXT NOT NULL,
            description TEXT NOT NULL,
            visit_again INTEGER NOT NULL DEFAULT 0,
            next_visit_date TEXT,
            next_visit_reason TEXT
          )
        ''');
      },
    );
  }

  @override
  Future<List<VisitModel>> getAllVisits() async {
    final db = await database;
    final maps = await db.query('visits', orderBy: 'visit_date DESC');
    return maps.map((map) => VisitModel.fromMap(map)).toList();
  }

  @override
  Future<void> insertVisit(VisitModel visit) async {
    final db = await database;
    await db.insert(
      'visits',
      visit.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updateVisit(VisitModel visit) async {
    final db = await database;
    await db.update(
      'visits',
      visit.toMap(),
      where: 'id = ?',
      whereArgs: [visit.id],
    );
  }

  @override
  Future<void> deleteVisit(int id) async {
    final db = await database;
    await db.delete(
      'visits',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
