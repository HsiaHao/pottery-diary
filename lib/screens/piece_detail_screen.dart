import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:pottery_diary/database/app_database.dart';
import 'package:pottery_diary/models/stage_status.dart';
import 'package:pottery_diary/models/stage_type.dart';
import 'package:pottery_diary/providers/providers.dart';
import 'package:pottery_diary/services/photo_storage.dart';
import 'package:pottery_diary/widgets/photo_carousel.dart';

class PieceDetailScreen extends ConsumerWidget {
  const PieceDetailScreen({
    super.key,
    required this.pieceId,
    this.scrollController,
  });

  final int pieceId;
  final ScrollController? scrollController;

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
          final stages = stagesAsync.valueOrNull ?? [];
          return CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    // Drag handle
                    const SizedBox(height: 12),
                    Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Title row
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              piece.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF2C2218),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => _confirmDelete(context, ref),
                            child: const Text('Delete', style: TextStyle(color: Color(0xFFCC4A2A))),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Cascade status row
                      _CascadeStatusRow(pieceId: pieceId, stages: stages),
                      const SizedBox(height: 12),
                      // Progress note (auto-save)
                      _ProgressNoteCard(piece: piece),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.info_outline, size: 11, color: Colors.grey.shade400),
                          const SizedBox(width: 4),
                          Text(
                            'Hold a photo to set it as the preview image.',
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
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
// Cascade status row — tap a stage to set it (and auto-complete prior stages)
// ---------------------------------------------------------------------------

class _CascadeStatusRow extends ConsumerWidget {
  const _CascadeStatusRow({required this.pieceId, required this.stages});

  final int pieceId;
  final List<Stage> stages;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: StageType.values.map((type) {
          final stage = stages.where((s) => s.stageType == type.name).firstOrNull;
          final status = stage == null ? null : StageStatus.fromString(stage.status);
          final isLast = type == StageType.finished;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: isLast ? 0 : 8),
              child: _CascadeStageButton(
                stageType: type,
                status: status,
                onTap: () => _cascade(ref, type, status),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Future<void> _cascade(
    WidgetRef ref,
    StageType targetType,
    StageStatus? currentStatus,
  ) async {
    final repo = ref.read(pieceRepositoryProvider);
    const order = StageType.values;
    final targetIndex = order.indexOf(targetType);

    // Toggle: null/inProgress/failed → complete, complete → inProgress
    final settingComplete = currentStatus != StageStatus.done;

    for (int i = 0; i < order.length; i++) {
      final type = order[i];
      final stage = stages.where((s) => s.stageType == type.name).firstOrNull;

      final StageStatus statusToSet;
      if (i < targetIndex) {
        // Stages before target: always complete when setting target to complete,
        // leave untouched when setting target to inProgress
        if (!settingComplete) continue;
        statusToSet = StageStatus.done;
      } else if (i == targetIndex) {
        // The tapped stage toggles
        statusToSet = settingComplete ? StageStatus.done : StageStatus.notDone;
      } else {
        // Stages after target: reset to inProgress if target is being un-done
        if (settingComplete) continue;
        statusToSet = StageStatus.notDone;
      }

      if (stage == null) {
        await repo.createStage(
          pieceId: pieceId,
          stageType: type,
          status: statusToSet,
        );
      } else {
        await repo.setStageStatus(stage.id, statusToSet);
      }
    }
  }
}

class _CascadeStageButton extends StatelessWidget {
  const _CascadeStageButton({
    required this.stageType,
    required this.status,
    required this.onTap,
  });

  final StageType stageType;
  final StageStatus? status;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color fg;
    final IconData icon;

    switch (status) {
      case StageStatus.done:
        bg = const Color(0xFFE8F5E9);
        fg = Colors.green.shade700;
        icon = Icons.check_circle_rounded;
      case StageStatus.notDone:
        bg = const Color(0xFFF5F5F5);
        fg = Colors.grey.shade400;
        icon = Icons.radio_button_unchecked;
      case null:
        bg = const Color(0xFFF5F5F5);
        fg = Colors.grey.shade400;
        icon = Icons.radio_button_unchecked;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: fg),
            const SizedBox(height: 4),
            Text(
              stageType.shortLabel,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: fg,
                letterSpacing: 0.3,
              ),
            ),
            if (status != null)
              Text(
                status!.label,
                style: TextStyle(fontSize: 9, color: fg.withAlpha(180)),
              ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Stage card — no photo carousel, just info + Add Stage Update button
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
    final status = StageStatus.fromString(stage?.status);
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
                if (isStarted) _StatusBadge(status: status),
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
          if (status == StageStatus.notDone &&
              stage?.failureReason != null &&
              stage!.failureReason!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade100),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, size: 14, color: Colors.red.shade400),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        stage!.failureReason!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red.shade700,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (stage?.finishedAt != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
              child: Row(
                children: [
                  Icon(Icons.schedule, size: 13, color: Colors.grey.shade400),
                  const SizedBox(width: 4),
                  Text(
                    'Finished ${_fmtDate(stage!.finishedAt!)}',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
          // Photo carousel — 3:4 ratio matching grid cards
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: PhotoCarousel(
              photos: photos,
              aspectRatio: 3 / 4,
              onAddPhoto: () => _addPhoto(context, ref),
              onSetCover: (path) => _setCover(context, ref, path),
              onDeletePhoto: (photo) => _deletePhoto(ref, photo),
              widthFactor: 0.5,
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Future<void> _addPhoto(BuildContext context, WidgetRef ref) async {
    // Ensure stage exists before adding photo
    int stageId;
    if (stage == null) {
      stageId = await ref.read(pieceRepositoryProvider).createStage(
            pieceId: pieceId,
            stageType: stageType,
            status: StageStatus.notDone,
          );
    } else {
      stageId = stage!.id;
    }

    if (!context.mounted) return;

    final path = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _PhotoPickerSheet(),
    );
    if (path == null || !context.mounted) return;
    await ref.read(pieceRepositoryProvider).addPhoto(
          stageId: stageId,
          pieceId: pieceId,
          localPath: path,
        );
  }

  Future<void> _deletePhoto(WidgetRef ref, Photo photo) async {
    await ref.read(pieceRepositoryProvider).deletePhoto(photo.id);
    await PhotoStorage.delete(photo.localPath);
  }

  Future<void> _setCover(
      BuildContext context, WidgetRef ref, String localPath) async {
    await ref
        .read(pieceRepositoryProvider)
        .setPieceCoverPhoto(pieceId, localPath);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cover photo updated'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  static String _fmtDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }
}

class _PhotoPickerSheet extends StatefulWidget {
  const _PhotoPickerSheet();

  @override
  State<_PhotoPickerSheet> createState() => _PhotoPickerSheetState();
}

class _PhotoPickerSheetState extends State<_PhotoPickerSheet> {
  List<AssetEntity> _recentAssets = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadRecent();
  }

  Future<void> _loadRecent() async {
    final permission = await PhotoManager.requestPermissionExtend();
    if (!permission.isAuth && !permission.hasAccess) {
      setState(() => _loading = false);
      return;
    }
    final albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      filterOption: FilterOptionGroup(
        orders: [const OrderOption(type: OrderOptionType.createDate, asc: false)],
      ),
    );
    if (albums.isEmpty) { setState(() => _loading = false); return; }
    final assets = await albums.first.getAssetListRange(start: 0, end: 20);
    setState(() { _recentAssets = assets; _loading = false; });
  }

  Future<void> _pickAsset(AssetEntity asset) async {
    final file = await asset.file;
    if (file == null || !mounted) return;
    final path = await PhotoStorage.cropFile(file.path);
    if (path != null && mounted) Navigator.pop(context, path);
  }

  Future<void> _camera() async {
    final path = await PhotoStorage.pickFromCamera(crop: true);
    if (path != null && mounted) Navigator.pop(context, path);
  }

  Future<void> _gallery() async {
    final path = await PhotoStorage.pickFromGallery(crop: true);
    if (path != null && mounted) Navigator.pop(context, path);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF7F4F0),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36, height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Add Photo', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF2C2218))),
          const SizedBox(height: 14),
          if (_loading)
            const SizedBox(height: 120, child: Center(child: CircularProgressIndicator(strokeWidth: 2)))
          else if (_recentAssets.isNotEmpty) ...[
            Text('Recent', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade600)),
            const SizedBox(height: 8),
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _recentAssets.length,
                separatorBuilder: (_, __) => const SizedBox(width: 6),
                itemBuilder: (_, i) => _AssetTile(asset: _recentAssets[i], onTap: () => _pickAsset(_recentAssets[i])),
              ),
            ),
            const SizedBox(height: 14),
          ],
          Row(
            children: [
              _SheetBtn(icon: Icons.camera_alt_outlined, label: 'Camera', onTap: _camera),
              const SizedBox(width: 10),
              _SheetBtn(icon: Icons.photo_library_outlined, label: 'All Photos', onTap: _gallery),
            ],
          ),
        ],
      ),
    );
  }
}

