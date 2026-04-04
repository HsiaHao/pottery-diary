import 'package:drift/drift.dart';
import 'package:pottery_diary/database/app_database.dart';
import 'package:pottery_diary/models/stage_type.dart';

class PieceRepository {
  const PieceRepository(this._db);

  final AppDatabase _db;

  // ---------------------------------------------------------------------------
  // Pieces
  // ---------------------------------------------------------------------------

  Future<List<Piece>> getAllPieces() =>
      (_db.select(_db.pieces)..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Stream<List<Piece>> watchAllPieces() =>
      (_db.select(_db.pieces)..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .watch();

  Future<Piece?> getPieceById(int id) =>
      (_db.select(_db.pieces)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> createPiece({required String title, String? description}) {
    final now = DateTime.now();
    return _db.into(_db.pieces).insert(
          PiecesCompanion.insert(
            title: title,
            description: Value(description),
            createdAt: now,
            updatedAt: now,
          ),
        );
  }

  Future<void> updatePiece(
    int id, {
    String? title,
    String? description,
  }) =>
      (_db.update(_db.pieces)..where((t) => t.id.equals(id))).write(
        PiecesCompanion(
          title: title != null ? Value(title) : const Value.absent(),
          description:
              description != null ? Value(description) : const Value.absent(),
          updatedAt: Value(DateTime.now()),
        ),
      );

  Future<int> deletePiece(int id) =>
      (_db.delete(_db.pieces)..where((t) => t.id.equals(id))).go();

  // ---------------------------------------------------------------------------
  // Stages
  // ---------------------------------------------------------------------------

  Future<List<Stage>> getStagesForPiece(int pieceId) =>
      (_db.select(_db.stages)..where((t) => t.pieceId.equals(pieceId))).get();

  Future<int> createStage({
    required int pieceId,
    required StageType stageType,
    String? description,
  }) =>
      _db.into(_db.stages).insert(
            StagesCompanion.insert(
              pieceId: pieceId,
              stageType: stageType.name,
              description: Value(description),
              recordedAt: DateTime.now(),
            ),
          );

  Future<void> updateStageDescription(int stageId, String description) =>
      (_db.update(_db.stages)..where((t) => t.id.equals(stageId))).write(
        StagesCompanion(description: Value(description)),
      );

  Future<void> completeStage(int stageId) =>
      (_db.update(_db.stages)..where((t) => t.id.equals(stageId))).write(
        StagesCompanion(completedAt: Value(DateTime.now())),
      );

  // ---------------------------------------------------------------------------
  // Photos
  // ---------------------------------------------------------------------------

  Future<List<Photo>> getPhotosForStage(int stageId) =>
      (_db.select(_db.photos)..where((t) => t.stageId.equals(stageId))).get();

  Future<int> addPhoto({
    required int stageId,
    required String localPath,
    String? caption,
  }) =>
      _db.into(_db.photos).insert(
            PhotosCompanion.insert(
              stageId: stageId,
              localPath: localPath,
              caption: Value(caption),
              recordedAt: DateTime.now(),
            ),
          );

  Future<int> deletePhoto(int photoId) =>
      (_db.delete(_db.photos)..where((t) => t.id.equals(photoId))).go();

  // ---------------------------------------------------------------------------
  // Glazes (free-text, MVP Option A)
  // ---------------------------------------------------------------------------

  Future<List<PieceGlaze>> getGlazesForPiece(int pieceId) =>
      (_db.select(_db.pieceGlazes)
            ..where((t) => t.pieceId.equals(pieceId)))
          .get();

  Future<void> addGlazeToPiece(int pieceId, String glazeName) =>
      _db.into(_db.pieceGlazes).insert(
            PieceGlazesCompanion.insert(
              pieceId: pieceId,
              glazeName: glazeName,
            ),
            mode: InsertMode.insertOrIgnore,
          );

  Future<int> removeGlazeFromPiece(int pieceId, String glazeName) =>
      (_db.delete(_db.pieceGlazes)
            ..where(
              (t) =>
                  t.pieceId.equals(pieceId) & t.glazeName.equals(glazeName),
            ))
          .go();
}
