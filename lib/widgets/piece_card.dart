import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pottery_diary/database/app_database.dart';
import 'package:pottery_diary/models/stage_status.dart';
import 'package:pottery_diary/models/stage_type.dart';
import 'package:pottery_diary/providers/providers.dart';
import 'package:pottery_diary/screens/piece_detail_screen.dart';
import 'package:pottery_diary/widgets/safe_file_image.dart';

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
            // Inline stage status row
            _InlineStageRow(pieceId: piece.id, stages: stages),
            if (glazes.isNotEmpty) ...[
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: glazes
                      .map((g) => _GlazeChip(name: g.glazeName))
                      .toList(),
                ),
              ),
            ],
            const SizedBox(height: 12),
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

// ---------------------------------------------------------------------------
// Inline stage row — 3 stage buttons with tap-to-cycle status
// ---------------------------------------------------------------------------

class _InlineStageRow extends ConsumerWidget {
  const _InlineStageRow({required this.pieceId, required this.stages});

  final int pieceId;
  final List<Stage> stages;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: StageType.values.map((type) {
          final stage =
              stages.where((s) => s.stageType == type.name).firstOrNull;
          final status = StageStatus.fromString(stage?.status);
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: type != StageType.glazeFired ? 6 : 0,
              ),
              child: _StageButton(
                stageType: type,
                status: stage == null ? null : status,
                onTap: () => _cycleStatus(context, ref, stage, type),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Future<void> _cycleStatus(
    BuildContext context,
    WidgetRef ref,
    Stage? stage,
    StageType type,
  ) async {
    final repo = ref.read(pieceRepositoryProvider);

    if (stage == null) {
      // Create stage as inProgress
      final stageId = await repo.createStage(
        pieceId: pieceId,
        stageType: type,
        status: StageStatus.inProgress,
      );
      await repo.setStageStatus(stageId, StageStatus.inProgress);
      return;
    }

    final current = StageStatus.fromString(stage.status);
    final next = switch (current) {
      StageStatus.inProgress => StageStatus.complete,
      StageStatus.complete => StageStatus.inProgress,
      StageStatus.failed => StageStatus.inProgress,
    };
    await repo.setStageStatus(stage.id, next);
  }
}

class _StageButton extends StatelessWidget {
  const _StageButton({
    required this.stageType,
    required this.status,
    required this.onTap,
  });

  final StageType stageType;
  final StageStatus? status; // null = not started
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color fg;
    final IconData icon;

    switch (status) {
      case StageStatus.complete:
        bg = const Color(0xFFE8F5E9);
        fg = Colors.green.shade700;
        icon = Icons.check_circle;
      case StageStatus.failed:
        bg = const Color(0xFFFFEBEE);
        fg = Colors.red.shade700;
        icon = Icons.cancel;
      case StageStatus.inProgress:
        bg = const Color(0xFFFFF3E0);
        fg = Colors.orange.shade700;
        icon = Icons.radio_button_checked;
      case null:
        bg = const Color(0xFFF5F5F5);
        fg = Colors.grey.shade400;
        icon = Icons.radio_button_unchecked;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: fg),
            const SizedBox(height: 3),
            Text(
              stageType.shortLabel,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: fg,
                letterSpacing: 0.3,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
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
          ? SafeFileImage(
              path: path!,
              height: height,
              width: double.infinity,
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
