import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pottery_diary/database/app_database.dart';
import 'package:pottery_diary/providers/providers.dart';
import 'package:pottery_diary/screens/piece_detail_screen.dart';

class PieceCard extends ConsumerWidget {
  const PieceCard({super.key, required this.piece});

  final Piece piece;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stagesAsync = ref.watch(stagesForPieceProvider(piece.id));
    final completedCount = stagesAsync.whenOrNull(
          data: (stages) => stages.where((s) => s.completedAt != null).length,
        ) ??
        0;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        leading: _StageProgress(completed: completedCount),
        title: Text(
          piece.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(_formatDate(piece.createdAt)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (_) => PieceDetailScreen(pieceId: piece.id),
          ),
        ),
      ),
    );
  }

  static String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }
}

class _StageProgress extends StatelessWidget {
  const _StageProgress({required this.completed});

  final int completed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = completed == 0
        ? Colors.grey.shade300
        : completed == 3
            ? scheme.primary
            : scheme.primary.withAlpha(153);

    return CircleAvatar(
      backgroundColor: color,
      radius: 20,
      child: Text(
        '$completed/3',
        style: const TextStyle(
          fontSize: 11,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
