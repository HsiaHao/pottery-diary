import 'package:flutter/material.dart';
import 'package:pottery_diary/database/app_database.dart';
import 'package:pottery_diary/models/stage_type.dart';

class StageTile extends StatelessWidget {
  const StageTile({
    super.key,
    required this.stageType,
    this.stage,
  });

  final StageType stageType;
  final Stage? stage;

  @override
  Widget build(BuildContext context) {
    final isComplete = stage?.completedAt != null;
    final isStarted = stage != null;
    final scheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(
          isComplete
              ? Icons.check_circle
              : isStarted
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
          color: isComplete
              ? scheme.primary
              : isStarted
                  ? scheme.primary.withAlpha(128)
                  : Colors.grey.shade400,
        ),
        title: Text(stageType.displayName),
        subtitle: _buildSubtitle(),
        trailing: isComplete
            ? Text(
                _formatDate(stage!.completedAt!),
                style: Theme.of(context).textTheme.bodySmall,
              )
            : null,
      ),
    );
  }

  Widget _buildSubtitle() {
    if (stage == null) return const Text('Not started');
    final desc = stage!.description;
    if (desc != null && desc.isNotEmpty) {
      return Text(desc, maxLines: 2, overflow: TextOverflow.ellipsis);
    }
    if (stage!.completedAt != null) return const Text('Complete');
    return const Text('In progress');
  }

  static String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}';
  }
}
