import 'package:flutter_test/flutter_test.dart';
import 'package:pottery_diary/database/app_database.dart';
import 'package:pottery_diary/models/stage_status.dart';
import 'package:pottery_diary/models/stage_type.dart';
import 'package:pottery_diary/repositories/piece_repository.dart';

void main() {
  late AppDatabase db;
  late PieceRepository repo;

  setUp(() {
    db = openTestDatabase();
    repo = PieceRepository(db);
  });

  tearDown(() async => db.close());

  // ---------------------------------------------------------------------------
  // Piece CRUD
  // ---------------------------------------------------------------------------

  group('Piece CRUD', () {
    test('createPiece returns a valid id', () async {
      final id = await repo.createPiece(title: 'Test Bowl');
      expect(id, greaterThan(0));
    });

    test('getAllPieces returns all created pieces', () async {
      await repo.createPiece(title: 'Bowl');
      await repo.createPiece(title: 'Mug');
      final pieces = await repo.getAllPieces();
      expect(pieces.length, 2);
      expect(pieces.map((p) => p.title), containsAll(['Bowl', 'Mug']));
    });

    test('getPieceById returns the correct piece', () async {
      final id = await repo.createPiece(title: 'Vase', description: 'Tall');
      final piece = await repo.getPieceById(id);
      expect(piece, isNotNull);
      expect(piece!.title, 'Vase');
      expect(piece.description, 'Tall');
    });

    test('getPieceById returns null for unknown id', () async {
      final piece = await repo.getPieceById(999);
      expect(piece, isNull);
    });

    test('updatePiece changes the title', () async {
      final id = await repo.createPiece(title: 'Old Title');
      await repo.updatePiece(id, title: 'New Title');
      final piece = await repo.getPieceById(id);
      expect(piece!.title, 'New Title');
    });

    test('updatePiece does not change unspecified fields', () async {
      final id =
          await repo.createPiece(title: 'Keep Title', description: 'Keep Desc');
      await repo.updatePiece(id, title: 'New Title');
      final piece = await repo.getPieceById(id);
      expect(piece!.description, 'Keep Desc');
    });

    test('deletePiece removes the piece', () async {
      final id = await repo.createPiece(title: 'To Delete');
      await repo.deletePiece(id);
      expect(await repo.getPieceById(id), isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // Stage operations
  // ---------------------------------------------------------------------------

  group('Stage operations', () {
    late int pieceId;

    setUp(() async {
      pieceId = await repo.createPiece(title: 'Stage Test Piece');
    });

    test('createStage returns a valid id', () async {
      final id =
          await repo.createStage(pieceId: pieceId, stageType: StageType.trimmed);
      expect(id, greaterThan(0));
    });

    test('getStagesForPiece returns all stages for that piece', () async {
      await repo.createStage(pieceId: pieceId, stageType: StageType.trimmed);
      await repo.createStage(pieceId: pieceId, stageType: StageType.bisque);
      final stages = await repo.getStagesForPiece(pieceId);
      expect(stages.length, 2);
      expect(
        stages.map((s) => s.stageType),
        containsAll([StageType.trimmed.name, StageType.bisque.name]),
      );
    });

    test('setStageStatus complete sets finishedAt', () async {
      final stageId =
          await repo.createStage(pieceId: pieceId, stageType: StageType.trimmed);
      final before = await repo.getStagesForPiece(pieceId);
      expect(before.first.finishedAt, isNull);

      await repo.setStageStatus(stageId, StageStatus.complete);

      final after = await repo.getStagesForPiece(pieceId);
      expect(after.first.finishedAt, isNotNull);
      expect(after.first.status, StageStatus.complete.name);
    });

    test('setStageStatus failed stores reason', () async {
      final stageId =
          await repo.createStage(pieceId: pieceId, stageType: StageType.trimmed);
      await repo.setStageStatus(stageId, StageStatus.failed,
          failureReason: 'Cracked in kiln');
      final stages = await repo.getStagesForPiece(pieceId);
      expect(stages.first.status, StageStatus.failed.name);
      expect(stages.first.failureReason, 'Cracked in kiln');
    });

    test('setStageStatus inProgress clears finishedAt', () async {
      final stageId =
          await repo.createStage(pieceId: pieceId, stageType: StageType.trimmed);
      await repo.setStageStatus(stageId, StageStatus.complete);
      await repo.setStageStatus(stageId, StageStatus.inProgress);
      final stages = await repo.getStagesForPiece(pieceId);
      expect(stages.first.finishedAt, isNull);
      expect(stages.first.status, StageStatus.inProgress.name);
    });

    test('deleting a piece cascades to its stages', () async {
      await repo.createStage(pieceId: pieceId, stageType: StageType.trimmed);
      await repo.deletePiece(pieceId);
      final stages = await repo.getStagesForPiece(pieceId);
      expect(stages, isEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  // Photo operations
  // ---------------------------------------------------------------------------

  group('Photo operations', () {
    late int stageId;
    late int photoPieceId;

    setUp(() async {
      photoPieceId = await repo.createPiece(title: 'Photo Test Piece');
      stageId = await repo.createStage(
        pieceId: photoPieceId,
        stageType: StageType.trimmed,
      );
    });

    test('addPhoto returns a valid id', () async {
      final id = await repo.addPhoto(
          stageId: stageId, pieceId: photoPieceId, localPath: '/tmp/photo.jpg');
      expect(id, greaterThan(0));
    });

    test('getPhotosForStage returns added photos', () async {
      await repo.addPhoto(
          stageId: stageId,
          pieceId: photoPieceId,
          localPath: '/tmp/a.jpg',
          caption: 'Front');
      await repo.addPhoto(
          stageId: stageId, pieceId: photoPieceId, localPath: '/tmp/b.jpg');
      final photos = await repo.getPhotosForStage(stageId);
      expect(photos.length, 2);
      expect(photos.first.caption, 'Front');
    });

    test('addPhoto auto-sets piece cover photo', () async {
      await repo.addPhoto(
          stageId: stageId,
          pieceId: photoPieceId,
          localPath: '/tmp/cover.jpg');
      final piece = await repo.getPieceById(photoPieceId);
      expect(piece!.coverPhotoPath, '/tmp/cover.jpg');
    });

    test('deletePhoto removes the photo', () async {
      final id = await repo.addPhoto(
          stageId: stageId, pieceId: photoPieceId, localPath: '/tmp/del.jpg');
      await repo.deletePhoto(id);
      final photos = await repo.getPhotosForStage(stageId);
      expect(photos, isEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  // Glaze operations
  // ---------------------------------------------------------------------------

  group('Glaze operations', () {
    late int pieceId;

    setUp(() async {
      pieceId = await repo.createPiece(title: 'Glazed Piece');
    });

    test('addGlazeToPiece adds a glaze tag', () async {
      await repo.addGlazeToPiece(pieceId, 'Celadon');
      final glazes = await repo.getGlazesForPiece(pieceId);
      expect(glazes.map((g) => g.glazeName), contains('Celadon'));
    });

    test('addGlazeToPiece is idempotent', () async {
      await repo.addGlazeToPiece(pieceId, 'Celadon');
      await repo.addGlazeToPiece(pieceId, 'Celadon');
      final glazes = await repo.getGlazesForPiece(pieceId);
      expect(glazes.length, 1);
    });

    test('multiple distinct glazes are stored separately', () async {
      await repo.addGlazeToPiece(pieceId, 'Celadon');
      await repo.addGlazeToPiece(pieceId, 'Tenmoku');
      final glazes = await repo.getGlazesForPiece(pieceId);
      expect(glazes.length, 2);
    });

    test('removeGlazeFromPiece removes the glaze', () async {
      await repo.addGlazeToPiece(pieceId, 'Tenmoku');
      await repo.removeGlazeFromPiece(pieceId, 'Tenmoku');
      final glazes = await repo.getGlazesForPiece(pieceId);
      expect(glazes, isEmpty);
    });

    test('deleting a piece cascades to its glazes', () async {
      await repo.addGlazeToPiece(pieceId, 'Shino');
      await repo.deletePiece(pieceId);
      final glazes = await repo.getGlazesForPiece(pieceId);
      expect(glazes, isEmpty);
    });
  });
}
