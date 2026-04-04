import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pottery_diary/database/app_database.dart';
import 'package:pottery_diary/models/stage_type.dart';
import 'package:pottery_diary/providers/providers.dart';
import 'package:pottery_diary/screens/piece_detail_screen.dart';

class PieceCard extends ConsumerWidget {
  const PieceCard({super.key, required this.piece});

  final Piece piece;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stagesAsync = ref.watch(stagesForPieceProvider(piece.id));
    final glazesAsync = ref.watch(glazesForPieceProvider(piece.id));

    final stages = stagesAsync.valueOrNull ?? [];
    final glazes = glazesAsync.valueOrNull ?? [];

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => PieceDetailScreen(pieceId: piece.id),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(18),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CoverPhoto(path: piece.coverPhotoPath, height: 180),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
              child: Text(
                piece.title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                'CREATED ${_formatDate(piece.createdAt).toUpperCase()}',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.grey.shade500,
                      letterSpacing: 0.6,
                    ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  ...StageType.values.map((type) {
                    final stage = stages
                        .where((s) => s.stageType == type.name)
                        .firstOrNull;
                    return _StageChip(
                      label: type.shortLabel,
                      isComplete: stage?.completedAt != null,
                      isStarted: stage != null,
                    );
                  }),
                  ...glazes.map(
                    (g) => _GlazeChip(name: g.glazeName),
                  ),
                ],
              ),
            ),
          ],
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

class _CoverPhoto extends StatelessWidget {
  const _CoverPhoto({required this.path, required this.height});

  final String? path;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: path != null
          ? Image.file(
              File(path!),
              height: height,
              width: double.infinity,
              fit: BoxFit.cover,
            )
          : Container(
              height: height,
              width: double.infinity,
              color: const Color(0xFFF0EBE3),
              child: const Icon(
                Icons.spa_outlined,
                size: 48,
                color: Color(0xFFBFAFA0),
              ),
            ),
    );
  }
}

class _StageChip extends StatelessWidget {
  const _StageChip({
    required this.label,
    required this.isComplete,
    required this.isStarted,
  });

  final String label;
  final bool isComplete;
  final bool isStarted;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = isComplete
        ? scheme.primary.withAlpha(26)
        : isStarted
            ? Colors.orange.withAlpha(26)
            : Colors.grey.withAlpha(20);
    final fg = isComplete
        ? scheme.primary
        : isStarted
            ? Colors.orange.shade700
            : Colors.grey.shade500;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _GlazeChip extends StatelessWidget {
  const _GlazeChip({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F4E8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        name,
        style: const TextStyle(
          color: Color(0xFF4A7C4A),
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
