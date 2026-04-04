import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pottery_diary/providers/providers.dart';
import 'package:pottery_diary/services/photo_storage.dart';

const _clayOptions = [
  'Earthenware',
  'Stoneware',
  'Porcelain',
  'Raku',
  'Terracotta',
  'Other',
];

const _firingOptions = [
  'Cone 06 (999°C)',
  'Cone 04 (1063°C)',
  'Cone 02 (1120°C)',
  'Cone 6 (1222°C)',
  'Cone 10 (1285°C)',
  'Cone 13 (1346°C)',
  'Other',
];

class CreatePieceScreen extends ConsumerStatefulWidget {
  const CreatePieceScreen({super.key});

  @override
  ConsumerState<CreatePieceScreen> createState() => _CreatePieceScreenState();
}

class _CreatePieceScreenState extends ConsumerState<CreatePieceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  String? _coverPhotoPath;
  String? _clayBody;
  String? _firingTemp;
  bool _saving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickCoverPhoto() async {
    final choice = await showModalBottomSheet<ImageSourceChoice>(
      context: context,
      builder: (_) => const _PhotoSourceSheet(),
    );
    if (choice == null) return;
    final path = choice == ImageSourceChoice.camera
        ? await PhotoStorage.pickFromCamera()
        : await PhotoStorage.pickFromGallery();
    if (path != null) setState(() => _coverPhotoPath = path);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    await ref.read(pieceRepositoryProvider).createPiece(
          title: _titleController.text.trim(),
          description: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
          coverPhotoPath: _coverPhotoPath,
          clayBody: _clayBody,
          firingTemp: _firingTemp,
        );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F4F0),
        surfaceTintColor: Colors.transparent,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        leadingWidth: 80,
        title: const Text('Create New Piece'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _CoverPhotoPicker(
              path: _coverPhotoPath,
              onTap: _pickCoverPhoto,
            ),
            const SizedBox(height: 20),
            const _Label('Piece Title'),
            const SizedBox(height: 6),
            TextFormField(
              controller: _titleController,
              textCapitalization: TextCapitalization.words,
              decoration: _inputDecoration('e.g. Speckled Moon Vase'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Title is required' : null,
            ),
            const SizedBox(height: 16),
            const _Label('Initial Notes'),
            const SizedBox(height: 6),
            TextFormField(
              controller: _notesController,
              textCapitalization: TextCapitalization.sentences,
              decoration: _inputDecoration(
                  'Document your intent, clay type, or early progress…'),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _Label('Clay Body'),
                      const SizedBox(height: 6),
                      _DropdownField(
                        value: _clayBody,
                        hint: 'Select Clay',
                        options: _clayOptions,
                        onChanged: (v) => setState(() => _clayBody = v),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _Label('Firing'),
                      const SizedBox(height: 6),
                      _DropdownField(
                        value: _firingTemp,
                        hint: 'Select Temperature',
                        options: _firingOptions,
                        onChanged: (v) => setState(() => _firingTemp = v),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.save_outlined),
              label: const Text('Save Piece'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFCC4A2A),
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      );
}

// ---------------------------------------------------------------------------
// Sub-widgets
// ---------------------------------------------------------------------------

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context)
          .textTheme
          .labelMedium
          ?.copyWith(fontWeight: FontWeight.w600, color: const Color(0xFF4A3828)),
    );
  }
}

class _CoverPhotoPicker extends StatelessWidget {
  const _CoverPhotoPicker({required this.path, required this.onTap});

  final String? path;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: path != null ? null : const Color(0xFFE8E0D8),
          borderRadius: BorderRadius.circular(16),
          image: path != null
              ? DecorationImage(
                  image: FileImage(File(path!)),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: path == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt_outlined,
                    size: 36,
                    color: Colors.grey.shade500,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add Cover Photo',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'CAPTURE THE RAW FORM',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 10,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              )
            : const Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: CircleAvatar(
                    backgroundColor: Colors.black54,
                    radius: 16,
                    child: Icon(Icons.edit, size: 16, color: Colors.white),
                  ),
                ),
              ),
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.value,
    required this.hint,
    required this.options,
    required this.onChanged,
  });

  final String? value;
  final String hint;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            hint,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, size: 18),
          items: options
              .map((o) => DropdownMenuItem(value: o, child: Text(o, style: const TextStyle(fontSize: 12))))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

enum ImageSourceChoice { camera, gallery }

class _PhotoSourceSheet extends StatelessWidget {
  const _PhotoSourceSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt_outlined),
            title: const Text('Take Photo'),
            onTap: () => Navigator.pop(context, ImageSourceChoice.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library_outlined),
            title: const Text('Choose from Gallery'),
            onTap: () => Navigator.pop(context, ImageSourceChoice.gallery),
          ),
        ],
      ),
    );
  }
}
