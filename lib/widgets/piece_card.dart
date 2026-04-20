import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pottery_diary/database/app_database.dart';
import 'package:pottery_diary/models/stage_status.dart';
import 'package:pottery_diary/models/stage_type.dart';
import 'package:pottery_diary/providers/providers.dart';
import 'package:pottery_diary/screens/piece_detail_screen.dart';
import 'package:pottery_diary/widgets/safe_file_image.dart';

class PieceCard extends ConsumerWidget {
  const PieceCard({
    super.key,
    required this.piece,
    this.gridMode = false,
  });

  final Piece piece;
  final bool gridMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stagesAsync = ref.watch(stagesForPieceProvider(piece.id));
    final stages = stagesAsync.valueOrNull ?? [];

    return GestureDetector(
      onTap: () => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, scrollController) => ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: PieceDetailScreen(
              pieceId: piece.id,
              scrollController: scrollController,
            ),
          ),
        ),
      ),
      child: gridMode
          ? _GridCard(piece: piece, stages: stages)
          : _ListCard(piece: piece, stages: stages, ref: ref),
    );
  }

  static String formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }
}

// ---------------------------------------------------------------------------
// Grid card — photo-first compact layout
// ---------------------------------------------------------------------------

class _GridCard extends StatelessWidget {
  const _GridCard({required this.piece, required this.stages});

  final Piece piece;
  final List<Stage> stages;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(18),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Cover photo
            piece.coverPhotoPath != null
                ? SafeFileImage(
                    path: piece.coverPhotoPath!,
                    width: double.infinity,
                    height: double.infinity,
                  )
                : Container(
                    color: const Color(0xFFF0EBE3),
                    child: const Icon(
                      Icons.spa_outlined,
                      size: 40,
                      color: Color(0xFFBFAFA0),
                    ),
                  ),
            // Gradient overlay at bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Color(0xCC000000), Colors.transparent],
                    stops: [0.0, 1.0],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(10, 24, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      piece.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _GridStageDots(stages: stages),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GridStageDots extends StatelessWidget {
  const _GridStageDots({required this.stages});

  final List<Stage> stages;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: StageType.values.map((type) {
        final stage =
            stages.where((s) => s.stageType == type.name).firstOrNull;
        final status = stage == null ? null : StageStatus.fromString(stage.status);

        final Color color = status == StageStatus.done
            ? Colors.greenAccent.shade400
            : Colors.white24;

        return Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Tooltip(
            message: type.shortLabel,
            child: Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ---------------------------------------------------------------------------
// List card — compact row layout
// ---------------------------------------------------------------------------

class _ListCard extends StatelessWidget {
  const _ListCard({
    required this.piece,
    required this.stages,
    required this.ref,
  });

  final Piece piece;
  final List<Stage> stages;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            // Circle cover photo
            _CircleAvatar(path: piece.coverPhotoPath),
            const SizedBox(width: 12),
            // Title + date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    piece.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2C2218),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    PieceCard.formatDate(piece.createdAt),
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Stage status dots
            _CompactStageDots(stages: stages),
          ],
        ),
      ),
    );
  }
}

class _CircleAvatar extends StatelessWidget {
  const _CircleAvatar({required this.path});

  final String? path;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: 44,
        height: 44,
        child: path != null
            ? SafeFileImage(
                path: path!,
                width: 44,
                height: 44,
              )
            : Container(
                color: const Color(0xFFF0EBE3),
                child: const Icon(
                  Icons.spa_outlined,
                  size: 20,
                  color: Color(0xFFBFAFA0),
                ),
              ),
      ),
    );
  }
}

class _CompactStageDots extends StatelessWidget {
  const _CompactStageDots({required this.stages});

  final List<Stage> stages;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: StageType.values.map((type) {
        final stage =
            stages.where((s) => s.stageType == type.name).firstOrNull;
        final status =
            stage == null ? null : StageStatus.fromString(stage.status);

        final Color color = status == StageStatus.done
            ? Colors.green.shade500
            : Colors.grey.shade200;

        return Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Tooltip(
            message: type.shortLabel,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

