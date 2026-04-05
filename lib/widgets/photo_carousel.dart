import 'package:flutter/material.dart';
import 'package:pottery_diary/database/app_database.dart';
import 'package:pottery_diary/widgets/safe_file_image.dart';

/// Swipeable photo carousel. Last card is an "Add Photo" CTA.
/// Long-press any photo to set it as the piece cover.
class PhotoCarousel extends StatefulWidget {
  const PhotoCarousel({
    super.key,
    required this.photos,
    required this.onAddPhoto,
    required this.onSetCover,
    this.height = 200,
  });

  final List<Photo> photos;
  final VoidCallback onAddPhoto;
  final ValueChanged<String> onSetCover;
  final double height;

  @override
  State<PhotoCarousel> createState() => _PhotoCarouselState();
}

class _PhotoCarouselState extends State<PhotoCarousel> {
  final _controller = PageController(viewportFraction: 0.88);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = widget.photos.length + 1; // +1 for Add card

    return SizedBox(
      height: widget.height,
      child: PageView.builder(
        controller: _controller,
        itemCount: itemCount,
        itemBuilder: (context, i) {
          if (i < widget.photos.length) {
            return _PhotoPage(
              photo: widget.photos[i],
              onSetCover: () => widget.onSetCover(widget.photos[i].localPath),
              totalCount: widget.photos.length,
              index: i,
            );
          }
          return _AddPhotoPage(onTap: widget.onAddPhoto);
        },
      ),
    );
  }
}

class _PhotoPage extends StatelessWidget {
  const _PhotoPage({
    required this.photo,
    required this.onSetCover,
    required this.totalCount,
    required this.index,
  });

  final Photo photo;
  final VoidCallback onSetCover;
  final int totalCount;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onSetCover,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SafeFileImage(
                path: photo.localPath,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            // Page indicator
            Positioned(
              bottom: 10,
              right: 12,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${index + 1} / $totalCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            // Cover hint
            Positioned(
              bottom: 10,
              left: 12,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Hold to set cover',
                  style: TextStyle(color: Colors.white70, fontSize: 9),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddPhotoPage extends StatelessWidget {
  const _AddPhotoPage({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFF0EBE3),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFFCC4A2A).withAlpha(80),
            width: 1.5,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFCC4A2A).withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add_photo_alternate_outlined,
                color: Color(0xFFCC4A2A),
                size: 28,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Add Photo',
              style: TextStyle(
                color: Color(0xFFCC4A2A),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Camera or gallery',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