class _AssetTile extends StatefulWidget {
  const _AssetTile({required this.asset, required this.onTap});
  final AssetEntity asset;
  final VoidCallback onTap;
  @override
  State<_AssetTile> createState() => _AssetTileState();
}

class _AssetTileState extends State<_AssetTile> {
  Uint8List? _thumb;
  @override
  void initState() {
    super.initState();
    widget.asset.thumbnailDataWithSize(const ThumbnailSize(200, 267), quality: 80).then((b) {
      if (mounted) setState(() => _thumb = b);
    });
  }
  @override
  Widget build(BuildContext context) {
    const double h = 120, w = h * 3 / 4;
    return GestureDetector(
      onTap: widget.onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(width: w, height: h,
          child: _thumb != null
              ? Image.memory(_thumb!, fit: BoxFit.cover, width: w, height: h)
              : Container(color: const Color(0xFFE8E0D8)),
        ),
      ),
    );
  }
}

class _SheetBtn extends StatelessWidget {
  const _SheetBtn({required this.icon, required this.label, required this.onTap});
  final IconData icon; final String label; final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFCC4A2A).withAlpha(80), width: 1.5),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: const Color(0xFFCC4A2A), size: 18),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: Color(0xFFCC4A2A), fontSize: 12, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Progress note — auto-saves on focus lost, no Edit/Save buttons
