import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pottery_diary/database/app_database.dart';
import 'package:pottery_diary/models/stage_type.dart';
import 'package:pottery_diary/providers/providers.dart';
import 'package:pottery_diary/screens/create_piece_screen.dart';
import 'package:pottery_diary/services/photo_storage.dart';

class StageEntryScreen extends ConsumerStatefulWidget {
  const StageEntryScreen({
    super.key,
    required this.pieceId,
    required this.stageType,
    this.existingStage,
  });

  final int pieceId;
  final StageType stageType;
  final Stage? existingStage;

  @override
  ConsumerState<StageEntryScreen> createState() => _StageEntryScreenState();
}

class _StageEntryScreenState extends ConsumerState<StageEntryScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _notesController;
  late bool _isComplete;
  late DateTime _recordedAt;
  final List<String> _newPhotoPaths = [];
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.existingStage?.title ?? '');
    _notesController =
        TextEditingController(text: widget.existingStage?.description ?? '');
    _isComplete = widget.existingStage?.completedAt != null;
    _recordedAt = widget.existingStage?.recordedAt ?? DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _addPhoto() async {
    final choice = await showModalBottomSheet<ImageSourceChoice>(
      context: context,
      builder: (_) => const _PhotoSourceSheet(),
    );
    if (choice == null) return;
    final path = choice == ImageSourceChoice.camera
        ? await PhotoStorage.pickFromCamera()
        : await PhotoStorage.pickFromGallery();
    if (path != null) setState(() => _newPhotoPaths.add(path));
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _recordedAt,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_recordedAt),
    );
    if (!mounted) return;
    setState(() {
      _recordedAt = DateTime(
        picked.year,
        picked.month,
        picked.day,
        time?.hour ?? _recordedAt.hour,
        time?.minute ?? _recordedAt.minute,
      );
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final repo = ref.read(pieceRepositoryProvider);
    final stage = widget.existingStage;

    int stageId;
    if (stage == null) {
      stageId = await repo.createStage(
        pieceId: widget.pieceId,
        stageType: widget.stageType,
        title: _titleController.text.trim().isEmpty
            ? null
            : _titleController.text.trim(),
        description: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );
      if (_isComplete) await repo.completeStage(stageId);
    } else {
      stageId = stage.id;
      await repo.updateStage(
        stageId,
        title: _titleController.text.trim().isEmpty
            ? null
            : _titleController.text.trim(),
        description: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );
      if (_isComplete && stage.completedAt == null) {
        await repo.completeStage(stageId);
      }
    }

    for (final path in _newPhotoPaths) {
      await repo.addPhoto(stageId: stageId, localPath: path);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final alreadyComplete =
        widget.existingStage?.completedAt != null;
    final existingPhotos = widget.existingStage != null
        ? (ref
                .watch(photosForStageProvider(widget.existingStage!.id))
                .valueOrNull ??
            [])
        : <Photo>[];

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
        title: Text('Update ${widget.stageType.displayName}'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child:
                        CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const _SectionLabel('Stage Title'),
          const SizedBox(height: 6),
          _TextField(
            controller: _titleController,
            hint: 'e.g. Leather Hard Refinement',
          ),
          const SizedBox(height: 16),
          const _SectionLabel('Progress Notes'),
          const SizedBox(height: 6),
          _TextField(
            controller: _notesController,
            hint: 'Describe the texture, the weight, and how the clay felt under your tools…',
            maxLines: 6,
          ),
          const SizedBox(height: 16),
          const _SectionLabel('Date & Time'),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: _pickDate,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today_outlined,
                      size: 16, color: Colors.grey.shade500),
                  const SizedBox(width: 8),
                  Text(
                    _formatDateTime(_recordedAt),
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  const Spacer(),
                  Icon(Icons.keyboard_arrow_right,
                      size: 16, color: Colors.grey.shade400),
                ],
              ),
            ),
          ),
          if (!alreadyComplete) ...[
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SwitchListTile(
                value: _isComplete,
                onChanged: (v) => setState(() => _isComplete = v),
                title: const Text('Stage Complete'),
                subtitle: _isComplete
                    ? const Text('This stage is marked as done.')
                    : null,
                activeThumbColor: const Color(0xFFCC4A2A),
              ),
            ),
          ],
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const _SectionLabel('Visual Progress'),
              TextButton.icon(
                onPressed: _addPhoto,
                icon: const Icon(Icons.add_photo_alternate_outlined, size: 16),
                label: const Text('Add Photo'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFFCC4A2A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (existingPhotos.isEmpty && _newPhotoPaths.isEmpty)
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: Colors.grey.shade200, style: BorderStyle.solid),
              ),
              child: Center(
                child: Text(
                  'No photos yet — tap Add Photo',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                ),
              ),
            )
          else
            SizedBox(
              height: 110,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ...existingPhotos.map(
                    (p) => _PhotoThumb(path: p.localPath),
                  ),
                  ..._newPhotoPaths.map(
                    (path) => _PhotoThumb(path: path, isNew: true),
                  ),
                  _AddPhotoThumb(onTap: _addPhoto),
                ],
              ),
            ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: _saving ? null : _save,
            icon: const Icon(Icons.save_outlined),
            label: const Text('Save Update'),
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
    );
  }

  static String _formatDateTime(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}  $h:$m';
  }
}

// ---------------------------------------------------------------------------
// Sub-widgets
// ---------------------------------------------------------------------------

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF4A3828),
          ),
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String hint;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textCapitalization: TextCapitalization.sentences,
      maxLines: maxLines,
      decoration: InputDecoration(
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
      ),
    );
  }
}

class _PhotoThumb extends StatelessWidget {
  const _PhotoThumb({required this.path, this.isNew = false});

  final String path;
  final bool isNew;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              File(path),
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          if (isNew)
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFCC4A2A),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'NEW',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AddPhotoThumb extends StatelessWidget {
  const _AddPhotoThumb({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Icon(
          Icons.add_photo_alternate_outlined,
          color: Colors.grey.shade400,
        ),
      ),
    );
  }
}

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
