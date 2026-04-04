enum StageStatus {
  inProgress,
  complete,
  failed;

  static StageStatus fromString(String? value) {
    return StageStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => StageStatus.inProgress,
    );
  }

  String get label {
    switch (this) {
      case StageStatus.inProgress:
        return 'In Progress';
      case StageStatus.complete:
        return 'Complete';
      case StageStatus.failed:
        return 'Failed';
    }
  }
}
