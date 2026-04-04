// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PiecesTable extends Pieces with TableInfo<$PiecesTable, Piece> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PiecesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _coverPhotoPathMeta = const VerificationMeta(
    'coverPhotoPath',
  );
  @override
  late final GeneratedColumn<String> coverPhotoPath = GeneratedColumn<String>(
    'cover_photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clayBodyMeta = const VerificationMeta(
    'clayBody',
  );
  @override
  late final GeneratedColumn<String> clayBody = GeneratedColumn<String>(
    'clay_body',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _firingTempMeta = const VerificationMeta(
    'firingTemp',
  );
  @override
  late final GeneratedColumn<String> firingTemp = GeneratedColumn<String>(
    'firing_temp',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    coverPhotoPath,
    clayBody,
    firingTemp,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pieces';
  @override
  VerificationContext validateIntegrity(
    Insertable<Piece> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('cover_photo_path')) {
      context.handle(
        _coverPhotoPathMeta,
        coverPhotoPath.isAcceptableOrUnknown(
          data['cover_photo_path']!,
          _coverPhotoPathMeta,
        ),
      );
    }
    if (data.containsKey('clay_body')) {
      context.handle(
        _clayBodyMeta,
        clayBody.isAcceptableOrUnknown(data['clay_body']!, _clayBodyMeta),
      );
    }
    if (data.containsKey('firing_temp')) {
      context.handle(
        _firingTempMeta,
        firingTemp.isAcceptableOrUnknown(data['firing_temp']!, _firingTempMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Piece map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Piece(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      coverPhotoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_photo_path'],
      ),
      clayBody: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}clay_body'],
      ),
      firingTemp: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}firing_temp'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PiecesTable createAlias(String alias) {
    return $PiecesTable(attachedDatabase, alias);
  }
}

