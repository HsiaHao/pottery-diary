import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pottery_diary/models/stage_type.dart';
import 'package:pottery_diary/providers/providers.dart';
import 'package:pottery_diary/widgets/edit_piece_sheet.dart';
import 'package:pottery_diary/widgets/stage_entry_sheet.dart';
import 'package:pottery_diary/widgets/stage_tile.dart';

class PieceDetailScreen extends ConsumerWidget {
  const PieceDetailScreen({super.key, required this.pieceId});

  final int pieceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pieceAsync = ref.watch(pieceProvider(pieceId));
    final stagesAsync = ref.watch(stagesForPieceProvider(pieceId));

    return Scaffold(
      appBar: AppBar(
        title: Text(pieceAsync.valueOrNull?.title ?? ''),
        actions: [
          if (pieceAsync.valueOrNull != null) ...[
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Edit',
              onPressed: () => showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                builder: (_) =>
                    EditPieceSheet(piece: pieceAsync.value!),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Delete',
              onPressed: () => _confirmDelete(context, ref),
            ),
          ],
        ],
      ),
      body: pieceAsync.when(
        data: (piece) {
          if (piece == null) {
            return const Center(child: Text('Piece not found.'));
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (piece.description != null &&
                  piece.description!.isNotEmpty) ...[
                Text(
                  piece.description!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Divider(height: 32),
              ],
              Text(
                'Stages',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              stagesAsync.when(
                data: (stages) => Column(
                  children: StageType.values.map((type) {
                    final stage = stages
                        .where((s) => s.stageType == type.name)
                        .firstOrNull;
                    return StageTile(
                      stageType: type,
                      stage: stage,
                      onTap: () => showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => StageEntrySheet(
                          pieceId: pieceId,
                          stageType: type,
                          existingStage: stage,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (e, _) => Text('Error loading stages: $e'),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete piece?'),
        content: const Text(
          'This will permanently delete the piece and all its stages and photos.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await ref.read(pieceRepositoryProvider).deletePiece(pieceId);
      if (context.mounted) Navigator.pop(context);
    }
  }
}
