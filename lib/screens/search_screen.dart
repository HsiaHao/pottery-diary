import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pottery_diary/database/app_database.dart';
import 'package:pottery_diary/models/stage_status.dart';
import 'package:pottery_diary/models/stage_type.dart';
import 'package:pottery_diary/providers/providers.dart';
import 'package:pottery_diary/screens/piece_detail_screen.dart';
import 'package:pottery_diary/widgets/safe_file_image.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _queryController = TextEditingController();
  String _query = '';
  // null = any stage; otherwise filter to pieces that have this stage type
  StageType? _stageFilter;

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final piecesAsync = ref.watch(piecesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F4F0),
        surfaceTintColor: Colors.transparent,
        title: const Text('Search'),
        centerTitle: false,
        titleTextStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: const Color(0xFF2C2218),
            ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _queryController,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Search pieces…',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _queryController.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          // Stage filter chips
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _FilterChip(
                  label: 'All',
                  selected: _stageFilter == null,
                  onTap: () => setState(() => _stageFilter = null),
                ),
                const SizedBox(width: 8),
                ...StageType.values.map((type) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _FilterChip(
                        label: type.displayName,
                        selected: _stageFilter == type,
                        onTap: () => setState(() =>
                            _stageFilter = _stageFilter == type ? null : type),
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: piecesAsync.when(
              data: (pieces) {
                return _FilteredList(
                  pieces: pieces,
                  query: _query,
                  stageFilter: _stageFilter,
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Filtered list — reads stage data per piece to apply the stage filter
// ---------------------------------------------------------------------------

class _FilteredList extends ConsumerWidget {
  const _FilteredList({
    required this.pieces,
    required this.query,
    required this.stageFilter,
  });

  final List<Piece> pieces;
  final String query;
  final StageType? stageFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtered = pieces.where((p) {
      // Text filter
      if (query.isNotEmpty &&
          !p.title.toLowerCase().contains(query.toLowerCase())) {
        return false;
      }
      return true;
    }).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Text(
          'No pieces found',
          style: TextStyle(color: Colors.grey.shade500),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filtered.length,
      itemBuilder: (_, i) => _SearchResultTile(
        piece: filtered[i],
        stageFilter: stageFilter,
      ),
    );
  }
}

class _SearchResultTile extends ConsumerWidget {
  const _SearchResultTile({required this.piece, required this.stageFilter});

  final Piece piece;
  final StageType? stageFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stages =
        ref.watch(stagesForPieceProvider(piece.id)).valueOrNull ?? [];

    // Apply stage filter — only show piece if it has a stage of the given type
    if (stageFilter != null) {
      final hasStage =
          stages.any((s) => s.stageType == stageFilter!.name);
      if (!hasStage) return const SizedBox.shrink();
    }

    final stageForFilter = stageFilter != null
        ? stages.where((s) => s.stageType == stageFilter!.name).firstOrNull
        : null;
    final stageStatus = StageStatus.fromString(stageForFilter?.status);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => PieceDetailScreen(pieceId: piece.id),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(12)),
              child: piece.coverPhotoPath != null
                  ? SafeFileImage(
                      path: piece.coverPhotoPath!,
                      width: 72,
                      height: 72,
                    )
                  : Container(
                      width: 72,
                      height: 72,
                      color: const Color(0xFFF0EBE3),
                      child: const Icon(Icons.spa_outlined,
                          color: Color(0xFFBFAFA0), size: 28),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    piece.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 4),
                  if (stageFilter != null && stageForFilter != null)
                    _StatusBadge(
                        type: stageFilter!, status: stageStatus)
                  else
                    _StagesSummary(stages: stages),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.chevron_right, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class _StagesSummary extends StatelessWidget {
  const _StagesSummary({required this.stages});

  final List<Stage> stages;

  @override
  Widget build(BuildContext context) {
    final complete =
        stages.where((s) => s.status == StageStatus.complete.name).length;
    return Text(
      '$complete / 3 stages complete',
      style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.type, required this.status});

  final StageType type;
  final StageStatus status;

  @override
  Widget build(BuildContext context) {
    final color = status == StageStatus.complete
        ? Colors.green
        : status == StageStatus.failed
            ? Colors.red
            : Colors.orange;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: color.withAlpha(26),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            type.shortLabel,
            style: TextStyle(
                fontSize: 10,
                color: color.shade700,
                fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          status.label,
          style: TextStyle(fontSize: 11, color: color.shade600),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFCC4A2A) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? const Color(0xFFCC4A2A)
                : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight:
                selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? Colors.white : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }
}