class Piece extends DataClass implements Insertable<Piece> {
  final int id;
  final String title;
  final String? description;
  final String? coverPhotoPath;
  final String? clayBody;
  final String? firingTemp;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Piece({
    required this.id,
    required this.title,
    this.description,
    this.coverPhotoPath,
    this.clayBody,
    this.firingTemp,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || coverPhotoPath != null) {
      map['cover_photo_path'] = Variable<String>(coverPhotoPath);
    }
    if (!nullToAbsent || clayBody != null) {
      map['clay_body'] = Variable<String>(clayBody);
    }
    if (!nullToAbsent || firingTemp != null) {
      map['firing_temp'] = Variable<String>(firingTemp);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PiecesCompanion toCompanion(bool nullToAbsent) {
    return PiecesCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      coverPhotoPath: coverPhotoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(coverPhotoPath),
      clayBody: clayBody == null && nullToAbsent
          ? const Value.absent()
          : Value(clayBody),
      firingTemp: firingTemp == null && nullToAbsent
          ? const Value.absent()
          : Value(firingTemp),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Piece.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Piece(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      coverPhotoPath: serializer.fromJson<String?>(json['coverPhotoPath']),
      clayBody: serializer.fromJson<String?>(json['clayBody']),
      firingTemp: serializer.fromJson<String?>(json['firingTemp']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'coverPhotoPath': serializer.toJson<String?>(coverPhotoPath),
      'clayBody': serializer.toJson<String?>(clayBody),
      'firingTemp': serializer.toJson<String?>(firingTemp),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Piece copyWith({
    int? id,
    String? title,
    Value<String?> description = const Value.absent(),
    Value<String?> coverPhotoPath = const Value.absent(),
    Value<String?> clayBody = const Value.absent(),
    Value<String?> firingTemp = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Piece(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    coverPhotoPath: coverPhotoPath.present
        ? coverPhotoPath.value
        : this.coverPhotoPath,
    clayBody: clayBody.present ? clayBody.value : this.clayBody,
    firingTemp: firingTemp.present ? firingTemp.value : this.firingTemp,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Piece copyWithCompanion(PiecesCompanion data) {
    return Piece(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      coverPhotoPath: data.coverPhotoPath.present
          ? data.coverPhotoPath.value
          : this.coverPhotoPath,
      clayBody: data.clayBody.present ? data.clayBody.value : this.clayBody,
      firingTemp: data.firingTemp.present
          ? data.firingTemp.value
          : this.firingTemp,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Piece(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('coverPhotoPath: $coverPhotoPath, ')
          ..write('clayBody: $clayBody, ')
          ..write('firingTemp: $firingTemp, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    coverPhotoPath,
    clayBody,
    firingTemp,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Piece &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.coverPhotoPath == this.coverPhotoPath &&
          other.clayBody == this.clayBody &&
          other.firingTemp == this.firingTemp &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PiecesCompanion extends UpdateCompanion<Piece> {
  final Value<int> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<String?> coverPhotoPath;
  final Value<String?> clayBody;
  final Value<String?> firingTemp;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const PiecesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.coverPhotoPath = const Value.absent(),
    this.clayBody = const Value.absent(),
    this.firingTemp = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PiecesCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.description = const Value.absent(),
    this.coverPhotoPath = const Value.absent(),
    this.clayBody = const Value.absent(),
    this.firingTemp = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : title = Value(title),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Piece> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? coverPhotoPath,
    Expression<String>? clayBody,
    Expression<String>? firingTemp,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (coverPhotoPath != null) 'cover_photo_path': coverPhotoPath,
      if (clayBody != null) 'clay_body': clayBody,
      if (firingTemp != null) 'firing_temp': firingTemp,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PiecesCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String?>? description,
    Value<String?>? coverPhotoPath,
    Value<String?>? clayBody,
    Value<String?>? firingTemp,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return PiecesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      coverPhotoPath: coverPhotoPath ?? this.coverPhotoPath,
      clayBody: clayBody ?? this.clayBody,
      firingTemp: firingTemp ?? this.firingTemp,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (coverPhotoPath.present) {
      map['cover_photo_path'] = Variable<String>(coverPhotoPath.value);
    }
    if (clayBody.present) {
      map['clay_body'] = Variable<String>(clayBody.value);
    }
    if (firingTemp.present) {
      map['firing_temp'] = Variable<String>(firingTemp.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PiecesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('coverPhotoPath: $coverPhotoPath, ')
          ..write('clayBody: $clayBody, ')
          ..write('firingTemp: $firingTemp, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $StagesTable extends Stages with TableInfo<$StagesTable, Stage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _pieceIdMeta = const VerificationMeta(
    'pieceId',
  );
  @override
  late final GeneratedColumn<int> pieceId = GeneratedColumn<int>(
    'piece_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES pieces (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _stageTypeMeta = const VerificationMeta(
    'stageType',
  );
  @override
  late final GeneratedColumn<String> stageType = GeneratedColumn<String>(
    'stage_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('inProgress'),
  );
  static const VerificationMeta _failureReasonMeta = const VerificationMeta(
    'failureReason',
  );
  @override
  late final GeneratedColumn<String> failureReason = GeneratedColumn<String>(
    'failure_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _finishedAtMeta = const VerificationMeta(
    'finishedAt',
  );
  @override
  late final GeneratedColumn<DateTime> finishedAt = GeneratedColumn<DateTime>(
    'finished_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recordedAtMeta = const VerificationMeta(
    'recordedAt',
  );
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
    'recorded_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    pieceId,
    stageType,
    title,
    description,
    status,
    failureReason,
    finishedAt,
    completedAt,
    recordedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stages';
  @override
  VerificationContext validateIntegrity(
    Insertable<Stage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('piece_id')) {
      context.handle(
        _pieceIdMeta,
        pieceId.isAcceptableOrUnknown(data['piece_id']!, _pieceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_pieceIdMeta);
    }
    if (data.containsKey('stage_type')) {
      context.handle(
        _stageTypeMeta,
        stageType.isAcceptableOrUnknown(data['stage_type']!, _stageTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_stageTypeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('failure_reason')) {
      context.handle(
        _failureReasonMeta,
        failureReason.isAcceptableOrUnknown(
          data['failure_reason']!,
          _failureReasonMeta,
        ),
      );
    }
    if (data.containsKey('finished_at')) {
      context.handle(
        _finishedAtMeta,
        finishedAt.isAcceptableOrUnknown(data['finished_at']!, _finishedAtMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Stage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Stage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      pieceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}piece_id'],
      )!,
      stageType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stage_type'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      failureReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}failure_reason'],
      ),
      finishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}finished_at'],
      ),
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}recorded_at'],
      )!,
    );
  }

  @override
  $StagesTable createAlias(String alias) {
    return $StagesTable(attachedDatabase, alias);
  }
}

class Stage extends DataClass implements Insertable<Stage> {
  final int id;
  final int pieceId;
  final String stageType;
  final String? title;
  final String? description;
  final String status;
  final String? failureReason;
  final DateTime? finishedAt;
  final DateTime? completedAt;
  final DateTime recordedAt;
  const Stage({
    required this.id,
    required this.pieceId,
    required this.stageType,
    this.title,
    this.description,
    required this.status,
    this.failureReason,
    this.finishedAt,
    this.completedAt,
    required this.recordedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['piece_id'] = Variable<int>(pieceId);
    map['stage_type'] = Variable<String>(stageType);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || failureReason != null) {
      map['failure_reason'] = Variable<String>(failureReason);
    }
    if (!nullToAbsent || finishedAt != null) {
      map['finished_at'] = Variable<DateTime>(finishedAt);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    return map;
  }

  StagesCompanion toCompanion(bool nullToAbsent) {
    return StagesCompanion(
      id: Value(id),
      pieceId: Value(pieceId),
      stageType: Value(stageType),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      status: Value(status),
      failureReason: failureReason == null && nullToAbsent
          ? const Value.absent()
          : Value(failureReason),
      finishedAt: finishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(finishedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      recordedAt: Value(recordedAt),
    );
  }

  factory Stage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Stage(
      id: serializer.fromJson<int>(json['id']),
      pieceId: serializer.fromJson<int>(json['pieceId']),
      stageType: serializer.fromJson<String>(json['stageType']),
      title: serializer.fromJson<String?>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      status: serializer.fromJson<String>(json['status']),
      failureReason: serializer.fromJson<String?>(json['failureReason']),
      finishedAt: serializer.fromJson<DateTime?>(json['finishedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pieceId': serializer.toJson<int>(pieceId),
      'stageType': serializer.toJson<String>(stageType),
      'title': serializer.toJson<String?>(title),
      'description': serializer.toJson<String?>(description),
      'status': serializer.toJson<String>(status),
      'failureReason': serializer.toJson<String?>(failureReason),
      'finishedAt': serializer.toJson<DateTime?>(finishedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
    };
  }

  Stage copyWith({
    int? id,
    int? pieceId,
    String? stageType,
    Value<String?> title = const Value.absent(),
    Value<String?> description = const Value.absent(),
    String? status,
    Value<String?> failureReason = const Value.absent(),
    Value<DateTime?> finishedAt = const Value.absent(),
    Value<DateTime?> completedAt = const Value.absent(),
    DateTime? recordedAt,
  }) => Stage(
    id: id ?? this.id,
    pieceId: pieceId ?? this.pieceId,
    stageType: stageType ?? this.stageType,
    title: title.present ? title.value : this.title,
    description: description.present ? description.value : this.description,
    status: status ?? this.status,
    failureReason: failureReason.present
        ? failureReason.value
        : this.failureReason,
    finishedAt: finishedAt.present ? finishedAt.value : this.finishedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    recordedAt: recordedAt ?? this.recordedAt,
  );
  Stage copyWithCompanion(StagesCompanion data) {
    return Stage(
      id: data.id.present ? data.id.value : this.id,
      pieceId: data.pieceId.present ? data.pieceId.value : this.pieceId,
      stageType: data.stageType.present ? data.stageType.value : this.stageType,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      status: data.status.present ? data.status.value : this.status,
      failureReason: data.failureReason.present
          ? data.failureReason.value
          : this.failureReason,
      finishedAt: data.finishedAt.present
          ? data.finishedAt.value
          : this.finishedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Stage(')
          ..write('id: $id, ')
          ..write('pieceId: $pieceId, ')
          ..write('stageType: $stageType, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('failureReason: $failureReason, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('recordedAt: $recordedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    pieceId,
    stageType,
    title,
    description,
    status,
    failureReason,
    finishedAt,
    completedAt,
    recordedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Stage &&
          other.id == this.id &&
          other.pieceId == this.pieceId &&
          other.stageType == this.stageType &&
          other.title == this.title &&
          other.description == this.description &&
          other.status == this.status &&
          other.failureReason == this.failureReason &&
          other.finishedAt == this.finishedAt &&
          other.completedAt == this.completedAt &&
          other.recordedAt == this.recordedAt);
}

class StagesCompanion extends UpdateCompanion<Stage> {
  final Value<int> id;
  final Value<int> pieceId;
  final Value<String> stageType;
  final Value<String?> title;
  final Value<String?> description;
  final Value<String> status;
  final Value<String?> failureReason;
  final Value<DateTime?> finishedAt;
  final Value<DateTime?> completedAt;
  final Value<DateTime> recordedAt;
  const StagesCompanion({
    this.id = const Value.absent(),
    this.pieceId = const Value.absent(),
    this.stageType = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.status = const Value.absent(),
    this.failureReason = const Value.absent(),
    this.finishedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.recordedAt = const Value.absent(),
  });
  StagesCompanion.insert({
    this.id = const Value.absent(),
    required int pieceId,
    required String stageType,
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.status = const Value.absent(),
    this.failureReason = const Value.absent(),
    this.finishedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    required DateTime recordedAt,
  }) : pieceId = Value(pieceId),
       stageType = Value(stageType),
       recordedAt = Value(recordedAt);
  static Insertable<Stage> custom({
    Expression<int>? id,
    Expression<int>? pieceId,
    Expression<String>? stageType,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? status,
    Expression<String>? failureReason,
    Expression<DateTime>? finishedAt,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? recordedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pieceId != null) 'piece_id': pieceId,
      if (stageType != null) 'stage_type': stageType,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (status != null) 'status': status,
      if (failureReason != null) 'failure_reason': failureReason,
      if (finishedAt != null) 'finished_at': finishedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (recordedAt != null) 'recorded_at': recordedAt,
    });
  }

  StagesCompanion copyWith({
    Value<int>? id,
    Value<int>? pieceId,
    Value<String>? stageType,
    Value<String?>? title,
    Value<String?>? description,
    Value<String>? status,
    Value<String?>? failureReason,
    Value<DateTime?>? finishedAt,
    Value<DateTime?>? completedAt,
    Value<DateTime>? recordedAt,
  }) {
    return StagesCompanion(
      id: id ?? this.id,
      pieceId: pieceId ?? this.pieceId,
      stageType: stageType ?? this.stageType,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      failureReason: failureReason ?? this.failureReason,
      finishedAt: finishedAt ?? this.finishedAt,
      completedAt: completedAt ?? this.completedAt,
      recordedAt: recordedAt ?? this.recordedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (pieceId.present) {
      map['piece_id'] = Variable<int>(pieceId.value);
    }
    if (stageType.present) {
      map['stage_type'] = Variable<String>(stageType.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (failureReason.present) {
      map['failure_reason'] = Variable<String>(failureReason.value);
    }
    if (finishedAt.present) {
      map['finished_at'] = Variable<DateTime>(finishedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StagesCompanion(')
          ..write('id: $id, ')
          ..write('pieceId: $pieceId, ')
          ..write('stageType: $stageType, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('failureReason: $failureReason, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('recordedAt: $recordedAt')
          ..write(')'))
        .toString();
  }
}

class $PhotosTable extends Photos with TableInfo<$PhotosTable, Photo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PhotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _stageIdMeta = const VerificationMeta(
    'stageId',
  );
  @override
  late final GeneratedColumn<int> stageId = GeneratedColumn<int>(
    'stage_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES stages (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _localPathMeta = const VerificationMeta(
    'localPath',
  );
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
    'local_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _captionMeta = const VerificationMeta(
    'caption',
  );
  @override
  late final GeneratedColumn<String> caption = GeneratedColumn<String>(
    'caption',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recordedAtMeta = const VerificationMeta(
    'recordedAt',
  );
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
    'recorded_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    stageId,
    localPath,
    caption,
    recordedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'photos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Photo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('stage_id')) {
      context.handle(
        _stageIdMeta,
        stageId.isAcceptableOrUnknown(data['stage_id']!, _stageIdMeta),
      );
    } else if (isInserting) {
      context.missing(_stageIdMeta);
    }
    if (data.containsKey('local_path')) {
      context.handle(
        _localPathMeta,
        localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta),
      );
    } else if (isInserting) {
      context.missing(_localPathMeta);
    }
    if (data.containsKey('caption')) {
      context.handle(
        _captionMeta,
        caption.isAcceptableOrUnknown(data['caption']!, _captionMeta),
      );
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Photo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Photo(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      stageId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stage_id'],
      )!,
      localPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_path'],
      )!,
      caption: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}caption'],
      ),
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}recorded_at'],
      )!,
    );
  }

  @override
  $PhotosTable createAlias(String alias) {
    return $PhotosTable(attachedDatabase, alias);
  }
}

class Photo extends DataClass implements Insertable<Photo> {
  final int id;
  final int stageId;
  final String localPath;
  final String? caption;
  final DateTime recordedAt;
  const Photo({
    required this.id,
    required this.stageId,
    required this.localPath,
    this.caption,
    required this.recordedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['stage_id'] = Variable<int>(stageId);
    map['local_path'] = Variable<String>(localPath);
    if (!nullToAbsent || caption != null) {
      map['caption'] = Variable<String>(caption);
    }
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    return map;
  }

  PhotosCompanion toCompanion(bool nullToAbsent) {
    return PhotosCompanion(
      id: Value(id),
      stageId: Value(stageId),
      localPath: Value(localPath),
      caption: caption == null && nullToAbsent
          ? const Value.absent()
          : Value(caption),
      recordedAt: Value(recordedAt),
    );
  }

  factory Photo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Photo(
      id: serializer.fromJson<int>(json['id']),
      stageId: serializer.fromJson<int>(json['stageId']),
      localPath: serializer.fromJson<String>(json['localPath']),
      caption: serializer.fromJson<String?>(json['caption']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'stageId': serializer.toJson<int>(stageId),
      'localPath': serializer.toJson<String>(localPath),
      'caption': serializer.toJson<String?>(caption),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
    };
  }

  Photo copyWith({
    int? id,
    int? stageId,
    String? localPath,
    Value<String?> caption = const Value.absent(),
    DateTime? recordedAt,
  }) => Photo(
    id: id ?? this.id,
    stageId: stageId ?? this.stageId,
    localPath: localPath ?? this.localPath,
    caption: caption.present ? caption.value : this.caption,
    recordedAt: recordedAt ?? this.recordedAt,
  );
  Photo copyWithCompanion(PhotosCompanion data) {
    return Photo(
      id: data.id.present ? data.id.value : this.id,
      stageId: data.stageId.present ? data.stageId.value : this.stageId,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      caption: data.caption.present ? data.caption.value : this.caption,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Photo(')
          ..write('id: $id, ')
          ..write('stageId: $stageId, ')
          ..write('localPath: $localPath, ')
          ..write('caption: $caption, ')
          ..write('recordedAt: $recordedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, stageId, localPath, caption, recordedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Photo &&
          other.id == this.id &&
          other.stageId == this.stageId &&
          other.localPath == this.localPath &&
          other.caption == this.caption &&
          other.recordedAt == this.recordedAt);
}

class PhotosCompanion extends UpdateCompanion<Photo> {
  final Value<int> id;
  final Value<int> stageId;
  final Value<String> localPath;
  final Value<String?> caption;
  final Value<DateTime> recordedAt;
  const PhotosCompanion({
    this.id = const Value.absent(),
    this.stageId = const Value.absent(),
    this.localPath = const Value.absent(),
    this.caption = const Value.absent(),
    this.recordedAt = const Value.absent(),
  });
  PhotosCompanion.insert({
    this.id = const Value.absent(),
    required int stageId,
    required String localPath,
    this.caption = const Value.absent(),
    required DateTime recordedAt,
  }) : stageId = Value(stageId),
       localPath = Value(localPath),
       recordedAt = Value(recordedAt);
  static Insertable<Photo> custom({
    Expression<int>? id,
    Expression<int>? stageId,
    Expression<String>? localPath,
    Expression<String>? caption,
    Expression<DateTime>? recordedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (stageId != null) 'stage_id': stageId,
      if (localPath != null) 'local_path': localPath,
      if (caption != null) 'caption': caption,
      if (recordedAt != null) 'recorded_at': recordedAt,
    });
  }

  PhotosCompanion copyWith({
    Value<int>? id,
    Value<int>? stageId,
    Value<String>? localPath,
    Value<String?>? caption,
    Value<DateTime>? recordedAt,
  }) {
    return PhotosCompanion(
      id: id ?? this.id,
      stageId: stageId ?? this.stageId,
      localPath: localPath ?? this.localPath,
      caption: caption ?? this.caption,
      recordedAt: recordedAt ?? this.recordedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (stageId.present) {
      map['stage_id'] = Variable<int>(stageId.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (caption.present) {
      map['caption'] = Variable<String>(caption.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PhotosCompanion(')
          ..write('id: $id, ')
          ..write('stageId: $stageId, ')
          ..write('localPath: $localPath, ')
          ..write('caption: $caption, ')
          ..write('recordedAt: $recordedAt')
          ..write(')'))
        .toString();
  }
}

class $PieceGlazesTable extends PieceGlazes
    with TableInfo<$PieceGlazesTable, PieceGlaze> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PieceGlazesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _pieceIdMeta = const VerificationMeta(
    'pieceId',
  );
  @override
  late final GeneratedColumn<int> pieceId = GeneratedColumn<int>(
    'piece_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES pieces (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _glazeNameMeta = const VerificationMeta(
    'glazeName',
  );
  @override
  late final GeneratedColumn<String> glazeName = GeneratedColumn<String>(
    'glaze_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [pieceId, glazeName];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'piece_glazes';
  @override
  VerificationContext validateIntegrity(
    Insertable<PieceGlaze> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('piece_id')) {
      context.handle(
        _pieceIdMeta,
        pieceId.isAcceptableOrUnknown(data['piece_id']!, _pieceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_pieceIdMeta);
    }
    if (data.containsKey('glaze_name')) {
      context.handle(
        _glazeNameMeta,
        glazeName.isAcceptableOrUnknown(data['glaze_name']!, _glazeNameMeta),
      );
    } else if (isInserting) {
      context.missing(_glazeNameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {pieceId, glazeName};
  @override
  PieceGlaze map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PieceGlaze(
      pieceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}piece_id'],
      )!,
      glazeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}glaze_name'],
      )!,
    );
  }

  @override
  $PieceGlazesTable createAlias(String alias) {
    return $PieceGlazesTable(attachedDatabase, alias);
  }
}

class PieceGlaze extends DataClass implements Insertable<PieceGlaze> {
  final int pieceId;
  final String glazeName;
  const PieceGlaze({required this.pieceId, required this.glazeName});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['piece_id'] = Variable<int>(pieceId);
    map['glaze_name'] = Variable<String>(glazeName);
    return map;
  }

  PieceGlazesCompanion toCompanion(bool nullToAbsent) {
    return PieceGlazesCompanion(
      pieceId: Value(pieceId),
      glazeName: Value(glazeName),
    );
  }

  factory PieceGlaze.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PieceGlaze(
      pieceId: serializer.fromJson<int>(json['pieceId']),
      glazeName: serializer.fromJson<String>(json['glazeName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'pieceId': serializer.toJson<int>(pieceId),
      'glazeName': serializer.toJson<String>(glazeName),
    };
  }

  PieceGlaze copyWith({int? pieceId, String? glazeName}) => PieceGlaze(
    pieceId: pieceId ?? this.pieceId,
    glazeName: glazeName ?? this.glazeName,
  );
  PieceGlaze copyWithCompanion(PieceGlazesCompanion data) {
    return PieceGlaze(
      pieceId: data.pieceId.present ? data.pieceId.value : this.pieceId,
      glazeName: data.glazeName.present ? data.glazeName.value : this.glazeName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PieceGlaze(')
          ..write('pieceId: $pieceId, ')
          ..write('glazeName: $glazeName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(pieceId, glazeName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PieceGlaze &&
          other.pieceId == this.pieceId &&
          other.glazeName == this.glazeName);
}

class PieceGlazesCompanion extends UpdateCompanion<PieceGlaze> {
  final Value<int> pieceId;
  final Value<String> glazeName;
  final Value<int> rowid;
  const PieceGlazesCompanion({
    this.pieceId = const Value.absent(),
    this.glazeName = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PieceGlazesCompanion.insert({
    required int pieceId,
    required String glazeName,
    this.rowid = const Value.absent(),
  }) : pieceId = Value(pieceId),
       glazeName = Value(glazeName);
  static Insertable<PieceGlaze> custom({
    Expression<int>? pieceId,
    Expression<String>? glazeName,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (pieceId != null) 'piece_id': pieceId,
      if (glazeName != null) 'glaze_name': glazeName,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PieceGlazesCompanion copyWith({
    Value<int>? pieceId,
    Value<String>? glazeName,
    Value<int>? rowid,
  }) {
    return PieceGlazesCompanion(
      pieceId: pieceId ?? this.pieceId,
      glazeName: glazeName ?? this.glazeName,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (pieceId.present) {
      map['piece_id'] = Variable<int>(pieceId.value);
    }
    if (glazeName.present) {
      map['glaze_name'] = Variable<String>(glazeName.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PieceGlazesCompanion(')
          ..write('pieceId: $pieceId, ')
          ..write('glazeName: $glazeName, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PiecesTable pieces = $PiecesTable(this);
  late final $StagesTable stages = $StagesTable(this);
  late final $PhotosTable photos = $PhotosTable(this);
  late final $PieceGlazesTable pieceGlazes = $PieceGlazesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    pieces,
    stages,
    photos,
    pieceGlazes,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'pieces',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('stages', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'stages',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('photos', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'pieces',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('piece_glazes', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$PiecesTableCreateCompanionBuilder =
    PiecesCompanion Function({
      Value<int> id,
      required String title,
      Value<String?> description,
      Value<String?> coverPhotoPath,
      Value<String?> clayBody,
      Value<String?> firingTemp,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$PiecesTableUpdateCompanionBuilder =
    PiecesCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String?> description,
      Value<String?> coverPhotoPath,
      Value<String?> clayBody,
      Value<String?> firingTemp,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$PiecesTableReferences
    extends BaseReferences<_$AppDatabase, $PiecesTable, Piece> {
  $$PiecesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$StagesTable, List<Stage>> _stagesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.stages,
    aliasName: $_aliasNameGenerator(db.pieces.id, db.stages.pieceId),
  );

  $$StagesTableProcessedTableManager get stagesRefs {
    final manager = $$StagesTableTableManager(
      $_db,
      $_db.stages,
    ).filter((f) => f.pieceId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_stagesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PieceGlazesTable, List<PieceGlaze>>
  _pieceGlazesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.pieceGlazes,
    aliasName: $_aliasNameGenerator(db.pieces.id, db.pieceGlazes.pieceId),
  );

  $$PieceGlazesTableProcessedTableManager get pieceGlazesRefs {
    final manager = $$PieceGlazesTableTableManager(
      $_db,
      $_db.pieceGlazes,
    ).filter((f) => f.pieceId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_pieceGlazesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PiecesTableFilterComposer
    extends Composer<_$AppDatabase, $PiecesTable> {
  $$PiecesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverPhotoPath => $composableBuilder(
    column: $table.coverPhotoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clayBody => $composableBuilder(
    column: $table.clayBody,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firingTemp => $composableBuilder(
    column: $table.firingTemp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> stagesRefs(
    Expression<bool> Function($$StagesTableFilterComposer f) f,
  ) {
    final $$StagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stages,
      getReferencedColumn: (t) => t.pieceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StagesTableFilterComposer(
            $db: $db,
            $table: $db.stages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> pieceGlazesRefs(
    Expression<bool> Function($$PieceGlazesTableFilterComposer f) f,
  ) {
    final $$PieceGlazesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pieceGlazes,
      getReferencedColumn: (t) => t.pieceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PieceGlazesTableFilterComposer(
            $db: $db,
            $table: $db.pieceGlazes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PiecesTableOrderingComposer
    extends Composer<_$AppDatabase, $PiecesTable> {
  $$PiecesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverPhotoPath => $composableBuilder(
    column: $table.coverPhotoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clayBody => $composableBuilder(
    column: $table.clayBody,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firingTemp => $composableBuilder(
    column: $table.firingTemp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PiecesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PiecesTable> {
  $$PiecesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get coverPhotoPath => $composableBuilder(
    column: $table.coverPhotoPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get clayBody =>
      $composableBuilder(column: $table.clayBody, builder: (column) => column);

  GeneratedColumn<String> get firingTemp => $composableBuilder(
    column: $table.firingTemp,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> stagesRefs<T extends Object>(
    Expression<T> Function($$StagesTableAnnotationComposer a) f,
  ) {
    final $$StagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stages,
      getReferencedColumn: (t) => t.pieceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StagesTableAnnotationComposer(
            $db: $db,
            $table: $db.stages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> pieceGlazesRefs<T extends Object>(
    Expression<T> Function($$PieceGlazesTableAnnotationComposer a) f,
  ) {
    final $$PieceGlazesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pieceGlazes,
      getReferencedColumn: (t) => t.pieceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PieceGlazesTableAnnotationComposer(
            $db: $db,
            $table: $db.pieceGlazes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PiecesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PiecesTable,
          Piece,
          $$PiecesTableFilterComposer,
          $$PiecesTableOrderingComposer,
          $$PiecesTableAnnotationComposer,
          $$PiecesTableCreateCompanionBuilder,
          $$PiecesTableUpdateCompanionBuilder,
          (Piece, $$PiecesTableReferences),
          Piece,
          PrefetchHooks Function({bool stagesRefs, bool pieceGlazesRefs})
        > {
  $$PiecesTableTableManager(_$AppDatabase db, $PiecesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PiecesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PiecesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PiecesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> coverPhotoPath = const Value.absent(),
                Value<String?> clayBody = const Value.absent(),
                Value<String?> firingTemp = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PiecesCompanion(
                id: id,
                title: title,
                description: description,
                coverPhotoPath: coverPhotoPath,
                clayBody: clayBody,
                firingTemp: firingTemp,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                Value<String?> description = const Value.absent(),
                Value<String?> coverPhotoPath = const Value.absent(),
                Value<String?> clayBody = const Value.absent(),
                Value<String?> firingTemp = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => PiecesCompanion.insert(
                id: id,
                title: title,
                description: description,
                coverPhotoPath: coverPhotoPath,
                clayBody: clayBody,
                firingTemp: firingTemp,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$PiecesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({stagesRefs = false, pieceGlazesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (stagesRefs) db.stages,
                    if (pieceGlazesRefs) db.pieceGlazes,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (stagesRefs)
                        await $_getPrefetchedData<Piece, $PiecesTable, Stage>(
                          currentTable: table,
                          referencedTable: $$PiecesTableReferences
                              ._stagesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PiecesTableReferences(db, table, p0).stagesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.pieceId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (pieceGlazesRefs)
                        await $_getPrefetchedData<
                          Piece,
                          $PiecesTable,
                          PieceGlaze
                        >(
                          currentTable: table,
                          referencedTable: $$PiecesTableReferences
                              ._pieceGlazesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PiecesTableReferences(
                                db,
                                table,
                                p0,
                              ).pieceGlazesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.pieceId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PiecesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PiecesTable,
      Piece,
      $$PiecesTableFilterComposer,
      $$PiecesTableOrderingComposer,
      $$PiecesTableAnnotationComposer,
      $$PiecesTableCreateCompanionBuilder,
      $$PiecesTableUpdateCompanionBuilder,
      (Piece, $$PiecesTableReferences),
      Piece,
      PrefetchHooks Function({bool stagesRefs, bool pieceGlazesRefs})
    >;
typedef $$StagesTableCreateCompanionBuilder =
    StagesCompanion Function({
      Value<int> id,
      required int pieceId,
      required String stageType,
      Value<String?> title,
      Value<String?> description,
      Value<String> status,
      Value<String?> failureReason,
      Value<DateTime?> finishedAt,
      Value<DateTime?> completedAt,
      required DateTime recordedAt,
    });
typedef $$StagesTableUpdateCompanionBuilder =
    StagesCompanion Function({
      Value<int> id,
      Value<int> pieceId,
      Value<String> stageType,
      Value<String?> title,
      Value<String?> description,
      Value<String> status,
      Value<String?> failureReason,
      Value<DateTime?> finishedAt,
      Value<DateTime?> completedAt,
      Value<DateTime> recordedAt,
    });

final class $$StagesTableReferences
    extends BaseReferences<_$AppDatabase, $StagesTable, Stage> {
  $$StagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PiecesTable _pieceIdTable(_$AppDatabase db) => db.pieces.createAlias(
    $_aliasNameGenerator(db.stages.pieceId, db.pieces.id),
  );

  $$PiecesTableProcessedTableManager get pieceId {
    final $_column = $_itemColumn<int>('piece_id')!;

    final manager = $$PiecesTableTableManager(
      $_db,
      $_db.pieces,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_pieceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PhotosTable, List<Photo>> _photosRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.photos,
    aliasName: $_aliasNameGenerator(db.stages.id, db.photos.stageId),
  );

  $$PhotosTableProcessedTableManager get photosRefs {
    final manager = $$PhotosTableTableManager(
      $_db,
      $_db.photos,
    ).filter((f) => f.stageId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_photosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$StagesTableFilterComposer
    extends Composer<_$AppDatabase, $StagesTable> {
  $$StagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stageType => $composableBuilder(
    column: $table.stageType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get failureReason => $composableBuilder(
    column: $table.failureReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PiecesTableFilterComposer get pieceId {
    final $$PiecesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pieceId,
      referencedTable: $db.pieces,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PiecesTableFilterComposer(
            $db: $db,
            $table: $db.pieces,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> photosRefs(
    Expression<bool> Function($$PhotosTableFilterComposer f) f,
  ) {
    final $$PhotosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.photos,
      getReferencedColumn: (t) => t.stageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PhotosTableFilterComposer(
            $db: $db,
            $table: $db.photos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StagesTableOrderingComposer
    extends Composer<_$AppDatabase, $StagesTable> {
  $$StagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stageType => $composableBuilder(
    column: $table.stageType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get failureReason => $composableBuilder(
    column: $table.failureReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PiecesTableOrderingComposer get pieceId {
    final $$PiecesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pieceId,
      referencedTable: $db.pieces,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PiecesTableOrderingComposer(
            $db: $db,
            $table: $db.pieces,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StagesTable> {
  $$StagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get stageType =>
      $composableBuilder(column: $table.stageType, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get failureReason => $composableBuilder(
    column: $table.failureReason,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );

  $$PiecesTableAnnotationComposer get pieceId {
    final $$PiecesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pieceId,
      referencedTable: $db.pieces,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PiecesTableAnnotationComposer(
            $db: $db,
            $table: $db.pieces,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> photosRefs<T extends Object>(
    Expression<T> Function($$PhotosTableAnnotationComposer a) f,
  ) {
    final $$PhotosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.photos,
      getReferencedColumn: (t) => t.stageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PhotosTableAnnotationComposer(
            $db: $db,
            $table: $db.photos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StagesTable,
          Stage,
          $$StagesTableFilterComposer,
          $$StagesTableOrderingComposer,
          $$StagesTableAnnotationComposer,
          $$StagesTableCreateCompanionBuilder,
          $$StagesTableUpdateCompanionBuilder,
          (Stage, $$StagesTableReferences),
          Stage,
          PrefetchHooks Function({bool pieceId, bool photosRefs})
        > {
  $$StagesTableTableManager(_$AppDatabase db, $StagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> pieceId = const Value.absent(),
                Value<String> stageType = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> failureReason = const Value.absent(),
                Value<DateTime?> finishedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime> recordedAt = const Value.absent(),
              }) => StagesCompanion(
                id: id,
                pieceId: pieceId,
                stageType: stageType,
                title: title,
                description: description,
                status: status,
                failureReason: failureReason,
                finishedAt: finishedAt,
                completedAt: completedAt,
                recordedAt: recordedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int pieceId,
                required String stageType,
                Value<String?> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> failureReason = const Value.absent(),
                Value<DateTime?> finishedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                required DateTime recordedAt,
              }) => StagesCompanion.insert(
                id: id,
                pieceId: pieceId,
                stageType: stageType,
                title: title,
                description: description,
                status: status,
                failureReason: failureReason,
                finishedAt: finishedAt,
                completedAt: completedAt,
                recordedAt: recordedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$StagesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({pieceId = false, photosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (photosRefs) db.photos],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (pieceId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.pieceId,
                                referencedTable: $$StagesTableReferences
                                    ._pieceIdTable(db),
                                referencedColumn: $$StagesTableReferences
                                    ._pieceIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (photosRefs)
                    await $_getPrefetchedData<Stage, $StagesTable, Photo>(
                      currentTable: table,
                      referencedTable: $$StagesTableReferences._photosRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$StagesTableReferences(db, table, p0).photosRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.stageId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$StagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StagesTable,
      Stage,
      $$StagesTableFilterComposer,
      $$StagesTableOrderingComposer,
      $$StagesTableAnnotationComposer,
      $$StagesTableCreateCompanionBuilder,
      $$StagesTableUpdateCompanionBuilder,
      (Stage, $$StagesTableReferences),
      Stage,
      PrefetchHooks Function({bool pieceId, bool photosRefs})
    >;
typedef $$PhotosTableCreateCompanionBuilder =
    PhotosCompanion Function({
      Value<int> id,
      required int stageId,
      required String localPath,
      Value<String?> caption,
      required DateTime recordedAt,
    });
typedef $$PhotosTableUpdateCompanionBuilder =
    PhotosCompanion Function({
      Value<int> id,
      Value<int> stageId,
      Value<String> localPath,
      Value<String?> caption,
      Value<DateTime> recordedAt,
    });

final class $$PhotosTableReferences
    extends BaseReferences<_$AppDatabase, $PhotosTable, Photo> {
  $$PhotosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $StagesTable _stageIdTable(_$AppDatabase db) => db.stages.createAlias(
    $_aliasNameGenerator(db.photos.stageId, db.stages.id),
  );

  $$StagesTableProcessedTableManager get stageId {
    final $_column = $_itemColumn<int>('stage_id')!;

    final manager = $$StagesTableTableManager(
      $_db,
      $_db.stages,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_stageIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PhotosTableFilterComposer
    extends Composer<_$AppDatabase, $PhotosTable> {
  $$PhotosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$StagesTableFilterComposer get stageId {
    final $$StagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stageId,
      referencedTable: $db.stages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StagesTableFilterComposer(
            $db: $db,
            $table: $db.stages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PhotosTableOrderingComposer
    extends Composer<_$AppDatabase, $PhotosTable> {
  $$PhotosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$StagesTableOrderingComposer get stageId {
    final $$StagesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stageId,
      referencedTable: $db.stages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StagesTableOrderingComposer(
            $db: $db,
            $table: $db.stages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PhotosTableAnnotationComposer
    extends Composer<_$AppDatabase, $PhotosTable> {
  $$PhotosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<String> get caption =>
      $composableBuilder(column: $table.caption, builder: (column) => column);

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );

  $$StagesTableAnnotationComposer get stageId {
    final $$StagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stageId,
      referencedTable: $db.stages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StagesTableAnnotationComposer(
            $db: $db,
            $table: $db.stages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PhotosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PhotosTable,
          Photo,
          $$PhotosTableFilterComposer,
          $$PhotosTableOrderingComposer,
          $$PhotosTableAnnotationComposer,
          $$PhotosTableCreateCompanionBuilder,
          $$PhotosTableUpdateCompanionBuilder,
          (Photo, $$PhotosTableReferences),
          Photo,
          PrefetchHooks Function({bool stageId})
        > {
  $$PhotosTableTableManager(_$AppDatabase db, $PhotosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PhotosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PhotosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PhotosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> stageId = const Value.absent(),
                Value<String> localPath = const Value.absent(),
                Value<String?> caption = const Value.absent(),
                Value<DateTime> recordedAt = const Value.absent(),
              }) => PhotosCompanion(
                id: id,
                stageId: stageId,
                localPath: localPath,
                caption: caption,
                recordedAt: recordedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int stageId,
                required String localPath,
                Value<String?> caption = const Value.absent(),
                required DateTime recordedAt,
              }) => PhotosCompanion.insert(
                id: id,
                stageId: stageId,
                localPath: localPath,
                caption: caption,
                recordedAt: recordedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$PhotosTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({stageId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (stageId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.stageId,
                                referencedTable: $$PhotosTableReferences
                                    ._stageIdTable(db),
                                referencedColumn: $$PhotosTableReferences
                                    ._stageIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PhotosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PhotosTable,
      Photo,
      $$PhotosTableFilterComposer,
      $$PhotosTableOrderingComposer,
      $$PhotosTableAnnotationComposer,
      $$PhotosTableCreateCompanionBuilder,
      $$PhotosTableUpdateCompanionBuilder,
      (Photo, $$PhotosTableReferences),
      Photo,
      PrefetchHooks Function({bool stageId})
    >;
typedef $$PieceGlazesTableCreateCompanionBuilder =
    PieceGlazesCompanion Function({
      required int pieceId,
      required String glazeName,
      Value<int> rowid,
    });
typedef $$PieceGlazesTableUpdateCompanionBuilder =
    PieceGlazesCompanion Function({
      Value<int> pieceId,
      Value<String> glazeName,
      Value<int> rowid,
    });

final class $$PieceGlazesTableReferences
    extends BaseReferences<_$AppDatabase, $PieceGlazesTable, PieceGlaze> {
  $$PieceGlazesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PiecesTable _pieceIdTable(_$AppDatabase db) => db.pieces.createAlias(
    $_aliasNameGenerator(db.pieceGlazes.pieceId, db.pieces.id),
  );

  $$PiecesTableProcessedTableManager get pieceId {
    final $_column = $_itemColumn<int>('piece_id')!;

    final manager = $$PiecesTableTableManager(
      $_db,
      $_db.pieces,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_pieceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PieceGlazesTableFilterComposer
    extends Composer<_$AppDatabase, $PieceGlazesTable> {
  $$PieceGlazesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get glazeName => $composableBuilder(
    column: $table.glazeName,
    builder: (column) => ColumnFilters(column),
  );

  $$PiecesTableFilterComposer get pieceId {
    final $$PiecesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pieceId,
      referencedTable: $db.pieces,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PiecesTableFilterComposer(
            $db: $db,
            $table: $db.pieces,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PieceGlazesTableOrderingComposer
    extends Composer<_$AppDatabase, $PieceGlazesTable> {
  $$PieceGlazesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get glazeName => $composableBuilder(
    column: $table.glazeName,
    builder: (column) => ColumnOrderings(column),
  );

  $$PiecesTableOrderingComposer get pieceId {
    final $$PiecesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pieceId,
      referencedTable: $db.pieces,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PiecesTableOrderingComposer(
            $db: $db,
            $table: $db.pieces,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PieceGlazesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PieceGlazesTable> {
  $$PieceGlazesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get glazeName =>
      $composableBuilder(column: $table.glazeName, builder: (column) => column);

  $$PiecesTableAnnotationComposer get pieceId {
    final $$PiecesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pieceId,
      referencedTable: $db.pieces,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PiecesTableAnnotationComposer(
            $db: $db,
            $table: $db.pieces,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PieceGlazesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PieceGlazesTable,
          PieceGlaze,
          $$PieceGlazesTableFilterComposer,
          $$PieceGlazesTableOrderingComposer,
          $$PieceGlazesTableAnnotationComposer,
          $$PieceGlazesTableCreateCompanionBuilder,
          $$PieceGlazesTableUpdateCompanionBuilder,
          (PieceGlaze, $$PieceGlazesTableReferences),
          PieceGlaze,
          PrefetchHooks Function({bool pieceId})
        > {
  $$PieceGlazesTableTableManager(_$AppDatabase db, $PieceGlazesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PieceGlazesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PieceGlazesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PieceGlazesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> pieceId = const Value.absent(),
                Value<String> glazeName = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PieceGlazesCompanion(
                pieceId: pieceId,
                glazeName: glazeName,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int pieceId,
                required String glazeName,
                Value<int> rowid = const Value.absent(),
              }) => PieceGlazesCompanion.insert(
                pieceId: pieceId,
                glazeName: glazeName,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PieceGlazesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({pieceId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (pieceId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.pieceId,
                                referencedTable: $$PieceGlazesTableReferences
                                    ._pieceIdTable(db),
                                referencedColumn: $$PieceGlazesTableReferences
                                    ._pieceIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PieceGlazesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PieceGlazesTable,
      PieceGlaze,
      $$PieceGlazesTableFilterComposer,
      $$PieceGlazesTableOrderingComposer,
      $$PieceGlazesTableAnnotationComposer,
      $$PieceGlazesTableCreateCompanionBuilder,
      $$PieceGlazesTableUpdateCompanionBuilder,
      (PieceGlaze, $$PieceGlazesTableReferences),
      PieceGlaze,
      PrefetchHooks Function({bool pieceId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PiecesTableTableManager get pieces =>
      $$PiecesTableTableManager(_db, _db.pieces);
  $$StagesTableTableManager get stages =>
      $$StagesTableTableManager(_db, _db.stages);
  $$PhotosTableTableManager get photos =>
      $$PhotosTableTableManager(_db, _db.photos);
  $$PieceGlazesTableTableManager get pieceGlazes =>
      $$PieceGlazesTableTableManager(_db, _db.pieceGlazes);
}
