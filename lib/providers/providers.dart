import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pottery_diary/database/app_database.dart';
import 'package:pottery_diary/repositories/piece_repository.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = openDatabase();
  ref.onDispose(db.close);
  return db;
});

final pieceRepositoryProvider = Provider<PieceRepository>((ref) {
  return PieceRepository(ref.watch(databaseProvider));
});

final piecesProvider = StreamProvider<List<Piece>>((ref) {
  return ref.watch(pieceRepositoryProvider).watchAllPieces();
});
