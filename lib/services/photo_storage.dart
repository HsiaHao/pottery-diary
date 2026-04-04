import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class PhotoStorage {
  PhotoStorage._();

  static final _picker = ImagePicker();

  /// Pick from camera and copy into app documents. Returns local path or null.
  static Future<String?> pickFromCamera() => _pick(ImageSource.camera);

  /// Pick from gallery and copy into app documents. Returns local path or null.
  static Future<String?> pickFromGallery() => _pick(ImageSource.gallery);

  static Future<String?> _pick(ImageSource source) async {
    final xFile = await _picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1920,
    );
    if (xFile == null) return null;
    return _copyToAppDir(xFile.path);
  }

  /// Copy a file into the app's photos directory and return the new path.
  static Future<String> _copyToAppDir(String sourcePath) async {
    final docsDir = await getApplicationDocumentsDirectory();
    final photosDir = Directory(p.join(docsDir.path, 'photos'));
    if (!photosDir.existsSync()) photosDir.createSync(recursive: true);

    final ext = p.extension(sourcePath);
    final name =
        '${DateTime.now().millisecondsSinceEpoch}$ext';
    final dest = p.join(photosDir.path, name);
    await File(sourcePath).copy(dest);
    return dest;
  }

  /// Delete a photo file from disk, ignoring errors if already gone.
  static Future<void> delete(String localPath) async {
    try {
      await File(localPath).delete();
    } catch (_) {}
  }
}
