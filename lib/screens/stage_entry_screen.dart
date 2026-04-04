import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pottery_diary/database/app_database.dart';
import 'package:pottery_diary/models/stage_status.dart';
import 'package:pottery_diary/models/stage_type.dart';
import 'package:pottery_diary/providers/providers.dart';
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
  late final TextEditingController _failureReasonController;
  late StageStatus _status;
  late DateTime _recordedAt;
  DateTime? _finishedAt;
  final List<String> _newPhotoPaths = [];
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final stage = widget.existingStage;
    _titleController = TextEditingController(text: stage?.title ?? '');
    _notesController = TextEditingController(text: stage?.description ?? '');
    _failureReasonController =
        TextEditingController(text: stage?.failureReason ?? '');
    _status = StageStatus.fromString(stage?.status);
    _recordedAt = stage?.recordedAt ?? DateTime.now();
    _finishedAt = stage?.finishedAt;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    _failureReasonController.dispose();
    super.dispose();
  }

  Future<void> _addPhoto() async {
    final choice = await showModalBottomSheet<_PhotoSourceChoice>(
      context: context,
      builder: (_) => const _PhotoSourceSheet(),
    );
    if (choice == null) return;
    final path = choice == _PhotoSourceChoice.camera
        ? await PhotoStorage.pickFromCamera()
        : await PhotoStorage.pickFromGallery();
    if (path != null) setState(() => _newPhotoPaths.add(path));
  }

  Future<void> _removeNewPhoto(String path) async {
    await PhotoStorage.delete(path);
    setState(() => _newPhotoPaths.remove(path));
  }

  Future<void> _pickDateTime({required bool isFinishTime}) async {
    final initial = isFinishTime ? (_finishedAt ?? DateTime.now()) : _recordedAt;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (!mounted) return;
    final result = DateTime(
      picked.year,
      picked.month,
      picked.day,
      time?.hour ?? initial.hour,
      time?.minute ?? initial.minute,
    );
    setState(() {
      if (isFinishTime) {
        _finishedAt = result;
      } else {
        _recordedAt = result;
      }
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final repo = ref.read(pieceRepositoryProvider);
    final stage = widget.existingStage;

    // Resolve finishedAt: set now if status changed to complete/failed and no time chosen
    final finishedAt = _status != StageStatus.inProgress
        ? (_finishedAt ?? DateTime.now())
        : null;

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
        status: _status,
        failureReason: _status == StageStatus.failed
            ? _failureReasonController.text.trim().isEmpty
                ? null
                : _failureReasonController.text.trim()
            : null,
        finishedAt: finishedAt,
      );
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
        status: _status,
        failureReason: _status == StageStatus.failed
            ? _failureReasonController.text.trim().isEmpty
                ? null
                : _failureReasonController.text.trim()
            : null,
        finishedAt: finishedAt,
      );
    }

    for (final path in _newPhotoPaths) {
      await repo.addPhoto(
        stageId: stageId,
        pieceId: widget.pieceId,
        localPath: path,
      );
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const _Label('Stage Title'),
          const SizedBox(height: 6),
          _InputField(
            controller: _titleController,
            hint: 'e.g. Leather Hard Refinement',
          ),
          const SizedBox(height: 16),
          const _Label('Progress Notes'),
          const SizedBox(height: 6),
          _InputField(
            controller: _notesController,
            hint:
                'Describe the texture, the weight, and how the clay felt under your tools…',
            maxLines: 5,
          ),
          const SizedBox(height: 16),
          const _Label('Record Time'),
          const SizedBox(height: 6),
          _DateTimeRow(
            dt: _recordedAt,
            onTap: () => _pickDateTime(isFinishTime: false),
          ),
          const SizedBox(height: 20),

          // ----- Status selector -----
          const _Label('Stage Status'),
          const SizedBox(height: 8),
          _StatusSelector(
            current: _status,
            onChanged: (s) => setState(() {
              _status = s;
              if (s != StageStatus.inProgress && _finishedAt == null) {
                _finishedAt = DateTime.now();
              }
              if (s == StageStatus.inProgress) _finishedAt = null;
            }),
          ),

          // ----- Failure reason -----
          if (_status == StageStatus.failed) ...[
            const SizedBox(height: 12),
            const _Label('Failure Reason'),
            const SizedBox(height: 6),
            _InputField(
              controller: _failureReasonController,
              hint: 'What went wrong?',
              maxLines: 3,
            ),
          ],

          // ----- Finish time -----
          if (_status != StageStatus.inProgress) ...[
            const SizedBox(height: 12),
            const _Label('Finish Time'),
            const SizedBox(height: 6),
            _DateTimeRow(
              dt: _finishedAt ?? DateTime.now(),
              onTap: () => _pickDateTime(isFinishTime: true),
            ),
          ],

          const SizedBox(height: 20),

          // ----- Photos -----
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const _Label('Photos'),
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
            GestureDetector(
              onTap: _addPhoto,
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Center(
                  child: Text(
                    'Tap to add photos',
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                  ),
                ),
              ),
            )
          else
            _PhotoStrip(
              existingPhotos: existingPhotos,
              newPaths: _newPhotoPaths,
              onAddTap: _addPhoto,
              onRemoveNew: _removeNewPhoto,
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
}

