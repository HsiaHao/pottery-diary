enum StageType {
  formed,
  trimmed,
  bisqued,
  glazed,
  finished;

  static StageType fromString(String value) {
    switch (value) {
      case 'bisque':
        return StageType.bisqued;
      case 'glazeFired':
        return StageType.glazed;
      default:
        return StageType.values.firstWhere(
          (e) => e.name == value,
          orElse: () => StageType.formed,
        );
    }
  }

  String get displayName {
    switch (this) {
      case StageType.formed:
        return 'Formed';
      case StageType.trimmed:
        return 'Trimmed';
      case StageType.bisqued:
        return 'Bisqued';
      case StageType.glazed:
        return 'Glazed';
      case StageType.finished:
        return 'Finished';
    }
  }

  String get shortLabel {
    switch (this) {
      case StageType.formed:
        return 'FORMED';
      case StageType.trimmed:
        return 'TRIMMED';
      case StageType.bisqued:
        return 'BISQUED';
      case StageType.glazed:
        return 'GLAZED';
      case StageType.finished:
        return 'FINISHED';
    }
  }
}
