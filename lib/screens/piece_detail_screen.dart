import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pottery_diary/database/app_database.dart';
import 'package:pottery_diary/models/stage_type.dart';
import 'package:pottery_diary/providers/providers.dart';
import 'package:pottery_diary/screens/stage_entry_screen.dart';

class PieceDetailScreen extends ConsumerWidget {
  const PieceDetailScreen({super.key, required this.pieceId});

  final int pieceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pieceAsync = ref.watch(pieceProvider(pieceId));
    final stagesAsync = ref.watch(stagesForPieceProvider(pieceId));

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F0),
      body: pieceAsync.when(
        data: (piece) {
          if (piece == null) {
            return const Center(child: Text('Piece not found.'));
          }
          return CustomScrollView(
            slivers: [
              _HeroAppBar(piece: piece, onDelete: () => _confirmDelete(context, ref)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (piece.description != null &&
                          piece.description!.isNotEmpty) ...[
                        Text(
                          piece.description!,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.grey.shade700),
                        ),
                        const SizedBox(height: 12),
                      ],
                      if (piece.clayBody != null || piece.firingTemp != null)
                        Wrap(
                          spacing: 8,
                          children: [
                            if (piece.clayBody != null)
                              _InfoChip(
                                icon: Icons.category_outlined,
                                label: piece.clayBody!,
                              ),
                            if (piece.firingTemp != null)
                              _InfoChip(
                                icon: Icons.local_fire_department_outlined,
                                label: piece.firingTemp!,
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              stagesAsync.when(
                data: (stages) => SliverList(
                  delegate: SliverChildListDelegate([
                    ...StageType.values.map((type) {
                      final stage = stages
                          .where((s) => s.stageType == type.name)
                          .firstOrNull;
                      return _StageCard(
                        pieceId: pieceId,
                        stageType: type,
                        stage: stage,
                      );
                    }),
                    const SizedBox(height: 32),
                  ]),
                ),
                loading: () => const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => SliverToBoxAdapter(
                  child: Center(child: Text('Error: $e')),
                ),
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

// ---------------------------------------------------------------------------
// Hero app bar with cover photo
// ---------------------------------------------------------------------------

class _HeroAppBar extends StatelessWidget {
  const _HeroAppBar({required this.piece, required this.onDelete});

  final Piece piece;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 260,
      pinned: true,
      backgroundColor: const Color(0xFF2C2218),
      foregroundColor: Colors.white,
      actions: [
        TextButton(
          onPressed: onDelete,
          child: const Text('Delete', style: TextStyle(color: Colors.white70)),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            piece.coverPhotoPath != null
                ? Image.file(
                    File(piece.coverPhotoPath!),
                    fit: BoxFit.cover,
                  )
                : Container(color: const Color(0xFF4A3828)),
            // gradient for legibility
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xCC2C2218)],
                  stops: [0.4, 1.0],
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _StatusBadge(piece: piece),
                  const SizedBox(height: 6),
                  Text(
                    piece.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (piece.description != null && piece.description!.isNotEmpty)
                    Text(
                      piece.description!,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends ConsumerWidget {
  const _StatusBadge({required this.piece});

  final Piece piece;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stages = ref.watch(stagesForPieceProvider(piece.id)).valueOrNull ?? [];
    final latestComplete = StageType.values.lastWhere(
      (t) =>
          stages
              .where((s) => s.stageType == t.name && s.completedAt != null)
              .isNotEmpty,
      orElse: () => StageType.trimmed,
    );
    final allComplete = stages.where((s) => s.completedAt != null).length == 3;
    final label = allComplete
        ? 'GLAZE FIRED'
        : 'CURRENT STATUS: ${latestComplete.shortLabel}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFCC4A2A),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Stage card with photos
// ---------------------------------------------------------------------------

class _StageCard extends ConsumerWidget {
  const _StageCard({
    required this.pieceId,
    required this.stageType,
    this.stage,
  });

  final int pieceId;
  final StageType stageType;
  final Stage? stage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photos = stage != null
        ? (ref.watch(photosForStageProvider(stage!.id)).valueOrNull ?? [])
        : <Photo>[];

    final isComplete = stage?.completedAt != null;
    final isStarted = stage != null;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              children: [
                _StageBadge(stageType: stageType),
                const Spacer(),
                if (isComplete)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle,
                            size: 12, color: Colors.green.shade600),
                        const SizedBox(width: 4),
                        Text(
                          'Complete',
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.green.shade600,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  )
                else if (isStarted)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'In Progress',
                      style: TextStyle(
                          fontSize: 11,
                          color: Colors.orange.shade700,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
              ],
            ),
          ),
          if (stage?.title != null && stage!.title!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Text(
                stage!.title!,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
          if (stage?.description != null && stage!.description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
              child: Text(
                stage!.description!,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey.shade600, height: 1.5),
              ),
            ),
          if (photos.isNotEmpty) ...[
            const SizedBox(height: 10),
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: photos.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, i) => ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    File(photos[i].localPath),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.all(12),
            child: OutlinedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => StageEntryScreen(
                    pieceId: pieceId,
                    stageType: stageType,
                    existingStage: stage,
                  ),
                ),
              ),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Add Stage Update'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFCC4A2A),
                side: const BorderSide(color: Color(0xFFCC4A2A)),
                minimumSize: const Size.fromHeight(40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StageBadge extends StatelessWidget {
  const _StageBadge({required this.stageType});

  final StageType stageType;

  @override
  Widget build(BuildContext context) {
    final colors = {
      StageType.trimmed: const Color(0xFFE8D5C0),
      StageType.bisque: const Color(0xFFD5C8B8),
      StageType.glazeFired: const Color(0xFFC8B8A8),
    };
    final textColors = {
      StageType.trimmed: const Color(0xFF8B5E3C),
      StageType.bisque: const Color(0xFF6B4E3C),
      StageType.glazeFired: const Color(0xFF4A3828),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colors[stageType],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        stageType.shortLabel,
        style: TextStyle(
          color: textColors[stageType],
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Colors.grey.shade600),
          const SizedBox(width: 5),
          Text(label,
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
