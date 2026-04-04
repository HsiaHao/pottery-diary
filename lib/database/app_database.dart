import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

// ---------------------------------------------------------------------------
// Tables
// ---------------------------------------------------------------------------

class Pieces extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

class Stages extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get pieceId =>
      integer().references(Pieces, #id, onDelete: KeyAction.cascade)();
  // Stored as StageType.name string: 'trimmed' | 'bisque' | 'glazeFired'
  TextColumn get stageType => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get recordedAt => dateTime()();
}

class Photos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get stageId =>
      integer().references(Stages, #id, onDelete: KeyAction.cascade)();
  TextColumn get localPath => text()();
  TextColumn get caption => text().nullable()();
  DateTimeColumn get recordedAt => dateTime()();
}

/// Free-text glaze tags associated with a piece (MVP Option A).
class PieceGlazes extends Table {
  IntColumn get pieceId =>
      integer().references(Pieces, #id, onDelete: KeyAction.cascade)();
  TextColumn get glazeName => text()();

  @override
  Set<Column> get primaryKey => {pieceId, glazeName};
}

// ---------------------------------------------------------------------------
// Database
// ---------------------------------------------------------------------------

@DriftDatabase(tables: [Pieces, Stages, Photos, PieceGlazes])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          // Enable foreign key cascade support in SQLite.
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}

// ---------------------------------------------------------------------------
// Connection helpers
// ---------------------------------------------------------------------------

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'pottery_diary.db'));
    return NativeDatabase.createInBackground(file);
  });
}

/// Opens the production on-disk database.
AppDatabase openDatabase() => AppDatabase(_openConnection());

/// Opens an in-memory database for unit tests.
AppDatabase openTestDatabase() => AppDatabase(NativeDatabase.memory());
