import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pottery_diary/providers/providers.dart';
import 'package:pottery_diary/widgets/create_piece_sheet.dart';
import 'package:pottery_diary/widgets/piece_card.dart';

class PiecesListScreen extends ConsumerWidget {
  const PiecesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final piecesAsync = ref.watch(piecesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pieces'),
        centerTitle: false,
      ),
      body: piecesAsync.when(
        data: (pieces) {
          if (pieces.isEmpty) return const _EmptyState();
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: pieces.length,
            itemBuilder: (_, i) => PieceCard(piece: pieces[i]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Something went wrong: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          builder: (_) => const CreatePieceSheet(),
        ),
        tooltip: 'Add piece',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.spa_outlined,
              size: 72,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No pieces yet',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap + to start documenting your first piece.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }
}
