enum StageType {
  trimmed,
  bisque,
  glazeFired;

  static StageType fromString(String value) {
    return StageType.values.firstWhere((e) => e.name == value);
  }

  String get displayName {
    switch (this) {
      case StageType.trimmed:
        return 'Trimmed';
      case StageType.bisque:
        return 'Bisque';
      case StageType.glazeFired:
        return 'Glaze Fired';
    }
  }
}
