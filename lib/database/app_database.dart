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
  TextColumn get coverPhotoPath => text().nullable()();
  TextColumn get clayBody => text().nullable()();
  TextColumn get firingTemp => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

class Stages extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get pieceId =>
      integer().references(Pieces, #id, onDelete: KeyAction.cascade)();
  // Stored as StageType.name string: 'trimmed' | 'bisque' | 'glazeFired'
  TextColumn get stageType => text()();
  TextColumn get title => text().nullable()();
  TextColumn get description => text().nullable()();
  // StageStatus.name: 'inProgress' | 'complete' | 'failed'
  TextColumn get status =>
      text().withDefault(const Constant('inProgress'))();
  TextColumn get failureReason => text().nullable()();
  // Set when status transitions to complete or failed
  DateTimeColumn get finishedAt => dateTime().nullable()();
  // Kept for migration only; use finishedAt + status going forward
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
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(pieces, pieces.coverPhotoPath);
            await m.addColumn(pieces, pieces.clayBody);
            await m.addColumn(pieces, pieces.firingTemp);
            await m.addColumn(stages, stages.title);
          }
          if (from < 3) {
            await m.addColumn(stages, stages.status);
            await m.addColumn(stages, stages.failureReason);
            await m.addColumn(stages, stages.finishedAt);
            // Migrate existing completedAt → finishedAt + status='complete'
            await customStatement(
              "UPDATE stages SET finished_at = completed_at, status = 'complete' "
              'WHERE completed_at IS NOT NULL',
            );
          }
        },
        beforeOpen: (details) async {
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
