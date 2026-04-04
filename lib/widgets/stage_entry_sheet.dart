import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pottery_diary/database/app_database.dart';
import 'package:pottery_diary/models/stage_type.dart';
import 'package:pottery_diary/providers/providers.dart';

class StageEntrySheet extends ConsumerStatefulWidget {
  const StageEntrySheet({
    super.key,
    required this.pieceId,
    required this.stageType,
    this.existingStage,
  });

  final int pieceId;
  final StageType stageType;
  final Stage? existingStage;

  @override
  ConsumerState<StageEntrySheet> createState() => _StageEntrySheetState();
}

class _StageEntrySheetState extends ConsumerState<StageEntrySheet> {
  late final TextEditingController _descController;
  late bool _isComplete;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _descController = TextEditingController(
      text: widget.existingStage?.description ?? '',
    );
    _isComplete = widget.existingStage?.completedAt != null;
  }

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final repo = ref.read(pieceRepositoryProvider);
    final stage = widget.existingStage;

    if (stage == null) {
      // Create new stage record
      final stageId = await repo.createStage(
        pieceId: widget.pieceId,
        stageType: widget.stageType,
        description: _descController.text.trim().isEmpty
            ? null
            : _descController.text.trim(),
      );
      if (_isComplete) await repo.completeStage(stageId);
    } else {
      // Update description
      await repo.updateStageDescription(
        stage.id,
        _descController.text.trim(),
      );
      // Mark complete if toggled on and not already complete
      if (_isComplete && stage.completedAt == null) {
        await repo.completeStage(stage.id);
      }
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isNew = widget.existingStage == null;
    final alreadyComplete =
        !isNew && widget.existingStage!.completedAt != null;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.stageType.displayName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              if (alreadyComplete)
                const Chip(
                  label: Text('Complete'),
                  avatar: Icon(Icons.check_circle, size: 16),
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descController,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Notes',
              hintText: 'Describe this stage…',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            maxLines: 5,
          ),
          if (!alreadyComplete) ...[
            const SizedBox(height: 12),
            CheckboxListTile(
              value: _isComplete,
              onChanged: (v) => setState(() => _isComplete = v ?? false),
              title: const Text('Mark as complete'),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ],
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
    );
  }
}