// ---------------------------------------------------------------------------

class _ProgressNoteCard extends ConsumerStatefulWidget {
  const _ProgressNoteCard({required this.piece});

  final Piece piece;

  @override
  ConsumerState<_ProgressNoteCard> createState() => _ProgressNoteCardState();
}

class _ProgressNoteCardState extends ConsumerState<_ProgressNoteCard> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.piece.progressNote ?? '');
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      _save();
    }
  }

  Future<void> _save() async {
    await ref.read(pieceRepositoryProvider).updateProgressNote(
          widget.piece.id,
          _controller.text.trim().isEmpty ? null : _controller.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Progress Notes',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF4A3828),
                ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            textCapitalization: TextCapitalization.sentences,
            maxLines: null,
            decoration: InputDecoration(
              hintText: 'Tap to add a progress note…',
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Status badge
// ---------------------------------------------------------------------------

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final StageStatus status;

  @override
  Widget build(BuildContext context) {
    final color = status == StageStatus.done ? Colors.green : Colors.grey;
    final icon = status == StageStatus.done
        ? Icons.check_circle
        : Icons.radio_button_unchecked;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color.shade600),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: TextStyle(
                fontSize: 11,
                color: color.shade700,
                fontWeight: FontWeight.w600),
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
      StageType.formed: const Color(0xFFEDE0D0),
      StageType.trimmed: const Color(0xFFE8D5C0),
      StageType.bisqued: const Color(0xFFD5C8B8),
      StageType.glazed: const Color(0xFFC8B8A8),
      StageType.finished: const Color(0xFF5C4A3A),
    };
    final textColors = {
      StageType.formed: const Color(0xFF9B6E4C),
      StageType.trimmed: const Color(0xFF8B5E3C),
      StageType.bisqued: const Color(0xFF6B4E3C),
      StageType.glazed: const Color(0xFF4A3828),
      StageType.finished: Colors.white,
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
