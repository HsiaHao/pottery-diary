enum StageStatus {
  notDone,
  done;

  static StageStatus fromString(String? value) {
    // Map old values to new ones for backwards compatibility
    if (value == 'complete') return StageStatus.done;
    if (value == 'done') return StageStatus.done;
    return StageStatus.notDone;
  }

  String get name => switch (this) {
        StageStatus.notDone => 'notDone',
        StageStatus.done => 'done',
      };

  String get label => switch (this) {
        StageStatus.notDone => 'Not Done',
        StageStatus.done => 'Done',
      };
}
