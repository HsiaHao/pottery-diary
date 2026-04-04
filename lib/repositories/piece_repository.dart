import 'package:drift/drift.dart';
import 'package:pottery_diary/database/app_database.dart';
import 'package:pottery_diary/models/stage_status.dart';
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

  Stream<Piece?> watchPieceById(int id) =>
      (_db.select(_db.pieces)..where((t) => t.id.equals(id)))
          .watchSingleOrNull();

  Future<int> createPiece({
    required String title,
    String? description,
    String? coverPhotoPath,
    String? clayBody,
    String? firingTemp,
  }) {
    final now = DateTime.now();
    return _db.into(_db.pieces).insert(
          PiecesCompanion.insert(
            title: title,
            description: Value(description),
            coverPhotoPath: Value(coverPhotoPath),
            clayBody: Value(clayBody),
            firingTemp: Value(firingTemp),
            createdAt: now,
            updatedAt: now,
          ),
        );
  }

  Future<void> updatePiece(
    int id, {
    String? title,
    String? description,
    String? coverPhotoPath,
    String? clayBody,
    String? firingTemp,
  }) =>
      (_db.update(_db.pieces)..where((t) => t.id.equals(id))).write(
        PiecesCompanion(
          title: title != null ? Value(title) : const Value.absent(),
          description:
              description != null ? Value(description) : const Value.absent(),
          coverPhotoPath: coverPhotoPath != null
              ? Value(coverPhotoPath)
              : const Value.absent(),
          clayBody:
              clayBody != null ? Value(clayBody) : const Value.absent(),
          firingTemp:
              firingTemp != null ? Value(firingTemp) : const Value.absent(),
          updatedAt: Value(DateTime.now()),
        ),
      );

  Future<void> setPieceCoverPhoto(int pieceId, String localPath) =>
      (_db.update(_db.pieces)..where((t) => t.id.equals(pieceId))).write(
        PiecesCompanion(
          coverPhotoPath: Value(localPath),
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

  Stream<List<Stage>> watchStagesForPiece(int pieceId) =>
      (_db.select(_db.stages)..where((t) => t.pieceId.equals(pieceId)))
          .watch();

  Future<int> createStage({
    required int pieceId,
    required StageType stageType,
    String? title,
    String? description,
    StageStatus status = StageStatus.inProgress,
    String? failureReason,
    DateTime? finishedAt,
  }) =>
      _db.into(_db.stages).insert(
            StagesCompanion.insert(
              pieceId: pieceId,
              stageType: stageType.name,
              title: Value(title),
              description: Value(description),
              status: Value(status.name),
              failureReason: Value(failureReason),
              finishedAt: Value(finishedAt),
              recordedAt: DateTime.now(),
            ),
          );

  Future<void> updateStage(
    int stageId, {
    String? title,
    String? description,
    StageStatus? status,
    String? failureReason,
    DateTime? finishedAt,
  }) =>
      (_db.update(_db.stages)..where((t) => t.id.equals(stageId))).write(
        StagesCompanion(
          title: title != null ? Value(title) : const Value.absent(),
          description:
              description != null ? Value(description) : const Value.absent(),
          status: status != null ? Value(status.name) : const Value.absent(),
          failureReason: failureReason != null
              ? Value(failureReason)
              : const Value.absent(),
          finishedAt:
              finishedAt != null ? Value(finishedAt) : const Value.absent(),
        ),
      );

  /// Set stage status. Pass null finishedAt to clear it (back to inProgress).
  Future<void> setStageStatus(
    int stageId,
    StageStatus status, {
    String? failureReason,
    DateTime? finishedAt,
  }) =>
      (_db.update(_db.stages)..where((t) => t.id.equals(stageId))).write(
        StagesCompanion(
          status: Value(status.name),
          failureReason: status == StageStatus.failed
              ? Value(failureReason)
              : const Value(null),
          finishedAt: status == StageStatus.inProgress
              ? const Value(null)
              : Value(finishedAt ?? DateTime.now()),
        ),
      );

  // ---------------------------------------------------------------------------
  // Photos
  // ---------------------------------------------------------------------------

  Future<List<Photo>> getPhotosForStage(int stageId) =>
      (_db.select(_db.photos)..where((t) => t.stageId.equals(stageId))).get();

  Stream<List<Photo>> watchPhotosForStage(int stageId) =>
      (_db.select(_db.photos)..where((t) => t.stageId.equals(stageId)))
          .watch();

  /// Adds a photo and, if the piece has no cover photo, sets this as the cover.
  Future<int> addPhoto({
    required int stageId,
    required int pieceId,
    required String localPath,
    String? caption,
  }) async {
    final id = await _db.into(_db.photos).insert(
          PhotosCompanion.insert(
            stageId: stageId,
            localPath: localPath,
            caption: Value(caption),
            recordedAt: DateTime.now(),
          ),
        );
    // Always update cover to the latest uploaded photo
    await setPieceCoverPhoto(pieceId, localPath);
    return id;
  }

  Future<int> deletePhoto(int photoId) =>
      (_db.delete(_db.photos)..where((t) => t.id.equals(photoId))).go();

  // ---------------------------------------------------------------------------
  // Glazes (free-text, MVP Option A)
  // ---------------------------------------------------------------------------

  Future<List<PieceGlaze>> getGlazesForPiece(int pieceId) =>
      (_db.select(_db.pieceGlazes)
            ..where((t) => t.pieceId.equals(pieceId)))
          .get();

  Stream<List<PieceGlaze>> watchGlazesForPiece(int pieceId) =>
      (_db.select(_db.pieceGlazes)
            ..where((t) => t.pieceId.equals(pieceId)))
          .watch();

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
