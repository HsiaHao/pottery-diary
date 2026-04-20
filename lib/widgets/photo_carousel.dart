import 'package:flutter/material.dart';
import 'package:pottery_diary/database/app_database.dart';
import 'package:pottery_diary/widgets/safe_file_image.dart';

/// Swipeable photo carousel. Last card is an "Add Photo" CTA.
/// Long-press any photo to set it as the piece cover.
/// Tap "Edit" to enter delete mode, then tap X to remove a photo.
class PhotoCarousel extends StatefulWidget {
  const PhotoCarousel({
    super.key,
    required this.photos,
    required this.onAddPhoto,
    required this.onSetCover,
    required this.onDeletePhoto,
    this.aspectRatio = 3 / 4,
    this.widthFactor = 1.0,
  });

  final List<Photo> photos;
  final VoidCallback onAddPhoto;
  final ValueChanged<String> onSetCover;
  final ValueChanged<Photo> onDeletePhoto;
  final double aspectRatio;
  final double widthFactor;

  @override
  State<PhotoCarousel> createState() => _PhotoCarouselState();
}

class _PhotoCarouselState extends State<PhotoCarousel> {
  bool _editMode = false;

  @override
  Widget build(BuildContext context) {
    final cardHeight = widget.widthFactor >= 1.0 ? 150.0 : 120.0;
    final cardWidth = cardHeight * 3 / 4;
    final itemCount = widget.photos.length + 1; // +1 for Add card

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Edit toggle — only show if there are photos
        if (widget.photos.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 4),
            child: GestureDetector(
              onTap: () => setState(() => _editMode = !_editMode),
              child: Text(
                _editMode ? 'Done' : 'Edit',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: _editMode ? const Color(0xFFCC4A2A) : Colors.grey.shade500,
                ),
              ),
            ),
          ),
        SizedBox(
          height: cardHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            itemCount: itemCount,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              if (i < widget.photos.length) {
                return SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: _PhotoCard(
                    photo: widget.photos[i],
                    editMode: _editMode,
                    onSetCover: () => widget.onSetCover(widget.photos[i].localPath),
                    onDelete: () => _confirmDelete(context, widget.photos[i]),
                    totalCount: widget.photos.length,
                    index: i,
                  ),
                );
              }
              return SizedBox(
                width: cardWidth,
                height: cardHeight,
                child: _AddPhotoCard(onTap: widget.onAddPhoto),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(BuildContext context, Photo photo) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete photo?'),
        content: const Text('This photo will be permanently removed.'),
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
    if (confirmed == true) {
      widget.onDeletePhoto(photo);
      if (widget.photos.length <= 1) setState(() => _editMode = false);
    }
  }
}

class _PhotoCard extends StatelessWidget {
  const _PhotoCard({
    required this.photo,
    required this.editMode,
    required this.onSetCover,
    required this.onDelete,
    required this.totalCount,
    required this.index,
  });

  final Photo photo;
  final bool editMode;
  final VoidCallback onSetCover;
  final VoidCallback onDelete;
  final int totalCount;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: editMode ? null : onSetCover,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SafeFileImage(
                path: photo.localPath,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            // Page indicator
            if (!editMode)
              Positioned(
                bottom: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${index + 1}/$totalCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            // Delete X button
            if (editMode)
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 13, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AddPhotoCard extends StatelessWidget {
  const _AddPhotoCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFF0EBE3),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFFCC4A2A).withAlpha(80),
            width: 1.5,
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              color: Color(0xFFCC4A2A),
              size: 20,
            ),
            SizedBox(height: 4),
            Text(
              'Add Photo',
              style: TextStyle(
                color: Color(0xFFCC4A2A),
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
