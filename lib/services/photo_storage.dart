import 'dart:io';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class PhotoStorage {
  PhotoStorage._();

  static final _picker = ImagePicker();

  /// Pick from camera, crop, and copy into app documents. Returns local path or null.
  static Future<String?> pickFromCamera({bool crop = false}) =>
      _pick(ImageSource.camera, crop: crop);

  /// Pick from gallery, crop, and copy into app documents. Returns local path or null.
  static Future<String?> pickFromGallery({bool crop = false}) =>
      _pick(ImageSource.gallery, crop: crop);

  static Future<String?> _pick(ImageSource source, {bool crop = false}) async {
    final xFile = await _picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1920,
    );
    if (xFile == null) return null;

    String path = xFile.path;

    if (crop) {
      final cropped = await ImageCropper().cropImage(
        sourcePath: path,
        aspectRatio: const CropAspectRatio(ratioX: 3, ratioY: 4),
        uiSettings: [
          IOSUiSettings(
            title: 'Crop Photo',
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
            rotateButtonsHidden: true,
          ),
          AndroidUiSettings(
            toolbarTitle: 'Crop Photo',
            lockAspectRatio: true,
            showCropGrid: false,
          ),
        ],
      );
      if (cropped == null) return null;
      path = cropped.path;
    }

    return _copyToAppDir(path);
  }

  /// Copy a file into the app's photos directory and return the new path.
  static Future<String> _copyToAppDir(String sourcePath) async {
    final docsDir = await getApplicationDocumentsDirectory();
    final photosDir = Directory(p.join(docsDir.path, 'photos'));
    if (!photosDir.existsSync()) photosDir.createSync(recursive: true);

    final ext = p.extension(sourcePath);
    final name = '${DateTime.now().millisecondsSinceEpoch}$ext';
    final dest = p.join(photosDir.path, name);
    await File(sourcePath).copy(dest);
    return dest;
  }

  /// Crop an existing file path (e.g. from photo_manager asset). Returns saved path or null.
  static Future<String?> cropFile(String sourcePath) async {
    final cropped = await ImageCropper().cropImage(
      sourcePath: sourcePath,
      aspectRatio: const CropAspectRatio(ratioX: 3, ratioY: 4),
      uiSettings: [
        IOSUiSettings(
          title: 'Crop Photo',
          aspectRatioLockEnabled: true,
          resetAspectRatioEnabled: false,
          rotateButtonsHidden: true,
        ),
        AndroidUiSettings(
          toolbarTitle: 'Crop Photo',
          lockAspectRatio: true,
          showCropGrid: false,
        ),
      ],
    );
    if (cropped == null) return null;
    return _copyToAppDir(cropped.path);
  }

  /// Delete a photo file from disk, ignoring errors if already gone.
  static Future<void> delete(String localPath) async {
    try {
      await File(localPath).delete();
    } catch (_) {}
  }
}
