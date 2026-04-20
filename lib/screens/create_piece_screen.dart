import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:pottery_diary/providers/providers.dart';
import 'package:pottery_diary/services/photo_storage.dart';

/// Show the create-piece bottom sheet. Returns after the piece is saved.
Future<void> showCreatePieceSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _CreatePieceSheet(),
  );
}

class _CreatePieceSheet extends ConsumerStatefulWidget {
  const _CreatePieceSheet();

  @override
  ConsumerState<_CreatePieceSheet> createState() => _CreatePieceSheetState();
}

class _CreatePieceSheetState extends ConsumerState<_CreatePieceSheet> {
  final _titleController = TextEditingController();
  final List<String> _photoPaths = [];
  bool _saving = false;
  bool _photoError = false;

  // Recent photos
  List<AssetEntity> _recentAssets = [];
  bool _loadingPhotos = false;

  @override
  void initState() {
    super.initState();
    _titleController.text = _defaultTitle();
    _loadRecentPhotos();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  static String _defaultTitle() {
    final now = DateTime.now();
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final hour = now.hour > 12
        ? now.hour - 12
        : now.hour == 0
            ? 12
            : now.hour;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'PM' : 'AM';
    return '${months[now.month - 1]} ${now.day}, ${now.year} $hour:$minute $period';
  }

  Future<void> _loadRecentPhotos() async {
    setState(() => _loadingPhotos = true);
    final permission = await PhotoManager.requestPermissionExtend();
    if (!permission.isAuth && !permission.hasAccess) {
      setState(() => _loadingPhotos = false);
      return;
    }
    final albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      filterOption: FilterOptionGroup(
        imageOption: const FilterOption(),
        orders: [
          const OrderOption(type: OrderOptionType.createDate, asc: false),
        ],
      ),
    );
    if (albums.isEmpty) {
      setState(() => _loadingPhotos = false);
      return;
    }
    final assets = await albums.first.getAssetListRange(start: 0, end: 20);
    setState(() {
      _recentAssets = assets;
      _loadingPhotos = false;
    });
  }

  Future<void> _selectRecentPhoto(AssetEntity asset) async {
    final file = await asset.file;
    if (file == null) return;
    final cropped = await PhotoStorage.cropFile(file.path);
    if (cropped != null) {
      setState(() {
        _photoPaths.add(cropped);
        _photoError = false;
      });
    }
  }

  Future<void> _takePhoto() async {
    final path = await PhotoStorage.pickFromCamera(crop: true);
    if (path != null) setState(() { _photoPaths.add(path); _photoError = false; });
  }

  Future<void> _chooseFromLibrary() async {
    final path = await PhotoStorage.pickFromGallery(crop: true);
    if (path != null) setState(() { _photoPaths.add(path); _photoError = false; });
  }

  Future<void> _save() async {
    if (_photoPaths.isEmpty) {
      setState(() => _photoError = true);
      return;
    }
    final title = _titleController.text.trim();
    if (title.isEmpty) return;
    setState(() => _saving = true);
    await ref.read(pieceRepositoryProvider).createPiece(
          title: title,
          coverPhotoPath: _photoPaths.first,
        );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF7F4F0),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
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
          const SizedBox(height: 16),

          // Sheet title
          const Text(
            'New Piece',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2C2218),
            ),
          ),
          const SizedBox(height: 16),

          // Name label
          Text(
            'Name',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 6),

          // Title field
          TextField(
            controller: _titleController,
            autofocus: false,
            textCapitalization: TextCapitalization.words,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C2218),
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              suffixIcon: IconButton(
                icon: const Icon(Icons.close, size: 16),
                color: Colors.grey.shade400,
                onPressed: () => _titleController.clear(),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Defaults to today\'s date — tap to rename.',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 16),

          // Selected photos carousel
          if (_photoPaths.isNotEmpty) ...[
            SizedBox(
              height: 90,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _photoPaths.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (_, i) => Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        File(_photoPaths[i]),
                        width: 68,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (i == 0)
                      Positioned(
                        bottom: 4,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'COVER',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      top: 3,
                      right: 3,
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _photoPaths.removeAt(i)),
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close,
                              size: 11, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Recent photos grid
          if (_loadingPhotos)
            const SizedBox(
              height: 120,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            )
          else if (_recentAssets.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
                if (_photoError && _photoPaths.isEmpty)
                  Text(
                    'Photo required',
                    style: TextStyle(fontSize: 11, color: Colors.red.shade400),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 130,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _recentAssets.length.clamp(0, 20),
                separatorBuilder: (_, __) => const SizedBox(width: 6),
                itemBuilder: (_, i) => _RecentPhotoTile(
                  asset: _recentAssets[i],
                  onTap: () => _selectRecentPhoto(_recentAssets[i]),
                  hasError: _photoError && _photoPaths.isEmpty,
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Camera + Library buttons
          Row(
            children: [
              _PhotoButton(
                icon: Icons.camera_alt_outlined,
                label: 'Camera',
                onTap: _takePhoto,
                hasError: _photoError && _photoPaths.isEmpty && _recentAssets.isEmpty,
              ),
              const SizedBox(width: 10),
              _PhotoButton(
                icon: Icons.photo_library_outlined,
                label: 'All Photos',
                onTap: _chooseFromLibrary,
                hasError: _photoError && _photoPaths.isEmpty && _recentAssets.isEmpty,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Save button
          SizedBox(
            height: 50,
            child: FilledButton(
              onPressed: _saving ? null : _save,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFCC4A2A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _saving
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Text(
                      'Save Piece',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Recent photo tile
// ---------------------------------------------------------------------------

class _RecentPhotoTile extends StatefulWidget {
  const _RecentPhotoTile({
    required this.asset,
    required this.onTap,
    this.hasError = false,
  });

  final AssetEntity asset;
  final VoidCallback onTap;
  final bool hasError;

  @override
  State<_RecentPhotoTile> createState() => _RecentPhotoTileState();
}

class _RecentPhotoTileState extends State<_RecentPhotoTile> {
  Uint8List? _thumb;

  @override
  void initState() {
    super.initState();
    _loadThumb();
  }

  Future<void> _loadThumb() async {
    final bytes = await widget.asset.thumbnailDataWithSize(
      const ThumbnailSize(200, 267),
      quality: 80,
    );
    if (mounted) setState(() => _thumb = bytes);
  }

  @override
  Widget build(BuildContext context) {
    // 3:4 ratio matching grid cards; height=130 → width≈97
    const double height = 130;
    const double width = height * 3 / 4;
    return GestureDetector(
      onTap: widget.onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: width,
          height: height,
          child: _thumb != null
              ? Image.memory(_thumb!, fit: BoxFit.cover, width: width, height: height)
              : Container(
                  color: widget.hasError
                      ? Colors.red.shade100
                      : const Color(0xFFE8E0D8),
                ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

class _PhotoButton extends StatelessWidget {
  const _PhotoButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.hasError = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasError
                ? Colors.red.shade300
                : const Color(0xFFCC4A2A).withAlpha(80),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: hasError ? Colors.red.shade400 : const Color(0xFFCC4A2A),
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: hasError
                    ? Colors.red.shade400
                    : const Color(0xFFCC4A2A),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