// ---------------------------------------------------------------------------
// Status selector
// ---------------------------------------------------------------------------

class _StatusSelector extends StatelessWidget {
  const _StatusSelector({
    required this.current,
    required this.onChanged,
  });

  final StageStatus current;
  final ValueChanged<StageStatus> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: StageStatus.values.map((s) {
        final selected = s == current;
        final color = s == StageStatus.complete
            ? Colors.green
            : s == StageStatus.failed
                ? Colors.red
                : Colors.orange;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(s),
            child: Container(
              margin: EdgeInsets.only(
                right: s != StageStatus.failed ? 6 : 0,
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: selected ? color.withAlpha(30) : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: selected ? color : Colors.grey.shade200,
                  width: selected ? 1.5 : 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    s == StageStatus.complete
                        ? Icons.check_circle_outline
                        : s == StageStatus.failed
                            ? Icons.cancel_outlined
                            : Icons.radio_button_unchecked,
                    color: selected ? color : Colors.grey.shade400,
                    size: 20,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    s.label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: selected ? color : Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ---------------------------------------------------------------------------
// Photo strip with existing + new + add button
// ---------------------------------------------------------------------------

class _PhotoStrip extends StatelessWidget {
  const _PhotoStrip({
    required this.existingPhotos,
    required this.newPaths,
    required this.onAddTap,
    required this.onRemoveNew,
  });

  final List<Photo> existingPhotos;
  final List<String> newPaths;
  final VoidCallback onAddTap;
  final ValueChanged<String> onRemoveNew;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ...existingPhotos.map((p) => _Thumb(path: p.localPath)),
          ...newPaths.map(
            (path) => _Thumb(
              path: path,
              isNew: true,
              onRemove: () => onRemoveNew(path),
            ),
          ),
          _AddThumb(onTap: onAddTap),
        ],
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({required this.path, this.isNew = false, this.onRemove});

  final String path;
  final bool isNew;
  final VoidCallback? onRemove;

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
          if (isNew && onRemove != null)
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 16, color: Colors.white),
                ),
              ),
            ),
          if (isNew)
            Positioned(
              bottom: 4,
              left: 4,
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
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AddThumb extends StatelessWidget {
  const _AddThumb({required this.onTap});

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

// ---------------------------------------------------------------------------
// Shared helpers
// ---------------------------------------------------------------------------

class _Label extends StatelessWidget {
  const _Label(this.text);

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

class _InputField extends StatelessWidget {
  const _InputField({
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

class _DateTimeRow extends StatelessWidget {
  const _DateTimeRow({required this.dt, required this.onTap});

  final DateTime dt;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
              _fmt(dt),
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const Spacer(),
            Icon(Icons.keyboard_arrow_right,
                size: 16, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  static String _fmt(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}  $h:$m';
  }
}

enum _PhotoSourceChoice { camera, gallery }

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
            onTap: () => Navigator.pop(context, _PhotoSourceChoice.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library_outlined),
            title: const Text('Choose from Gallery'),
            onTap: () => Navigator.pop(context, _PhotoSourceChoice.gallery),
          ),
        ],
      ),
    );
  }
}
