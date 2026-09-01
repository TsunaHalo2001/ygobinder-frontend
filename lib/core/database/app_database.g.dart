// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CardsTable extends Cards with TableInfo<$CardsTable, DriftCard> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descMeta = const VerificationMeta('desc');
  @override
  late final GeneratedColumn<String> desc = GeneratedColumn<String>(
    'desc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _raceMeta = const VerificationMeta('race');
  @override
  late final GeneratedColumn<String> race = GeneratedColumn<String>(
    'race',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _frameTypeMeta = const VerificationMeta(
    'frameType',
  );
  @override
  late final GeneratedColumn<String> frameType = GeneratedColumn<String>(
    'frame_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _humanReadableCardTypeMeta =
      const VerificationMeta('humanReadableCardType');
  @override
  late final GeneratedColumn<String> humanReadableCardType =
      GeneratedColumn<String>(
        'human_readable_card_type',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _atkMeta = const VerificationMeta('atk');
  @override
  late final GeneratedColumn<int> atk = GeneratedColumn<int>(
    'atk',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _defMeta = const VerificationMeta('def');
  @override
  late final GeneratedColumn<int> def = GeneratedColumn<int>(
    'def',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
    'level',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _attributeMeta = const VerificationMeta(
    'attribute',
  );
  @override
  late final GeneratedColumn<String> attribute = GeneratedColumn<String>(
    'attribute',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _archetypeMeta = const VerificationMeta(
    'archetype',
  );
  @override
  late final GeneratedColumn<String> archetype = GeneratedColumn<String>(
    'archetype',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _scaleMeta = const VerificationMeta('scale');
  @override
  late final GeneratedColumn<int> scale = GeneratedColumn<int>(
    'scale',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _linkValMeta = const VerificationMeta(
    'linkVal',
  );
  @override
  late final GeneratedColumn<int> linkVal = GeneratedColumn<int>(
    'link_val',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ygoProDeckUrlMeta = const VerificationMeta(
    'ygoProDeckUrl',
  );
  @override
  late final GeneratedColumn<String> ygoProDeckUrl = GeneratedColumn<String>(
    'ygo_pro_deck_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pendDescMeta = const VerificationMeta(
    'pendDesc',
  );
  @override
  late final GeneratedColumn<String> pendDesc = GeneratedColumn<String>(
    'pend_desc',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _monsterDescMeta = const VerificationMeta(
    'monsterDesc',
  );
  @override
  late final GeneratedColumn<String> monsterDesc = GeneratedColumn<String>(
    'monster_desc',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeLineJsonMeta = const VerificationMeta(
    'typeLineJson',
  );
  @override
  late final GeneratedColumn<String> typeLineJson = GeneratedColumn<String>(
    'type_line_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _linkMarkersJsonMeta = const VerificationMeta(
    'linkMarkersJson',
  );
  @override
  late final GeneratedColumn<String> linkMarkersJson = GeneratedColumn<String>(
    'link_markers_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tcgDateMeta = const VerificationMeta(
    'tcgDate',
  );
  @override
  late final GeneratedColumn<DateTime> tcgDate = GeneratedColumn<DateTime>(
    'tcg_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ocgDateMeta = const VerificationMeta(
    'ocgDate',
  );
  @override
  late final GeneratedColumn<DateTime> ocgDate = GeneratedColumn<DateTime>(
    'ocg_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    type,
    desc,
    race,
    frameType,
    humanReadableCardType,
    atk,
    def,
    level,
    attribute,
    archetype,
    scale,
    linkVal,
    ygoProDeckUrl,
    pendDesc,
    monsterDesc,
    typeLineJson,
    linkMarkersJson,
    tcgDate,
    ocgDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cards';
  @override
  VerificationContext validateIntegrity(
    Insertable<DriftCard> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('desc')) {
      context.handle(
        _descMeta,
        desc.isAcceptableOrUnknown(data['desc']!, _descMeta),
      );
    } else if (isInserting) {
      context.missing(_descMeta);
    }
    if (data.containsKey('race')) {
      context.handle(
        _raceMeta,
        race.isAcceptableOrUnknown(data['race']!, _raceMeta),
      );
    } else if (isInserting) {
      context.missing(_raceMeta);
    }
    if (data.containsKey('frame_type')) {
      context.handle(
        _frameTypeMeta,
        frameType.isAcceptableOrUnknown(data['frame_type']!, _frameTypeMeta),
      );
    }
    if (data.containsKey('human_readable_card_type')) {
      context.handle(
        _humanReadableCardTypeMeta,
        humanReadableCardType.isAcceptableOrUnknown(
          data['human_readable_card_type']!,
          _humanReadableCardTypeMeta,
        ),
      );
    }
    if (data.containsKey('atk')) {
      context.handle(
        _atkMeta,
        atk.isAcceptableOrUnknown(data['atk']!, _atkMeta),
      );
    }
    if (data.containsKey('def')) {
      context.handle(
        _defMeta,
        def.isAcceptableOrUnknown(data['def']!, _defMeta),
      );
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    }
    if (data.containsKey('attribute')) {
      context.handle(
        _attributeMeta,
        attribute.isAcceptableOrUnknown(data['attribute']!, _attributeMeta),
      );
    }
    if (data.containsKey('archetype')) {
      context.handle(
        _archetypeMeta,
        archetype.isAcceptableOrUnknown(data['archetype']!, _archetypeMeta),
      );
    }
    if (data.containsKey('scale')) {
      context.handle(
        _scaleMeta,
        scale.isAcceptableOrUnknown(data['scale']!, _scaleMeta),
      );
    }
    if (data.containsKey('link_val')) {
      context.handle(
        _linkValMeta,
        linkVal.isAcceptableOrUnknown(data['link_val']!, _linkValMeta),
      );
    }
    if (data.containsKey('ygo_pro_deck_url')) {
      context.handle(
        _ygoProDeckUrlMeta,
        ygoProDeckUrl.isAcceptableOrUnknown(
          data['ygo_pro_deck_url']!,
          _ygoProDeckUrlMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ygoProDeckUrlMeta);
    }
    if (data.containsKey('pend_desc')) {
      context.handle(
        _pendDescMeta,
        pendDesc.isAcceptableOrUnknown(data['pend_desc']!, _pendDescMeta),
      );
    }
    if (data.containsKey('monster_desc')) {
      context.handle(
        _monsterDescMeta,
        monsterDesc.isAcceptableOrUnknown(
          data['monster_desc']!,
          _monsterDescMeta,
        ),
      );
    }
    if (data.containsKey('type_line_json')) {
      context.handle(
        _typeLineJsonMeta,
        typeLineJson.isAcceptableOrUnknown(
          data['type_line_json']!,
          _typeLineJsonMeta,
        ),
      );
    }
    if (data.containsKey('link_markers_json')) {
      context.handle(
        _linkMarkersJsonMeta,
        linkMarkersJson.isAcceptableOrUnknown(
          data['link_markers_json']!,
          _linkMarkersJsonMeta,
        ),
      );
    }
    if (data.containsKey('tcg_date')) {
      context.handle(
        _tcgDateMeta,
        tcgDate.isAcceptableOrUnknown(data['tcg_date']!, _tcgDateMeta),
      );
    }
    if (data.containsKey('ocg_date')) {
      context.handle(
        _ocgDateMeta,
        ocgDate.isAcceptableOrUnknown(data['ocg_date']!, _ocgDateMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriftCard map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftCard(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      desc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}desc'],
      )!,
      race: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}race'],
      )!,
      frameType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frame_type'],
      ),
      humanReadableCardType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}human_readable_card_type'],
      ),
      atk: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}atk'],
      ),
      def: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}def'],
      ),
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level'],
      ),
      attribute: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attribute'],
      ),
      archetype: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}archetype'],
      ),
      scale: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}scale'],
      ),
      linkVal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}link_val'],
      ),
      ygoProDeckUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ygo_pro_deck_url'],
      )!,
      pendDesc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pend_desc'],
      ),
      monsterDesc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}monster_desc'],
      ),
      typeLineJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type_line_json'],
      ),
      linkMarkersJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}link_markers_json'],
      ),
      tcgDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}tcg_date'],
      ),
      ocgDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ocg_date'],
      ),
    );
  }

  @override
  $CardsTable createAlias(String alias) {
    return $CardsTable(attachedDatabase, alias);
  }
}

class DriftCard extends DataClass implements Insertable<DriftCard> {
  final int id;
  final String name;
  final String type;
  final String desc;
  final String race;
  final String? frameType;
  final String? humanReadableCardType;
  final int? atk;
  final int? def;
  final int? level;
  final String? attribute;
  final String? archetype;
  final int? scale;
  final int? linkVal;
  final String ygoProDeckUrl;
  final String? pendDesc;
  final String? monsterDesc;
  final String? typeLineJson;
  final String? linkMarkersJson;
  final DateTime? tcgDate;
  final DateTime? ocgDate;
  const DriftCard({
    required this.id,
    required this.name,
    required this.type,
    required this.desc,
    required this.race,
    this.frameType,
    this.humanReadableCardType,
    this.atk,
    this.def,
    this.level,
    this.attribute,
    this.archetype,
    this.scale,
    this.linkVal,
    required this.ygoProDeckUrl,
    this.pendDesc,
    this.monsterDesc,
    this.typeLineJson,
    this.linkMarkersJson,
    this.tcgDate,
    this.ocgDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['desc'] = Variable<String>(desc);
    map['race'] = Variable<String>(race);
    if (!nullToAbsent || frameType != null) {
      map['frame_type'] = Variable<String>(frameType);
    }
    if (!nullToAbsent || humanReadableCardType != null) {
      map['human_readable_card_type'] = Variable<String>(humanReadableCardType);
    }
    if (!nullToAbsent || atk != null) {
      map['atk'] = Variable<int>(atk);
    }
    if (!nullToAbsent || def != null) {
      map['def'] = Variable<int>(def);
    }
    if (!nullToAbsent || level != null) {
      map['level'] = Variable<int>(level);
    }
    if (!nullToAbsent || attribute != null) {
      map['attribute'] = Variable<String>(attribute);
    }
    if (!nullToAbsent || archetype != null) {
      map['archetype'] = Variable<String>(archetype);
    }
    if (!nullToAbsent || scale != null) {
      map['scale'] = Variable<int>(scale);
    }
    if (!nullToAbsent || linkVal != null) {
      map['link_val'] = Variable<int>(linkVal);
    }
    map['ygo_pro_deck_url'] = Variable<String>(ygoProDeckUrl);
    if (!nullToAbsent || pendDesc != null) {
      map['pend_desc'] = Variable<String>(pendDesc);
    }
    if (!nullToAbsent || monsterDesc != null) {
      map['monster_desc'] = Variable<String>(monsterDesc);
    }
    if (!nullToAbsent || typeLineJson != null) {
      map['type_line_json'] = Variable<String>(typeLineJson);
    }
    if (!nullToAbsent || linkMarkersJson != null) {
      map['link_markers_json'] = Variable<String>(linkMarkersJson);
    }
    if (!nullToAbsent || tcgDate != null) {
      map['tcg_date'] = Variable<DateTime>(tcgDate);
    }
    if (!nullToAbsent || ocgDate != null) {
      map['ocg_date'] = Variable<DateTime>(ocgDate);
    }
    return map;
  }

  CardsCompanion toCompanion(bool nullToAbsent) {
    return CardsCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      desc: Value(desc),
      race: Value(race),
      frameType: frameType == null && nullToAbsent
          ? const Value.absent()
          : Value(frameType),
      humanReadableCardType: humanReadableCardType == null && nullToAbsent
          ? const Value.absent()
          : Value(humanReadableCardType),
      atk: atk == null && nullToAbsent ? const Value.absent() : Value(atk),
      def: def == null && nullToAbsent ? const Value.absent() : Value(def),
      level: level == null && nullToAbsent
          ? const Value.absent()
          : Value(level),
      attribute: attribute == null && nullToAbsent
          ? const Value.absent()
          : Value(attribute),
      archetype: archetype == null && nullToAbsent
          ? const Value.absent()
          : Value(archetype),
      scale: scale == null && nullToAbsent
          ? const Value.absent()
          : Value(scale),
      linkVal: linkVal == null && nullToAbsent
          ? const Value.absent()
          : Value(linkVal),
      ygoProDeckUrl: Value(ygoProDeckUrl),
      pendDesc: pendDesc == null && nullToAbsent
          ? const Value.absent()
          : Value(pendDesc),
      monsterDesc: monsterDesc == null && nullToAbsent
          ? const Value.absent()
          : Value(monsterDesc),
      typeLineJson: typeLineJson == null && nullToAbsent
          ? const Value.absent()
          : Value(typeLineJson),
      linkMarkersJson: linkMarkersJson == null && nullToAbsent
          ? const Value.absent()
          : Value(linkMarkersJson),
      tcgDate: tcgDate == null && nullToAbsent
          ? const Value.absent()
          : Value(tcgDate),
      ocgDate: ocgDate == null && nullToAbsent
          ? const Value.absent()
          : Value(ocgDate),
    );
  }

  factory DriftCard.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftCard(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      desc: serializer.fromJson<String>(json['desc']),
      race: serializer.fromJson<String>(json['race']),
      frameType: serializer.fromJson<String?>(json['frameType']),
      humanReadableCardType: serializer.fromJson<String?>(
        json['humanReadableCardType'],
      ),
      atk: serializer.fromJson<int?>(json['atk']),
      def: serializer.fromJson<int?>(json['def']),
      level: serializer.fromJson<int?>(json['level']),
      attribute: serializer.fromJson<String?>(json['attribute']),
      archetype: serializer.fromJson<String?>(json['archetype']),
      scale: serializer.fromJson<int?>(json['scale']),
      linkVal: serializer.fromJson<int?>(json['linkVal']),
      ygoProDeckUrl: serializer.fromJson<String>(json['ygoProDeckUrl']),
      pendDesc: serializer.fromJson<String?>(json['pendDesc']),
      monsterDesc: serializer.fromJson<String?>(json['monsterDesc']),
      typeLineJson: serializer.fromJson<String?>(json['typeLineJson']),
      linkMarkersJson: serializer.fromJson<String?>(json['linkMarkersJson']),
      tcgDate: serializer.fromJson<DateTime?>(json['tcgDate']),
      ocgDate: serializer.fromJson<DateTime?>(json['ocgDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'desc': serializer.toJson<String>(desc),
      'race': serializer.toJson<String>(race),
      'frameType': serializer.toJson<String?>(frameType),
      'humanReadableCardType': serializer.toJson<String?>(
        humanReadableCardType,
      ),
      'atk': serializer.toJson<int?>(atk),
      'def': serializer.toJson<int?>(def),
      'level': serializer.toJson<int?>(level),
      'attribute': serializer.toJson<String?>(attribute),
      'archetype': serializer.toJson<String?>(archetype),
      'scale': serializer.toJson<int?>(scale),
      'linkVal': serializer.toJson<int?>(linkVal),
      'ygoProDeckUrl': serializer.toJson<String>(ygoProDeckUrl),
      'pendDesc': serializer.toJson<String?>(pendDesc),
      'monsterDesc': serializer.toJson<String?>(monsterDesc),
      'typeLineJson': serializer.toJson<String?>(typeLineJson),
      'linkMarkersJson': serializer.toJson<String?>(linkMarkersJson),
      'tcgDate': serializer.toJson<DateTime?>(tcgDate),
      'ocgDate': serializer.toJson<DateTime?>(ocgDate),
    };
  }

  DriftCard copyWith({
    int? id,
    String? name,
    String? type,
    String? desc,
    String? race,
    Value<String?> frameType = const Value.absent(),
    Value<String?> humanReadableCardType = const Value.absent(),
    Value<int?> atk = const Value.absent(),
    Value<int?> def = const Value.absent(),
    Value<int?> level = const Value.absent(),
    Value<String?> attribute = const Value.absent(),
    Value<String?> archetype = const Value.absent(),
    Value<int?> scale = const Value.absent(),
    Value<int?> linkVal = const Value.absent(),
    String? ygoProDeckUrl,
    Value<String?> pendDesc = const Value.absent(),
    Value<String?> monsterDesc = const Value.absent(),
    Value<String?> typeLineJson = const Value.absent(),
    Value<String?> linkMarkersJson = const Value.absent(),
    Value<DateTime?> tcgDate = const Value.absent(),
    Value<DateTime?> ocgDate = const Value.absent(),
  }) => DriftCard(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    desc: desc ?? this.desc,
    race: race ?? this.race,
    frameType: frameType.present ? frameType.value : this.frameType,
    humanReadableCardType: humanReadableCardType.present
        ? humanReadableCardType.value
        : this.humanReadableCardType,
    atk: atk.present ? atk.value : this.atk,
    def: def.present ? def.value : this.def,
    level: level.present ? level.value : this.level,
    attribute: attribute.present ? attribute.value : this.attribute,
    archetype: archetype.present ? archetype.value : this.archetype,
    scale: scale.present ? scale.value : this.scale,
    linkVal: linkVal.present ? linkVal.value : this.linkVal,
    ygoProDeckUrl: ygoProDeckUrl ?? this.ygoProDeckUrl,
    pendDesc: pendDesc.present ? pendDesc.value : this.pendDesc,
    monsterDesc: monsterDesc.present ? monsterDesc.value : this.monsterDesc,
    typeLineJson: typeLineJson.present ? typeLineJson.value : this.typeLineJson,
    linkMarkersJson: linkMarkersJson.present
        ? linkMarkersJson.value
        : this.linkMarkersJson,
    tcgDate: tcgDate.present ? tcgDate.value : this.tcgDate,
    ocgDate: ocgDate.present ? ocgDate.value : this.ocgDate,
  );
  DriftCard copyWithCompanion(CardsCompanion data) {
    return DriftCard(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      desc: data.desc.present ? data.desc.value : this.desc,
      race: data.race.present ? data.race.value : this.race,
      frameType: data.frameType.present ? data.frameType.value : this.frameType,
      humanReadableCardType: data.humanReadableCardType.present
          ? data.humanReadableCardType.value
          : this.humanReadableCardType,
      atk: data.atk.present ? data.atk.value : this.atk,
      def: data.def.present ? data.def.value : this.def,
      level: data.level.present ? data.level.value : this.level,
      attribute: data.attribute.present ? data.attribute.value : this.attribute,
      archetype: data.archetype.present ? data.archetype.value : this.archetype,
      scale: data.scale.present ? data.scale.value : this.scale,
      linkVal: data.linkVal.present ? data.linkVal.value : this.linkVal,
      ygoProDeckUrl: data.ygoProDeckUrl.present
          ? data.ygoProDeckUrl.value
          : this.ygoProDeckUrl,
      pendDesc: data.pendDesc.present ? data.pendDesc.value : this.pendDesc,
      monsterDesc: data.monsterDesc.present
          ? data.monsterDesc.value
          : this.monsterDesc,
      typeLineJson: data.typeLineJson.present
          ? data.typeLineJson.value
          : this.typeLineJson,
      linkMarkersJson: data.linkMarkersJson.present
          ? data.linkMarkersJson.value
          : this.linkMarkersJson,
      tcgDate: data.tcgDate.present ? data.tcgDate.value : this.tcgDate,
      ocgDate: data.ocgDate.present ? data.ocgDate.value : this.ocgDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriftCard(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('desc: $desc, ')
          ..write('race: $race, ')
          ..write('frameType: $frameType, ')
          ..write('humanReadableCardType: $humanReadableCardType, ')
          ..write('atk: $atk, ')
          ..write('def: $def, ')
          ..write('level: $level, ')
          ..write('attribute: $attribute, ')
          ..write('archetype: $archetype, ')
          ..write('scale: $scale, ')
          ..write('linkVal: $linkVal, ')
          ..write('ygoProDeckUrl: $ygoProDeckUrl, ')
          ..write('pendDesc: $pendDesc, ')
          ..write('monsterDesc: $monsterDesc, ')
          ..write('typeLineJson: $typeLineJson, ')
          ..write('linkMarkersJson: $linkMarkersJson, ')
          ..write('tcgDate: $tcgDate, ')
          ..write('ocgDate: $ocgDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    name,
    type,
    desc,
    race,
    frameType,
    humanReadableCardType,
    atk,
    def,
    level,
    attribute,
    archetype,
    scale,
    linkVal,
    ygoProDeckUrl,
    pendDesc,
    monsterDesc,
    typeLineJson,
    linkMarkersJson,
    tcgDate,
    ocgDate,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftCard &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.desc == this.desc &&
          other.race == this.race &&
          other.frameType == this.frameType &&
          other.humanReadableCardType == this.humanReadableCardType &&
          other.atk == this.atk &&
          other.def == this.def &&
          other.level == this.level &&
          other.attribute == this.attribute &&
          other.archetype == this.archetype &&
          other.scale == this.scale &&
          other.linkVal == this.linkVal &&
          other.ygoProDeckUrl == this.ygoProDeckUrl &&
          other.pendDesc == this.pendDesc &&
          other.monsterDesc == this.monsterDesc &&
          other.typeLineJson == this.typeLineJson &&
          other.linkMarkersJson == this.linkMarkersJson &&
          other.tcgDate == this.tcgDate &&
          other.ocgDate == this.ocgDate);
}

class CardsCompanion extends UpdateCompanion<DriftCard> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> type;
  final Value<String> desc;
  final Value<String> race;
  final Value<String?> frameType;
  final Value<String?> humanReadableCardType;
  final Value<int?> atk;
  final Value<int?> def;
  final Value<int?> level;
  final Value<String?> attribute;
  final Value<String?> archetype;
  final Value<int?> scale;
  final Value<int?> linkVal;
  final Value<String> ygoProDeckUrl;
  final Value<String?> pendDesc;
  final Value<String?> monsterDesc;
  final Value<String?> typeLineJson;
  final Value<String?> linkMarkersJson;
  final Value<DateTime?> tcgDate;
  final Value<DateTime?> ocgDate;
  const CardsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.desc = const Value.absent(),
    this.race = const Value.absent(),
    this.frameType = const Value.absent(),
    this.humanReadableCardType = const Value.absent(),
    this.atk = const Value.absent(),
    this.def = const Value.absent(),
    this.level = const Value.absent(),
    this.attribute = const Value.absent(),
    this.archetype = const Value.absent(),
    this.scale = const Value.absent(),
    this.linkVal = const Value.absent(),
    this.ygoProDeckUrl = const Value.absent(),
    this.pendDesc = const Value.absent(),
    this.monsterDesc = const Value.absent(),
    this.typeLineJson = const Value.absent(),
    this.linkMarkersJson = const Value.absent(),
    this.tcgDate = const Value.absent(),
    this.ocgDate = const Value.absent(),
  });
  CardsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String type,
    required String desc,
    required String race,
    this.frameType = const Value.absent(),
    this.humanReadableCardType = const Value.absent(),
    this.atk = const Value.absent(),
    this.def = const Value.absent(),
    this.level = const Value.absent(),
    this.attribute = const Value.absent(),
    this.archetype = const Value.absent(),
    this.scale = const Value.absent(),
    this.linkVal = const Value.absent(),
    required String ygoProDeckUrl,
    this.pendDesc = const Value.absent(),
    this.monsterDesc = const Value.absent(),
    this.typeLineJson = const Value.absent(),
    this.linkMarkersJson = const Value.absent(),
    this.tcgDate = const Value.absent(),
    this.ocgDate = const Value.absent(),
  }) : name = Value(name),
       type = Value(type),
       desc = Value(desc),
       race = Value(race),
       ygoProDeckUrl = Value(ygoProDeckUrl);
  static Insertable<DriftCard> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? desc,
    Expression<String>? race,
    Expression<String>? frameType,
    Expression<String>? humanReadableCardType,
    Expression<int>? atk,
    Expression<int>? def,
    Expression<int>? level,
    Expression<String>? attribute,
    Expression<String>? archetype,
    Expression<int>? scale,
    Expression<int>? linkVal,
    Expression<String>? ygoProDeckUrl,
    Expression<String>? pendDesc,
    Expression<String>? monsterDesc,
    Expression<String>? typeLineJson,
    Expression<String>? linkMarkersJson,
    Expression<DateTime>? tcgDate,
    Expression<DateTime>? ocgDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (desc != null) 'desc': desc,
      if (race != null) 'race': race,
      if (frameType != null) 'frame_type': frameType,
      if (humanReadableCardType != null)
        'human_readable_card_type': humanReadableCardType,
      if (atk != null) 'atk': atk,
      if (def != null) 'def': def,
      if (level != null) 'level': level,
      if (attribute != null) 'attribute': attribute,
      if (archetype != null) 'archetype': archetype,
      if (scale != null) 'scale': scale,
      if (linkVal != null) 'link_val': linkVal,
      if (ygoProDeckUrl != null) 'ygo_pro_deck_url': ygoProDeckUrl,
      if (pendDesc != null) 'pend_desc': pendDesc,
      if (monsterDesc != null) 'monster_desc': monsterDesc,
      if (typeLineJson != null) 'type_line_json': typeLineJson,
      if (linkMarkersJson != null) 'link_markers_json': linkMarkersJson,
      if (tcgDate != null) 'tcg_date': tcgDate,
      if (ocgDate != null) 'ocg_date': ocgDate,
    });
  }

  CardsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? type,
    Value<String>? desc,
    Value<String>? race,
    Value<String?>? frameType,
    Value<String?>? humanReadableCardType,
    Value<int?>? atk,
    Value<int?>? def,
    Value<int?>? level,
    Value<String?>? attribute,
    Value<String?>? archetype,
    Value<int?>? scale,
    Value<int?>? linkVal,
    Value<String>? ygoProDeckUrl,
    Value<String?>? pendDesc,
    Value<String?>? monsterDesc,
    Value<String?>? typeLineJson,
    Value<String?>? linkMarkersJson,
    Value<DateTime?>? tcgDate,
    Value<DateTime?>? ocgDate,
  }) {
    return CardsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      desc: desc ?? this.desc,
      race: race ?? this.race,
      frameType: frameType ?? this.frameType,
      humanReadableCardType:
          humanReadableCardType ?? this.humanReadableCardType,
      atk: atk ?? this.atk,
      def: def ?? this.def,
      level: level ?? this.level,
      attribute: attribute ?? this.attribute,
      archetype: archetype ?? this.archetype,
      scale: scale ?? this.scale,
      linkVal: linkVal ?? this.linkVal,
      ygoProDeckUrl: ygoProDeckUrl ?? this.ygoProDeckUrl,
      pendDesc: pendDesc ?? this.pendDesc,
      monsterDesc: monsterDesc ?? this.monsterDesc,
      typeLineJson: typeLineJson ?? this.typeLineJson,
      linkMarkersJson: linkMarkersJson ?? this.linkMarkersJson,
      tcgDate: tcgDate ?? this.tcgDate,
      ocgDate: ocgDate ?? this.ocgDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (desc.present) {
      map['desc'] = Variable<String>(desc.value);
    }
    if (race.present) {
      map['race'] = Variable<String>(race.value);
    }
    if (frameType.present) {
      map['frame_type'] = Variable<String>(frameType.value);
    }
    if (humanReadableCardType.present) {
      map['human_readable_card_type'] = Variable<String>(
        humanReadableCardType.value,
      );
    }
    if (atk.present) {
      map['atk'] = Variable<int>(atk.value);
    }
    if (def.present) {
      map['def'] = Variable<int>(def.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (attribute.present) {
      map['attribute'] = Variable<String>(attribute.value);
    }
    if (archetype.present) {
      map['archetype'] = Variable<String>(archetype.value);
    }
    if (scale.present) {
      map['scale'] = Variable<int>(scale.value);
    }
    if (linkVal.present) {
      map['link_val'] = Variable<int>(linkVal.value);
    }
    if (ygoProDeckUrl.present) {
      map['ygo_pro_deck_url'] = Variable<String>(ygoProDeckUrl.value);
    }
    if (pendDesc.present) {
      map['pend_desc'] = Variable<String>(pendDesc.value);
    }
    if (monsterDesc.present) {
      map['monster_desc'] = Variable<String>(monsterDesc.value);
    }
    if (typeLineJson.present) {
      map['type_line_json'] = Variable<String>(typeLineJson.value);
    }
    if (linkMarkersJson.present) {
      map['link_markers_json'] = Variable<String>(linkMarkersJson.value);
    }
    if (tcgDate.present) {
      map['tcg_date'] = Variable<DateTime>(tcgDate.value);
    }
    if (ocgDate.present) {
      map['ocg_date'] = Variable<DateTime>(ocgDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('desc: $desc, ')
          ..write('race: $race, ')
          ..write('frameType: $frameType, ')
          ..write('humanReadableCardType: $humanReadableCardType, ')
          ..write('atk: $atk, ')
          ..write('def: $def, ')
          ..write('level: $level, ')
          ..write('attribute: $attribute, ')
          ..write('archetype: $archetype, ')
          ..write('scale: $scale, ')
          ..write('linkVal: $linkVal, ')
          ..write('ygoProDeckUrl: $ygoProDeckUrl, ')
          ..write('pendDesc: $pendDesc, ')
          ..write('monsterDesc: $monsterDesc, ')
          ..write('typeLineJson: $typeLineJson, ')
          ..write('linkMarkersJson: $linkMarkersJson, ')
          ..write('tcgDate: $tcgDate, ')
          ..write('ocgDate: $ocgDate')
          ..write(')'))
        .toString();
  }
}

class $CardImagesTable extends CardImages
    with TableInfo<$CardImagesTable, DriftCardImage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardImagesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<int> cardId = GeneratedColumn<int>(
    'card_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cards (id)',
    ),
  );
  static const VerificationMeta _imageIdMeta = const VerificationMeta(
    'imageId',
  );
  @override
  late final GeneratedColumn<int> imageId = GeneratedColumn<int>(
    'image_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageUrlSmallMeta = const VerificationMeta(
    'imageUrlSmall',
  );
  @override
  late final GeneratedColumn<String> imageUrlSmall = GeneratedColumn<String>(
    'image_url_small',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageUrlCroppedMeta = const VerificationMeta(
    'imageUrlCropped',
  );
  @override
  late final GeneratedColumn<String> imageUrlCropped = GeneratedColumn<String>(
    'image_url_cropped',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cardId,
    imageId,
    imageUrl,
    imageUrlSmall,
    imageUrlCropped,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'card_images';
  @override
  VerificationContext validateIntegrity(
    Insertable<DriftCardImage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('card_id')) {
      context.handle(
        _cardIdMeta,
        cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('image_id')) {
      context.handle(
        _imageIdMeta,
        imageId.isAcceptableOrUnknown(data['image_id']!, _imageIdMeta),
      );
    } else if (isInserting) {
      context.missing(_imageIdMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_imageUrlMeta);
    }
    if (data.containsKey('image_url_small')) {
      context.handle(
        _imageUrlSmallMeta,
        imageUrlSmall.isAcceptableOrUnknown(
          data['image_url_small']!,
          _imageUrlSmallMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_imageUrlSmallMeta);
    }
    if (data.containsKey('image_url_cropped')) {
      context.handle(
        _imageUrlCroppedMeta,
        imageUrlCropped.isAcceptableOrUnknown(
          data['image_url_cropped']!,
          _imageUrlCroppedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_imageUrlCroppedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriftCardImage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftCardImage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cardId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}card_id'],
      )!,
      imageId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}image_id'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      )!,
      imageUrlSmall: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url_small'],
      )!,
      imageUrlCropped: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url_cropped'],
      )!,
    );
  }

  @override
  $CardImagesTable createAlias(String alias) {
    return $CardImagesTable(attachedDatabase, alias);
  }
}

class DriftCardImage extends DataClass implements Insertable<DriftCardImage> {
  final int id;
  final int cardId;
  final int imageId;
  final String imageUrl;
  final String imageUrlSmall;
  final String imageUrlCropped;
  const DriftCardImage({
    required this.id,
    required this.cardId,
    required this.imageId,
    required this.imageUrl,
    required this.imageUrlSmall,
    required this.imageUrlCropped,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['card_id'] = Variable<int>(cardId);
    map['image_id'] = Variable<int>(imageId);
    map['image_url'] = Variable<String>(imageUrl);
    map['image_url_small'] = Variable<String>(imageUrlSmall);
    map['image_url_cropped'] = Variable<String>(imageUrlCropped);
    return map;
  }

  CardImagesCompanion toCompanion(bool nullToAbsent) {
    return CardImagesCompanion(
      id: Value(id),
      cardId: Value(cardId),
      imageId: Value(imageId),
      imageUrl: Value(imageUrl),
      imageUrlSmall: Value(imageUrlSmall),
      imageUrlCropped: Value(imageUrlCropped),
    );
  }

  factory DriftCardImage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftCardImage(
      id: serializer.fromJson<int>(json['id']),
      cardId: serializer.fromJson<int>(json['cardId']),
      imageId: serializer.fromJson<int>(json['imageId']),
      imageUrl: serializer.fromJson<String>(json['imageUrl']),
      imageUrlSmall: serializer.fromJson<String>(json['imageUrlSmall']),
      imageUrlCropped: serializer.fromJson<String>(json['imageUrlCropped']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cardId': serializer.toJson<int>(cardId),
      'imageId': serializer.toJson<int>(imageId),
      'imageUrl': serializer.toJson<String>(imageUrl),
      'imageUrlSmall': serializer.toJson<String>(imageUrlSmall),
      'imageUrlCropped': serializer.toJson<String>(imageUrlCropped),
    };
  }

  DriftCardImage copyWith({
    int? id,
    int? cardId,
    int? imageId,
    String? imageUrl,
    String? imageUrlSmall,
    String? imageUrlCropped,
  }) => DriftCardImage(
    id: id ?? this.id,
    cardId: cardId ?? this.cardId,
    imageId: imageId ?? this.imageId,
    imageUrl: imageUrl ?? this.imageUrl,
    imageUrlSmall: imageUrlSmall ?? this.imageUrlSmall,
    imageUrlCropped: imageUrlCropped ?? this.imageUrlCropped,
  );
  DriftCardImage copyWithCompanion(CardImagesCompanion data) {
    return DriftCardImage(
      id: data.id.present ? data.id.value : this.id,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      imageId: data.imageId.present ? data.imageId.value : this.imageId,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      imageUrlSmall: data.imageUrlSmall.present
          ? data.imageUrlSmall.value
          : this.imageUrlSmall,
      imageUrlCropped: data.imageUrlCropped.present
          ? data.imageUrlCropped.value
          : this.imageUrlCropped,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriftCardImage(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('imageId: $imageId, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('imageUrlSmall: $imageUrlSmall, ')
          ..write('imageUrlCropped: $imageUrlCropped')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    cardId,
    imageId,
    imageUrl,
    imageUrlSmall,
    imageUrlCropped,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftCardImage &&
          other.id == this.id &&
          other.cardId == this.cardId &&
          other.imageId == this.imageId &&
          other.imageUrl == this.imageUrl &&
          other.imageUrlSmall == this.imageUrlSmall &&
          other.imageUrlCropped == this.imageUrlCropped);
}

class CardImagesCompanion extends UpdateCompanion<DriftCardImage> {
  final Value<int> id;
  final Value<int> cardId;
  final Value<int> imageId;
  final Value<String> imageUrl;
  final Value<String> imageUrlSmall;
  final Value<String> imageUrlCropped;
  const CardImagesCompanion({
    this.id = const Value.absent(),
    this.cardId = const Value.absent(),
    this.imageId = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.imageUrlSmall = const Value.absent(),
    this.imageUrlCropped = const Value.absent(),
  });
  CardImagesCompanion.insert({
    this.id = const Value.absent(),
    required int cardId,
    required int imageId,
    required String imageUrl,
    required String imageUrlSmall,
    required String imageUrlCropped,
  }) : cardId = Value(cardId),
       imageId = Value(imageId),
       imageUrl = Value(imageUrl),
       imageUrlSmall = Value(imageUrlSmall),
       imageUrlCropped = Value(imageUrlCropped);
  static Insertable<DriftCardImage> custom({
    Expression<int>? id,
    Expression<int>? cardId,
    Expression<int>? imageId,
    Expression<String>? imageUrl,
    Expression<String>? imageUrlSmall,
    Expression<String>? imageUrlCropped,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cardId != null) 'card_id': cardId,
      if (imageId != null) 'image_id': imageId,
      if (imageUrl != null) 'image_url': imageUrl,
      if (imageUrlSmall != null) 'image_url_small': imageUrlSmall,
      if (imageUrlCropped != null) 'image_url_cropped': imageUrlCropped,
    });
  }

  CardImagesCompanion copyWith({
    Value<int>? id,
    Value<int>? cardId,
    Value<int>? imageId,
    Value<String>? imageUrl,
    Value<String>? imageUrlSmall,
    Value<String>? imageUrlCropped,
  }) {
    return CardImagesCompanion(
      id: id ?? this.id,
      cardId: cardId ?? this.cardId,
      imageId: imageId ?? this.imageId,
      imageUrl: imageUrl ?? this.imageUrl,
      imageUrlSmall: imageUrlSmall ?? this.imageUrlSmall,
      imageUrlCropped: imageUrlCropped ?? this.imageUrlCropped,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<int>(cardId.value);
    }
    if (imageId.present) {
      map['image_id'] = Variable<int>(imageId.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (imageUrlSmall.present) {
      map['image_url_small'] = Variable<String>(imageUrlSmall.value);
    }
    if (imageUrlCropped.present) {
      map['image_url_cropped'] = Variable<String>(imageUrlCropped.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardImagesCompanion(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('imageId: $imageId, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('imageUrlSmall: $imageUrlSmall, ')
          ..write('imageUrlCropped: $imageUrlCropped')
          ..write(')'))
        .toString();
  }
}

class $CardPricesTable extends CardPrices
    with TableInfo<$CardPricesTable, DriftCardPrice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardPricesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<int> cardId = GeneratedColumn<int>(
    'card_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cards (id)',
    ),
  );
  static const VerificationMeta _cardMarketPriceMeta = const VerificationMeta(
    'cardMarketPrice',
  );
  @override
  late final GeneratedColumn<double> cardMarketPrice = GeneratedColumn<double>(
    'card_market_price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tcgPlayerPriceMeta = const VerificationMeta(
    'tcgPlayerPrice',
  );
  @override
  late final GeneratedColumn<double> tcgPlayerPrice = GeneratedColumn<double>(
    'tcg_player_price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ebayPriceMeta = const VerificationMeta(
    'ebayPrice',
  );
  @override
  late final GeneratedColumn<double> ebayPrice = GeneratedColumn<double>(
    'ebay_price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _amazonPriceMeta = const VerificationMeta(
    'amazonPrice',
  );
  @override
  late final GeneratedColumn<double> amazonPrice = GeneratedColumn<double>(
    'amazon_price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _coolStuffIncPriceMeta = const VerificationMeta(
    'coolStuffIncPrice',
  );
  @override
  late final GeneratedColumn<double> coolStuffIncPrice =
      GeneratedColumn<double>(
        'cool_stuff_inc_price',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cardId,
    cardMarketPrice,
    tcgPlayerPrice,
    ebayPrice,
    amazonPrice,
    coolStuffIncPrice,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'card_prices';
  @override
  VerificationContext validateIntegrity(
    Insertable<DriftCardPrice> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('card_id')) {
      context.handle(
        _cardIdMeta,
        cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('card_market_price')) {
      context.handle(
        _cardMarketPriceMeta,
        cardMarketPrice.isAcceptableOrUnknown(
          data['card_market_price']!,
          _cardMarketPriceMeta,
        ),
      );
    }
    if (data.containsKey('tcg_player_price')) {
      context.handle(
        _tcgPlayerPriceMeta,
        tcgPlayerPrice.isAcceptableOrUnknown(
          data['tcg_player_price']!,
          _tcgPlayerPriceMeta,
        ),
      );
    }
    if (data.containsKey('ebay_price')) {
      context.handle(
        _ebayPriceMeta,
        ebayPrice.isAcceptableOrUnknown(data['ebay_price']!, _ebayPriceMeta),
      );
    }
    if (data.containsKey('amazon_price')) {
      context.handle(
        _amazonPriceMeta,
        amazonPrice.isAcceptableOrUnknown(
          data['amazon_price']!,
          _amazonPriceMeta,
        ),
      );
    }
    if (data.containsKey('cool_stuff_inc_price')) {
      context.handle(
        _coolStuffIncPriceMeta,
        coolStuffIncPrice.isAcceptableOrUnknown(
          data['cool_stuff_inc_price']!,
          _coolStuffIncPriceMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriftCardPrice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftCardPrice(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cardId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}card_id'],
      )!,
      cardMarketPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}card_market_price'],
      ),
      tcgPlayerPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tcg_player_price'],
      ),
      ebayPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ebay_price'],
      ),
      amazonPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amazon_price'],
      ),
      coolStuffIncPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cool_stuff_inc_price'],
      ),
    );
  }

  @override
  $CardPricesTable createAlias(String alias) {
    return $CardPricesTable(attachedDatabase, alias);
  }
}

class DriftCardPrice extends DataClass implements Insertable<DriftCardPrice> {
  final int id;
  final int cardId;
  final double? cardMarketPrice;
  final double? tcgPlayerPrice;
  final double? ebayPrice;
  final double? amazonPrice;
  final double? coolStuffIncPrice;
  const DriftCardPrice({
    required this.id,
    required this.cardId,
    this.cardMarketPrice,
    this.tcgPlayerPrice,
    this.ebayPrice,
    this.amazonPrice,
    this.coolStuffIncPrice,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['card_id'] = Variable<int>(cardId);
    if (!nullToAbsent || cardMarketPrice != null) {
      map['card_market_price'] = Variable<double>(cardMarketPrice);
    }
    if (!nullToAbsent || tcgPlayerPrice != null) {
      map['tcg_player_price'] = Variable<double>(tcgPlayerPrice);
    }
    if (!nullToAbsent || ebayPrice != null) {
      map['ebay_price'] = Variable<double>(ebayPrice);
    }
    if (!nullToAbsent || amazonPrice != null) {
      map['amazon_price'] = Variable<double>(amazonPrice);
    }
    if (!nullToAbsent || coolStuffIncPrice != null) {
      map['cool_stuff_inc_price'] = Variable<double>(coolStuffIncPrice);
    }
    return map;
  }

  CardPricesCompanion toCompanion(bool nullToAbsent) {
    return CardPricesCompanion(
      id: Value(id),
      cardId: Value(cardId),
      cardMarketPrice: cardMarketPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(cardMarketPrice),
      tcgPlayerPrice: tcgPlayerPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(tcgPlayerPrice),
      ebayPrice: ebayPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(ebayPrice),
      amazonPrice: amazonPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(amazonPrice),
      coolStuffIncPrice: coolStuffIncPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(coolStuffIncPrice),
    );
  }

  factory DriftCardPrice.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftCardPrice(
      id: serializer.fromJson<int>(json['id']),
      cardId: serializer.fromJson<int>(json['cardId']),
      cardMarketPrice: serializer.fromJson<double?>(json['cardMarketPrice']),
      tcgPlayerPrice: serializer.fromJson<double?>(json['tcgPlayerPrice']),
      ebayPrice: serializer.fromJson<double?>(json['ebayPrice']),
      amazonPrice: serializer.fromJson<double?>(json['amazonPrice']),
      coolStuffIncPrice: serializer.fromJson<double?>(
        json['coolStuffIncPrice'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cardId': serializer.toJson<int>(cardId),
      'cardMarketPrice': serializer.toJson<double?>(cardMarketPrice),
      'tcgPlayerPrice': serializer.toJson<double?>(tcgPlayerPrice),
      'ebayPrice': serializer.toJson<double?>(ebayPrice),
      'amazonPrice': serializer.toJson<double?>(amazonPrice),
      'coolStuffIncPrice': serializer.toJson<double?>(coolStuffIncPrice),
    };
  }

  DriftCardPrice copyWith({
    int? id,
    int? cardId,
    Value<double?> cardMarketPrice = const Value.absent(),
    Value<double?> tcgPlayerPrice = const Value.absent(),
    Value<double?> ebayPrice = const Value.absent(),
    Value<double?> amazonPrice = const Value.absent(),
    Value<double?> coolStuffIncPrice = const Value.absent(),
  }) => DriftCardPrice(
    id: id ?? this.id,
    cardId: cardId ?? this.cardId,
    cardMarketPrice: cardMarketPrice.present
        ? cardMarketPrice.value
        : this.cardMarketPrice,
    tcgPlayerPrice: tcgPlayerPrice.present
        ? tcgPlayerPrice.value
        : this.tcgPlayerPrice,
    ebayPrice: ebayPrice.present ? ebayPrice.value : this.ebayPrice,
    amazonPrice: amazonPrice.present ? amazonPrice.value : this.amazonPrice,
    coolStuffIncPrice: coolStuffIncPrice.present
        ? coolStuffIncPrice.value
        : this.coolStuffIncPrice,
  );
  DriftCardPrice copyWithCompanion(CardPricesCompanion data) {
    return DriftCardPrice(
      id: data.id.present ? data.id.value : this.id,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      cardMarketPrice: data.cardMarketPrice.present
          ? data.cardMarketPrice.value
          : this.cardMarketPrice,
      tcgPlayerPrice: data.tcgPlayerPrice.present
          ? data.tcgPlayerPrice.value
          : this.tcgPlayerPrice,
      ebayPrice: data.ebayPrice.present ? data.ebayPrice.value : this.ebayPrice,
      amazonPrice: data.amazonPrice.present
          ? data.amazonPrice.value
          : this.amazonPrice,
      coolStuffIncPrice: data.coolStuffIncPrice.present
          ? data.coolStuffIncPrice.value
          : this.coolStuffIncPrice,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriftCardPrice(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('cardMarketPrice: $cardMarketPrice, ')
          ..write('tcgPlayerPrice: $tcgPlayerPrice, ')
          ..write('ebayPrice: $ebayPrice, ')
          ..write('amazonPrice: $amazonPrice, ')
          ..write('coolStuffIncPrice: $coolStuffIncPrice')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    cardId,
    cardMarketPrice,
    tcgPlayerPrice,
    ebayPrice,
    amazonPrice,
    coolStuffIncPrice,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftCardPrice &&
          other.id == this.id &&
          other.cardId == this.cardId &&
          other.cardMarketPrice == this.cardMarketPrice &&
          other.tcgPlayerPrice == this.tcgPlayerPrice &&
          other.ebayPrice == this.ebayPrice &&
          other.amazonPrice == this.amazonPrice &&
          other.coolStuffIncPrice == this.coolStuffIncPrice);
}

class CardPricesCompanion extends UpdateCompanion<DriftCardPrice> {
  final Value<int> id;
  final Value<int> cardId;
  final Value<double?> cardMarketPrice;
  final Value<double?> tcgPlayerPrice;
  final Value<double?> ebayPrice;
  final Value<double?> amazonPrice;
  final Value<double?> coolStuffIncPrice;
  const CardPricesCompanion({
    this.id = const Value.absent(),
    this.cardId = const Value.absent(),
    this.cardMarketPrice = const Value.absent(),
    this.tcgPlayerPrice = const Value.absent(),
    this.ebayPrice = const Value.absent(),
    this.amazonPrice = const Value.absent(),
    this.coolStuffIncPrice = const Value.absent(),
  });
  CardPricesCompanion.insert({
    this.id = const Value.absent(),
    required int cardId,
    this.cardMarketPrice = const Value.absent(),
    this.tcgPlayerPrice = const Value.absent(),
    this.ebayPrice = const Value.absent(),
    this.amazonPrice = const Value.absent(),
    this.coolStuffIncPrice = const Value.absent(),
  }) : cardId = Value(cardId);
  static Insertable<DriftCardPrice> custom({
    Expression<int>? id,
    Expression<int>? cardId,
    Expression<double>? cardMarketPrice,
    Expression<double>? tcgPlayerPrice,
    Expression<double>? ebayPrice,
    Expression<double>? amazonPrice,
    Expression<double>? coolStuffIncPrice,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cardId != null) 'card_id': cardId,
      if (cardMarketPrice != null) 'card_market_price': cardMarketPrice,
      if (tcgPlayerPrice != null) 'tcg_player_price': tcgPlayerPrice,
      if (ebayPrice != null) 'ebay_price': ebayPrice,
      if (amazonPrice != null) 'amazon_price': amazonPrice,
      if (coolStuffIncPrice != null) 'cool_stuff_inc_price': coolStuffIncPrice,
    });
  }

  CardPricesCompanion copyWith({
    Value<int>? id,
    Value<int>? cardId,
    Value<double?>? cardMarketPrice,
    Value<double?>? tcgPlayerPrice,
    Value<double?>? ebayPrice,
    Value<double?>? amazonPrice,
    Value<double?>? coolStuffIncPrice,
  }) {
    return CardPricesCompanion(
      id: id ?? this.id,
      cardId: cardId ?? this.cardId,
      cardMarketPrice: cardMarketPrice ?? this.cardMarketPrice,
      tcgPlayerPrice: tcgPlayerPrice ?? this.tcgPlayerPrice,
      ebayPrice: ebayPrice ?? this.ebayPrice,
      amazonPrice: amazonPrice ?? this.amazonPrice,
      coolStuffIncPrice: coolStuffIncPrice ?? this.coolStuffIncPrice,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<int>(cardId.value);
    }
    if (cardMarketPrice.present) {
      map['card_market_price'] = Variable<double>(cardMarketPrice.value);
    }
    if (tcgPlayerPrice.present) {
      map['tcg_player_price'] = Variable<double>(tcgPlayerPrice.value);
    }
    if (ebayPrice.present) {
      map['ebay_price'] = Variable<double>(ebayPrice.value);
    }
    if (amazonPrice.present) {
      map['amazon_price'] = Variable<double>(amazonPrice.value);
    }
    if (coolStuffIncPrice.present) {
      map['cool_stuff_inc_price'] = Variable<double>(coolStuffIncPrice.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardPricesCompanion(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('cardMarketPrice: $cardMarketPrice, ')
          ..write('tcgPlayerPrice: $tcgPlayerPrice, ')
          ..write('ebayPrice: $ebayPrice, ')
          ..write('amazonPrice: $amazonPrice, ')
          ..write('coolStuffIncPrice: $coolStuffIncPrice')
          ..write(')'))
        .toString();
  }
}

class $CardSetsTable extends CardSets
    with TableInfo<$CardSetsTable, DriftCardSet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardSetsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<int> cardId = GeneratedColumn<int>(
    'card_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cards (id)',
    ),
  );
  static const VerificationMeta _setNameMeta = const VerificationMeta(
    'setName',
  );
  @override
  late final GeneratedColumn<String> setName = GeneratedColumn<String>(
    'set_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _setCodeMeta = const VerificationMeta(
    'setCode',
  );
  @override
  late final GeneratedColumn<String> setCode = GeneratedColumn<String>(
    'set_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _setRarityMeta = const VerificationMeta(
    'setRarity',
  );
  @override
  late final GeneratedColumn<String> setRarity = GeneratedColumn<String>(
    'set_rarity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _setRarityCodeMeta = const VerificationMeta(
    'setRarityCode',
  );
  @override
  late final GeneratedColumn<String> setRarityCode = GeneratedColumn<String>(
    'set_rarity_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _setPriceMeta = const VerificationMeta(
    'setPrice',
  );
  @override
  late final GeneratedColumn<double> setPrice = GeneratedColumn<double>(
    'set_price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cardId,
    setName,
    setCode,
    setRarity,
    setRarityCode,
    setPrice,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'card_sets';
  @override
  VerificationContext validateIntegrity(
    Insertable<DriftCardSet> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('card_id')) {
      context.handle(
        _cardIdMeta,
        cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('set_name')) {
      context.handle(
        _setNameMeta,
        setName.isAcceptableOrUnknown(data['set_name']!, _setNameMeta),
      );
    } else if (isInserting) {
      context.missing(_setNameMeta);
    }
    if (data.containsKey('set_code')) {
      context.handle(
        _setCodeMeta,
        setCode.isAcceptableOrUnknown(data['set_code']!, _setCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_setCodeMeta);
    }
    if (data.containsKey('set_rarity')) {
      context.handle(
        _setRarityMeta,
        setRarity.isAcceptableOrUnknown(data['set_rarity']!, _setRarityMeta),
      );
    } else if (isInserting) {
      context.missing(_setRarityMeta);
    }
    if (data.containsKey('set_rarity_code')) {
      context.handle(
        _setRarityCodeMeta,
        setRarityCode.isAcceptableOrUnknown(
          data['set_rarity_code']!,
          _setRarityCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_setRarityCodeMeta);
    }
    if (data.containsKey('set_price')) {
      context.handle(
        _setPriceMeta,
        setPrice.isAcceptableOrUnknown(data['set_price']!, _setPriceMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriftCardSet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftCardSet(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cardId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}card_id'],
      )!,
      setName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}set_name'],
      )!,
      setCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}set_code'],
      )!,
      setRarity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}set_rarity'],
      )!,
      setRarityCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}set_rarity_code'],
      )!,
      setPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}set_price'],
      ),
    );
  }

  @override
  $CardSetsTable createAlias(String alias) {
    return $CardSetsTable(attachedDatabase, alias);
  }
}

class DriftCardSet extends DataClass implements Insertable<DriftCardSet> {
  final int id;
  final int cardId;
  final String setName;
  final String setCode;
  final String setRarity;
  final String setRarityCode;
  final double? setPrice;
  const DriftCardSet({
    required this.id,
    required this.cardId,
    required this.setName,
    required this.setCode,
    required this.setRarity,
    required this.setRarityCode,
    this.setPrice,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['card_id'] = Variable<int>(cardId);
    map['set_name'] = Variable<String>(setName);
    map['set_code'] = Variable<String>(setCode);
    map['set_rarity'] = Variable<String>(setRarity);
    map['set_rarity_code'] = Variable<String>(setRarityCode);
    if (!nullToAbsent || setPrice != null) {
      map['set_price'] = Variable<double>(setPrice);
    }
    return map;
  }

  CardSetsCompanion toCompanion(bool nullToAbsent) {
    return CardSetsCompanion(
      id: Value(id),
      cardId: Value(cardId),
      setName: Value(setName),
      setCode: Value(setCode),
      setRarity: Value(setRarity),
      setRarityCode: Value(setRarityCode),
      setPrice: setPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(setPrice),
    );
  }

  factory DriftCardSet.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftCardSet(
      id: serializer.fromJson<int>(json['id']),
      cardId: serializer.fromJson<int>(json['cardId']),
      setName: serializer.fromJson<String>(json['setName']),
      setCode: serializer.fromJson<String>(json['setCode']),
      setRarity: serializer.fromJson<String>(json['setRarity']),
      setRarityCode: serializer.fromJson<String>(json['setRarityCode']),
      setPrice: serializer.fromJson<double?>(json['setPrice']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cardId': serializer.toJson<int>(cardId),
      'setName': serializer.toJson<String>(setName),
      'setCode': serializer.toJson<String>(setCode),
      'setRarity': serializer.toJson<String>(setRarity),
      'setRarityCode': serializer.toJson<String>(setRarityCode),
      'setPrice': serializer.toJson<double?>(setPrice),
    };
  }

  DriftCardSet copyWith({
    int? id,
    int? cardId,
    String? setName,
    String? setCode,
    String? setRarity,
    String? setRarityCode,
    Value<double?> setPrice = const Value.absent(),
  }) => DriftCardSet(
    id: id ?? this.id,
    cardId: cardId ?? this.cardId,
    setName: setName ?? this.setName,
    setCode: setCode ?? this.setCode,
    setRarity: setRarity ?? this.setRarity,
    setRarityCode: setRarityCode ?? this.setRarityCode,
    setPrice: setPrice.present ? setPrice.value : this.setPrice,
  );
  DriftCardSet copyWithCompanion(CardSetsCompanion data) {
    return DriftCardSet(
      id: data.id.present ? data.id.value : this.id,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      setName: data.setName.present ? data.setName.value : this.setName,
      setCode: data.setCode.present ? data.setCode.value : this.setCode,
      setRarity: data.setRarity.present ? data.setRarity.value : this.setRarity,
      setRarityCode: data.setRarityCode.present
          ? data.setRarityCode.value
          : this.setRarityCode,
      setPrice: data.setPrice.present ? data.setPrice.value : this.setPrice,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriftCardSet(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('setName: $setName, ')
          ..write('setCode: $setCode, ')
          ..write('setRarity: $setRarity, ')
          ..write('setRarityCode: $setRarityCode, ')
          ..write('setPrice: $setPrice')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    cardId,
    setName,
    setCode,
    setRarity,
    setRarityCode,
    setPrice,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftCardSet &&
          other.id == this.id &&
          other.cardId == this.cardId &&
          other.setName == this.setName &&
          other.setCode == this.setCode &&
          other.setRarity == this.setRarity &&
          other.setRarityCode == this.setRarityCode &&
          other.setPrice == this.setPrice);
}

class CardSetsCompanion extends UpdateCompanion<DriftCardSet> {
  final Value<int> id;
  final Value<int> cardId;
  final Value<String> setName;
  final Value<String> setCode;
  final Value<String> setRarity;
  final Value<String> setRarityCode;
  final Value<double?> setPrice;
  const CardSetsCompanion({
    this.id = const Value.absent(),
    this.cardId = const Value.absent(),
    this.setName = const Value.absent(),
    this.setCode = const Value.absent(),
    this.setRarity = const Value.absent(),
    this.setRarityCode = const Value.absent(),
    this.setPrice = const Value.absent(),
  });
  CardSetsCompanion.insert({
    this.id = const Value.absent(),
    required int cardId,
    required String setName,
    required String setCode,
    required String setRarity,
    required String setRarityCode,
    this.setPrice = const Value.absent(),
  }) : cardId = Value(cardId),
       setName = Value(setName),
       setCode = Value(setCode),
       setRarity = Value(setRarity),
       setRarityCode = Value(setRarityCode);
  static Insertable<DriftCardSet> custom({
    Expression<int>? id,
    Expression<int>? cardId,
    Expression<String>? setName,
    Expression<String>? setCode,
    Expression<String>? setRarity,
    Expression<String>? setRarityCode,
    Expression<double>? setPrice,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cardId != null) 'card_id': cardId,
      if (setName != null) 'set_name': setName,
      if (setCode != null) 'set_code': setCode,
      if (setRarity != null) 'set_rarity': setRarity,
      if (setRarityCode != null) 'set_rarity_code': setRarityCode,
      if (setPrice != null) 'set_price': setPrice,
    });
  }

  CardSetsCompanion copyWith({
    Value<int>? id,
    Value<int>? cardId,
    Value<String>? setName,
    Value<String>? setCode,
    Value<String>? setRarity,
    Value<String>? setRarityCode,
    Value<double?>? setPrice,
  }) {
    return CardSetsCompanion(
      id: id ?? this.id,
      cardId: cardId ?? this.cardId,
      setName: setName ?? this.setName,
      setCode: setCode ?? this.setCode,
      setRarity: setRarity ?? this.setRarity,
      setRarityCode: setRarityCode ?? this.setRarityCode,
      setPrice: setPrice ?? this.setPrice,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<int>(cardId.value);
    }
    if (setName.present) {
      map['set_name'] = Variable<String>(setName.value);
    }
    if (setCode.present) {
      map['set_code'] = Variable<String>(setCode.value);
    }
    if (setRarity.present) {
      map['set_rarity'] = Variable<String>(setRarity.value);
    }
    if (setRarityCode.present) {
      map['set_rarity_code'] = Variable<String>(setRarityCode.value);
    }
    if (setPrice.present) {
      map['set_price'] = Variable<double>(setPrice.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardSetsCompanion(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('setName: $setName, ')
          ..write('setCode: $setCode, ')
          ..write('setRarity: $setRarity, ')
          ..write('setRarityCode: $setRarityCode, ')
          ..write('setPrice: $setPrice')
          ..write(')'))
        .toString();
  }
}

class $BanlistInfosTable extends BanlistInfos
    with TableInfo<$BanlistInfosTable, DriftBanlistInfo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BanlistInfosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<int> cardId = GeneratedColumn<int>(
    'card_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cards (id)',
    ),
  );
  static const VerificationMeta _banTcgMeta = const VerificationMeta('banTcg');
  @override
  late final GeneratedColumn<String> banTcg = GeneratedColumn<String>(
    'ban_tcg',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _banOcgMeta = const VerificationMeta('banOcg');
  @override
  late final GeneratedColumn<String> banOcg = GeneratedColumn<String>(
    'ban_ocg',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _banGoatMeta = const VerificationMeta(
    'banGoat',
  );
  @override
  late final GeneratedColumn<String> banGoat = GeneratedColumn<String>(
    'ban_goat',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _banEdisonMeta = const VerificationMeta(
    'banEdison',
  );
  @override
  late final GeneratedColumn<String> banEdison = GeneratedColumn<String>(
    'ban_edison',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    cardId,
    banTcg,
    banOcg,
    banGoat,
    banEdison,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'banlist_infos';
  @override
  VerificationContext validateIntegrity(
    Insertable<DriftBanlistInfo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('card_id')) {
      context.handle(
        _cardIdMeta,
        cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta),
      );
    }
    if (data.containsKey('ban_tcg')) {
      context.handle(
        _banTcgMeta,
        banTcg.isAcceptableOrUnknown(data['ban_tcg']!, _banTcgMeta),
      );
    }
    if (data.containsKey('ban_ocg')) {
      context.handle(
        _banOcgMeta,
        banOcg.isAcceptableOrUnknown(data['ban_ocg']!, _banOcgMeta),
      );
    }
    if (data.containsKey('ban_goat')) {
      context.handle(
        _banGoatMeta,
        banGoat.isAcceptableOrUnknown(data['ban_goat']!, _banGoatMeta),
      );
    }
    if (data.containsKey('ban_edison')) {
      context.handle(
        _banEdisonMeta,
        banEdison.isAcceptableOrUnknown(data['ban_edison']!, _banEdisonMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {cardId};
  @override
  DriftBanlistInfo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftBanlistInfo(
      cardId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}card_id'],
      )!,
      banTcg: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ban_tcg'],
      ),
      banOcg: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ban_ocg'],
      ),
      banGoat: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ban_goat'],
      ),
      banEdison: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ban_edison'],
      ),
    );
  }

  @override
  $BanlistInfosTable createAlias(String alias) {
    return $BanlistInfosTable(attachedDatabase, alias);
  }
}

class DriftBanlistInfo extends DataClass
    implements Insertable<DriftBanlistInfo> {
  final int cardId;
  final String? banTcg;
  final String? banOcg;
  final String? banGoat;
  final String? banEdison;
  const DriftBanlistInfo({
    required this.cardId,
    this.banTcg,
    this.banOcg,
    this.banGoat,
    this.banEdison,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['card_id'] = Variable<int>(cardId);
    if (!nullToAbsent || banTcg != null) {
      map['ban_tcg'] = Variable<String>(banTcg);
    }
    if (!nullToAbsent || banOcg != null) {
      map['ban_ocg'] = Variable<String>(banOcg);
    }
    if (!nullToAbsent || banGoat != null) {
      map['ban_goat'] = Variable<String>(banGoat);
    }
    if (!nullToAbsent || banEdison != null) {
      map['ban_edison'] = Variable<String>(banEdison);
    }
    return map;
  }

  BanlistInfosCompanion toCompanion(bool nullToAbsent) {
    return BanlistInfosCompanion(
      cardId: Value(cardId),
      banTcg: banTcg == null && nullToAbsent
          ? const Value.absent()
          : Value(banTcg),
      banOcg: banOcg == null && nullToAbsent
          ? const Value.absent()
          : Value(banOcg),
      banGoat: banGoat == null && nullToAbsent
          ? const Value.absent()
          : Value(banGoat),
      banEdison: banEdison == null && nullToAbsent
          ? const Value.absent()
          : Value(banEdison),
    );
  }

  factory DriftBanlistInfo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftBanlistInfo(
      cardId: serializer.fromJson<int>(json['cardId']),
      banTcg: serializer.fromJson<String?>(json['banTcg']),
      banOcg: serializer.fromJson<String?>(json['banOcg']),
      banGoat: serializer.fromJson<String?>(json['banGoat']),
      banEdison: serializer.fromJson<String?>(json['banEdison']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cardId': serializer.toJson<int>(cardId),
      'banTcg': serializer.toJson<String?>(banTcg),
      'banOcg': serializer.toJson<String?>(banOcg),
      'banGoat': serializer.toJson<String?>(banGoat),
      'banEdison': serializer.toJson<String?>(banEdison),
    };
  }

  DriftBanlistInfo copyWith({
    int? cardId,
    Value<String?> banTcg = const Value.absent(),
    Value<String?> banOcg = const Value.absent(),
    Value<String?> banGoat = const Value.absent(),
    Value<String?> banEdison = const Value.absent(),
  }) => DriftBanlistInfo(
    cardId: cardId ?? this.cardId,
    banTcg: banTcg.present ? banTcg.value : this.banTcg,
    banOcg: banOcg.present ? banOcg.value : this.banOcg,
    banGoat: banGoat.present ? banGoat.value : this.banGoat,
    banEdison: banEdison.present ? banEdison.value : this.banEdison,
  );
  DriftBanlistInfo copyWithCompanion(BanlistInfosCompanion data) {
    return DriftBanlistInfo(
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      banTcg: data.banTcg.present ? data.banTcg.value : this.banTcg,
      banOcg: data.banOcg.present ? data.banOcg.value : this.banOcg,
      banGoat: data.banGoat.present ? data.banGoat.value : this.banGoat,
      banEdison: data.banEdison.present ? data.banEdison.value : this.banEdison,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriftBanlistInfo(')
          ..write('cardId: $cardId, ')
          ..write('banTcg: $banTcg, ')
          ..write('banOcg: $banOcg, ')
          ..write('banGoat: $banGoat, ')
          ..write('banEdison: $banEdison')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(cardId, banTcg, banOcg, banGoat, banEdison);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftBanlistInfo &&
          other.cardId == this.cardId &&
          other.banTcg == this.banTcg &&
          other.banOcg == this.banOcg &&
          other.banGoat == this.banGoat &&
          other.banEdison == this.banEdison);
}

class BanlistInfosCompanion extends UpdateCompanion<DriftBanlistInfo> {
  final Value<int> cardId;
  final Value<String?> banTcg;
  final Value<String?> banOcg;
  final Value<String?> banGoat;
  final Value<String?> banEdison;
  const BanlistInfosCompanion({
    this.cardId = const Value.absent(),
    this.banTcg = const Value.absent(),
    this.banOcg = const Value.absent(),
    this.banGoat = const Value.absent(),
    this.banEdison = const Value.absent(),
  });
  BanlistInfosCompanion.insert({
    this.cardId = const Value.absent(),
    this.banTcg = const Value.absent(),
    this.banOcg = const Value.absent(),
    this.banGoat = const Value.absent(),
    this.banEdison = const Value.absent(),
  });
  static Insertable<DriftBanlistInfo> custom({
    Expression<int>? cardId,
    Expression<String>? banTcg,
    Expression<String>? banOcg,
    Expression<String>? banGoat,
    Expression<String>? banEdison,
  }) {
    return RawValuesInsertable({
      if (cardId != null) 'card_id': cardId,
      if (banTcg != null) 'ban_tcg': banTcg,
      if (banOcg != null) 'ban_ocg': banOcg,
      if (banGoat != null) 'ban_goat': banGoat,
      if (banEdison != null) 'ban_edison': banEdison,
    });
  }

  BanlistInfosCompanion copyWith({
    Value<int>? cardId,
    Value<String?>? banTcg,
    Value<String?>? banOcg,
    Value<String?>? banGoat,
    Value<String?>? banEdison,
  }) {
    return BanlistInfosCompanion(
      cardId: cardId ?? this.cardId,
      banTcg: banTcg ?? this.banTcg,
      banOcg: banOcg ?? this.banOcg,
      banGoat: banGoat ?? this.banGoat,
      banEdison: banEdison ?? this.banEdison,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cardId.present) {
      map['card_id'] = Variable<int>(cardId.value);
    }
    if (banTcg.present) {
      map['ban_tcg'] = Variable<String>(banTcg.value);
    }
    if (banOcg.present) {
      map['ban_ocg'] = Variable<String>(banOcg.value);
    }
    if (banGoat.present) {
      map['ban_goat'] = Variable<String>(banGoat.value);
    }
    if (banEdison.present) {
      map['ban_edison'] = Variable<String>(banEdison.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BanlistInfosCompanion(')
          ..write('cardId: $cardId, ')
          ..write('banTcg: $banTcg, ')
          ..write('banOcg: $banOcg, ')
          ..write('banGoat: $banGoat, ')
          ..write('banEdison: $banEdison')
          ..write(')'))
        .toString();
  }
}

class $CollectionItemsTable extends CollectionItems
    with TableInfo<$CollectionItemsTable, DriftCollectionItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CollectionItemsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<int> cardId = GeneratedColumn<int>(
    'card_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cards (id)',
    ),
  );
  static const VerificationMeta _setCodeMeta = const VerificationMeta(
    'setCode',
  );
  @override
  late final GeneratedColumn<String> setCode = GeneratedColumn<String>(
    'set_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rarityMeta = const VerificationMeta('rarity');
  @override
  late final GeneratedColumn<String> rarity = GeneratedColumn<String>(
    'rarity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _collectionNumberMeta = const VerificationMeta(
    'collectionNumber',
  );
  @override
  late final GeneratedColumn<int> collectionNumber = GeneratedColumn<int>(
    'collection_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _conditionMeta = const VerificationMeta(
    'condition',
  );
  @override
  late final GeneratedColumn<String> condition = GeneratedColumn<String>(
    'condition',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Near Mint'),
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('EN'),
  );
  static const VerificationMeta _isFirstEditionMeta = const VerificationMeta(
    'isFirstEdition',
  );
  @override
  late final GeneratedColumn<bool> isFirstEdition = GeneratedColumn<bool>(
    'is_first_edition',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_first_edition" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _priceAtPurchaseMeta = const VerificationMeta(
    'priceAtPurchase',
  );
  @override
  late final GeneratedColumn<double> priceAtPurchase = GeneratedColumn<double>(
    'price_at_purchase',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cardId,
    setCode,
    rarity,
    collectionNumber,
    quantity,
    condition,
    language,
    isFirstEdition,
    priceAtPurchase,
    notes,
    addedAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'collection_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<DriftCollectionItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('card_id')) {
      context.handle(
        _cardIdMeta,
        cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('set_code')) {
      context.handle(
        _setCodeMeta,
        setCode.isAcceptableOrUnknown(data['set_code']!, _setCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_setCodeMeta);
    }
    if (data.containsKey('rarity')) {
      context.handle(
        _rarityMeta,
        rarity.isAcceptableOrUnknown(data['rarity']!, _rarityMeta),
      );
    } else if (isInserting) {
      context.missing(_rarityMeta);
    }
    if (data.containsKey('collection_number')) {
      context.handle(
        _collectionNumberMeta,
        collectionNumber.isAcceptableOrUnknown(
          data['collection_number']!,
          _collectionNumberMeta,
        ),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('condition')) {
      context.handle(
        _conditionMeta,
        condition.isAcceptableOrUnknown(data['condition']!, _conditionMeta),
      );
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    }
    if (data.containsKey('is_first_edition')) {
      context.handle(
        _isFirstEditionMeta,
        isFirstEdition.isAcceptableOrUnknown(
          data['is_first_edition']!,
          _isFirstEditionMeta,
        ),
      );
    }
    if (data.containsKey('price_at_purchase')) {
      context.handle(
        _priceAtPurchaseMeta,
        priceAtPurchase.isAcceptableOrUnknown(
          data['price_at_purchase']!,
          _priceAtPurchaseMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriftCollectionItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftCollectionItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cardId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}card_id'],
      )!,
      setCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}set_code'],
      )!,
      rarity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rarity'],
      )!,
      collectionNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}collection_number'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      condition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}condition'],
      )!,
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
      isFirstEdition: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_first_edition'],
      )!,
      priceAtPurchase: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price_at_purchase'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CollectionItemsTable createAlias(String alias) {
    return $CollectionItemsTable(attachedDatabase, alias);
  }
}

class DriftCollectionItem extends DataClass
    implements Insertable<DriftCollectionItem> {
  final int id;
  final int cardId;
  final String setCode;
  final String rarity;
  final int collectionNumber;
  final int quantity;
  final String condition;
  final String language;
  final bool isFirstEdition;
  final double? priceAtPurchase;
  final String? notes;
  final DateTime addedAt;
  final DateTime updatedAt;
  const DriftCollectionItem({
    required this.id,
    required this.cardId,
    required this.setCode,
    required this.rarity,
    required this.collectionNumber,
    required this.quantity,
    required this.condition,
    required this.language,
    required this.isFirstEdition,
    this.priceAtPurchase,
    this.notes,
    required this.addedAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['card_id'] = Variable<int>(cardId);
    map['set_code'] = Variable<String>(setCode);
    map['rarity'] = Variable<String>(rarity);
    map['collection_number'] = Variable<int>(collectionNumber);
    map['quantity'] = Variable<int>(quantity);
    map['condition'] = Variable<String>(condition);
    map['language'] = Variable<String>(language);
    map['is_first_edition'] = Variable<bool>(isFirstEdition);
    if (!nullToAbsent || priceAtPurchase != null) {
      map['price_at_purchase'] = Variable<double>(priceAtPurchase);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['added_at'] = Variable<DateTime>(addedAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CollectionItemsCompanion toCompanion(bool nullToAbsent) {
    return CollectionItemsCompanion(
      id: Value(id),
      cardId: Value(cardId),
      setCode: Value(setCode),
      rarity: Value(rarity),
      collectionNumber: Value(collectionNumber),
      quantity: Value(quantity),
      condition: Value(condition),
      language: Value(language),
      isFirstEdition: Value(isFirstEdition),
      priceAtPurchase: priceAtPurchase == null && nullToAbsent
          ? const Value.absent()
          : Value(priceAtPurchase),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      addedAt: Value(addedAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DriftCollectionItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftCollectionItem(
      id: serializer.fromJson<int>(json['id']),
      cardId: serializer.fromJson<int>(json['cardId']),
      setCode: serializer.fromJson<String>(json['setCode']),
      rarity: serializer.fromJson<String>(json['rarity']),
      collectionNumber: serializer.fromJson<int>(json['collectionNumber']),
      quantity: serializer.fromJson<int>(json['quantity']),
      condition: serializer.fromJson<String>(json['condition']),
      language: serializer.fromJson<String>(json['language']),
      isFirstEdition: serializer.fromJson<bool>(json['isFirstEdition']),
      priceAtPurchase: serializer.fromJson<double?>(json['priceAtPurchase']),
      notes: serializer.fromJson<String?>(json['notes']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cardId': serializer.toJson<int>(cardId),
      'setCode': serializer.toJson<String>(setCode),
      'rarity': serializer.toJson<String>(rarity),
      'collectionNumber': serializer.toJson<int>(collectionNumber),
      'quantity': serializer.toJson<int>(quantity),
      'condition': serializer.toJson<String>(condition),
      'language': serializer.toJson<String>(language),
      'isFirstEdition': serializer.toJson<bool>(isFirstEdition),
      'priceAtPurchase': serializer.toJson<double?>(priceAtPurchase),
      'notes': serializer.toJson<String?>(notes),
      'addedAt': serializer.toJson<DateTime>(addedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DriftCollectionItem copyWith({
    int? id,
    int? cardId,
    String? setCode,
    String? rarity,
    int? collectionNumber,
    int? quantity,
    String? condition,
    String? language,
    bool? isFirstEdition,
    Value<double?> priceAtPurchase = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? addedAt,
    DateTime? updatedAt,
  }) => DriftCollectionItem(
    id: id ?? this.id,
    cardId: cardId ?? this.cardId,
    setCode: setCode ?? this.setCode,
    rarity: rarity ?? this.rarity,
    collectionNumber: collectionNumber ?? this.collectionNumber,
    quantity: quantity ?? this.quantity,
    condition: condition ?? this.condition,
    language: language ?? this.language,
    isFirstEdition: isFirstEdition ?? this.isFirstEdition,
    priceAtPurchase: priceAtPurchase.present
        ? priceAtPurchase.value
        : this.priceAtPurchase,
    notes: notes.present ? notes.value : this.notes,
    addedAt: addedAt ?? this.addedAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DriftCollectionItem copyWithCompanion(CollectionItemsCompanion data) {
    return DriftCollectionItem(
      id: data.id.present ? data.id.value : this.id,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      setCode: data.setCode.present ? data.setCode.value : this.setCode,
      rarity: data.rarity.present ? data.rarity.value : this.rarity,
      collectionNumber: data.collectionNumber.present
          ? data.collectionNumber.value
          : this.collectionNumber,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      condition: data.condition.present ? data.condition.value : this.condition,
      language: data.language.present ? data.language.value : this.language,
      isFirstEdition: data.isFirstEdition.present
          ? data.isFirstEdition.value
          : this.isFirstEdition,
      priceAtPurchase: data.priceAtPurchase.present
          ? data.priceAtPurchase.value
          : this.priceAtPurchase,
      notes: data.notes.present ? data.notes.value : this.notes,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriftCollectionItem(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('setCode: $setCode, ')
          ..write('rarity: $rarity, ')
          ..write('collectionNumber: $collectionNumber, ')
          ..write('quantity: $quantity, ')
          ..write('condition: $condition, ')
          ..write('language: $language, ')
          ..write('isFirstEdition: $isFirstEdition, ')
          ..write('priceAtPurchase: $priceAtPurchase, ')
          ..write('notes: $notes, ')
          ..write('addedAt: $addedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    cardId,
    setCode,
    rarity,
    collectionNumber,
    quantity,
    condition,
    language,
    isFirstEdition,
    priceAtPurchase,
    notes,
    addedAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftCollectionItem &&
          other.id == this.id &&
          other.cardId == this.cardId &&
          other.setCode == this.setCode &&
          other.rarity == this.rarity &&
          other.collectionNumber == this.collectionNumber &&
          other.quantity == this.quantity &&
          other.condition == this.condition &&
          other.language == this.language &&
          other.isFirstEdition == this.isFirstEdition &&
          other.priceAtPurchase == this.priceAtPurchase &&
          other.notes == this.notes &&
          other.addedAt == this.addedAt &&
          other.updatedAt == this.updatedAt);
}

class CollectionItemsCompanion extends UpdateCompanion<DriftCollectionItem> {
  final Value<int> id;
  final Value<int> cardId;
  final Value<String> setCode;
  final Value<String> rarity;
  final Value<int> collectionNumber;
  final Value<int> quantity;
  final Value<String> condition;
  final Value<String> language;
  final Value<bool> isFirstEdition;
  final Value<double?> priceAtPurchase;
  final Value<String?> notes;
  final Value<DateTime> addedAt;
  final Value<DateTime> updatedAt;
  const CollectionItemsCompanion({
    this.id = const Value.absent(),
    this.cardId = const Value.absent(),
    this.setCode = const Value.absent(),
    this.rarity = const Value.absent(),
    this.collectionNumber = const Value.absent(),
    this.quantity = const Value.absent(),
    this.condition = const Value.absent(),
    this.language = const Value.absent(),
    this.isFirstEdition = const Value.absent(),
    this.priceAtPurchase = const Value.absent(),
    this.notes = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CollectionItemsCompanion.insert({
    this.id = const Value.absent(),
    required int cardId,
    required String setCode,
    required String rarity,
    this.collectionNumber = const Value.absent(),
    this.quantity = const Value.absent(),
    this.condition = const Value.absent(),
    this.language = const Value.absent(),
    this.isFirstEdition = const Value.absent(),
    this.priceAtPurchase = const Value.absent(),
    this.notes = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : cardId = Value(cardId),
       setCode = Value(setCode),
       rarity = Value(rarity);
  static Insertable<DriftCollectionItem> custom({
    Expression<int>? id,
    Expression<int>? cardId,
    Expression<String>? setCode,
    Expression<String>? rarity,
    Expression<int>? collectionNumber,
    Expression<int>? quantity,
    Expression<String>? condition,
    Expression<String>? language,
    Expression<bool>? isFirstEdition,
    Expression<double>? priceAtPurchase,
    Expression<String>? notes,
    Expression<DateTime>? addedAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cardId != null) 'card_id': cardId,
      if (setCode != null) 'set_code': setCode,
      if (rarity != null) 'rarity': rarity,
      if (collectionNumber != null) 'collection_number': collectionNumber,
      if (quantity != null) 'quantity': quantity,
      if (condition != null) 'condition': condition,
      if (language != null) 'language': language,
      if (isFirstEdition != null) 'is_first_edition': isFirstEdition,
      if (priceAtPurchase != null) 'price_at_purchase': priceAtPurchase,
      if (notes != null) 'notes': notes,
      if (addedAt != null) 'added_at': addedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CollectionItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? cardId,
    Value<String>? setCode,
    Value<String>? rarity,
    Value<int>? collectionNumber,
    Value<int>? quantity,
    Value<String>? condition,
    Value<String>? language,
    Value<bool>? isFirstEdition,
    Value<double?>? priceAtPurchase,
    Value<String?>? notes,
    Value<DateTime>? addedAt,
    Value<DateTime>? updatedAt,
  }) {
    return CollectionItemsCompanion(
      id: id ?? this.id,
      cardId: cardId ?? this.cardId,
      setCode: setCode ?? this.setCode,
      rarity: rarity ?? this.rarity,
      collectionNumber: collectionNumber ?? this.collectionNumber,
      quantity: quantity ?? this.quantity,
      condition: condition ?? this.condition,
      language: language ?? this.language,
      isFirstEdition: isFirstEdition ?? this.isFirstEdition,
      priceAtPurchase: priceAtPurchase ?? this.priceAtPurchase,
      notes: notes ?? this.notes,
      addedAt: addedAt ?? this.addedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<int>(cardId.value);
    }
    if (setCode.present) {
      map['set_code'] = Variable<String>(setCode.value);
    }
    if (rarity.present) {
      map['rarity'] = Variable<String>(rarity.value);
    }
    if (collectionNumber.present) {
      map['collection_number'] = Variable<int>(collectionNumber.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (condition.present) {
      map['condition'] = Variable<String>(condition.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (isFirstEdition.present) {
      map['is_first_edition'] = Variable<bool>(isFirstEdition.value);
    }
    if (priceAtPurchase.present) {
      map['price_at_purchase'] = Variable<double>(priceAtPurchase.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CollectionItemsCompanion(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('setCode: $setCode, ')
          ..write('rarity: $rarity, ')
          ..write('collectionNumber: $collectionNumber, ')
          ..write('quantity: $quantity, ')
          ..write('condition: $condition, ')
          ..write('language: $language, ')
          ..write('isFirstEdition: $isFirstEdition, ')
          ..write('priceAtPurchase: $priceAtPurchase, ')
          ..write('notes: $notes, ')
          ..write('addedAt: $addedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $AppConfigTable extends AppConfig
    with TableInfo<$AppConfigTable, DriftAppConfig> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppConfigTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _settingKeyMeta = const VerificationMeta(
    'settingKey',
  );
  @override
  late final GeneratedColumn<String> settingKey = GeneratedColumn<String>(
    'setting_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _settingValueMeta = const VerificationMeta(
    'settingValue',
  );
  @override
  late final GeneratedColumn<String> settingValue = GeneratedColumn<String>(
    'setting_value',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [settingKey, settingValue];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_config';
  @override
  VerificationContext validateIntegrity(
    Insertable<DriftAppConfig> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('setting_key')) {
      context.handle(
        _settingKeyMeta,
        settingKey.isAcceptableOrUnknown(data['setting_key']!, _settingKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_settingKeyMeta);
    }
    if (data.containsKey('setting_value')) {
      context.handle(
        _settingValueMeta,
        settingValue.isAcceptableOrUnknown(
          data['setting_value']!,
          _settingValueMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {settingKey};
  @override
  DriftAppConfig map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftAppConfig(
      settingKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}setting_key'],
      )!,
      settingValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}setting_value'],
      ),
    );
  }

  @override
  $AppConfigTable createAlias(String alias) {
    return $AppConfigTable(attachedDatabase, alias);
  }
}

class DriftAppConfig extends DataClass implements Insertable<DriftAppConfig> {
  final String settingKey;
  final String? settingValue;
  const DriftAppConfig({required this.settingKey, this.settingValue});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['setting_key'] = Variable<String>(settingKey);
    if (!nullToAbsent || settingValue != null) {
      map['setting_value'] = Variable<String>(settingValue);
    }
    return map;
  }

  AppConfigCompanion toCompanion(bool nullToAbsent) {
    return AppConfigCompanion(
      settingKey: Value(settingKey),
      settingValue: settingValue == null && nullToAbsent
          ? const Value.absent()
          : Value(settingValue),
    );
  }

  factory DriftAppConfig.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftAppConfig(
      settingKey: serializer.fromJson<String>(json['settingKey']),
      settingValue: serializer.fromJson<String?>(json['settingValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'settingKey': serializer.toJson<String>(settingKey),
      'settingValue': serializer.toJson<String?>(settingValue),
    };
  }

  DriftAppConfig copyWith({
    String? settingKey,
    Value<String?> settingValue = const Value.absent(),
  }) => DriftAppConfig(
    settingKey: settingKey ?? this.settingKey,
    settingValue: settingValue.present ? settingValue.value : this.settingValue,
  );
  DriftAppConfig copyWithCompanion(AppConfigCompanion data) {
    return DriftAppConfig(
      settingKey: data.settingKey.present
          ? data.settingKey.value
          : this.settingKey,
      settingValue: data.settingValue.present
          ? data.settingValue.value
          : this.settingValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriftAppConfig(')
          ..write('settingKey: $settingKey, ')
          ..write('settingValue: $settingValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(settingKey, settingValue);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftAppConfig &&
          other.settingKey == this.settingKey &&
          other.settingValue == this.settingValue);
}

class AppConfigCompanion extends UpdateCompanion<DriftAppConfig> {
  final Value<String> settingKey;
  final Value<String?> settingValue;
  final Value<int> rowid;
  const AppConfigCompanion({
    this.settingKey = const Value.absent(),
    this.settingValue = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppConfigCompanion.insert({
    required String settingKey,
    this.settingValue = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : settingKey = Value(settingKey);
  static Insertable<DriftAppConfig> custom({
    Expression<String>? settingKey,
    Expression<String>? settingValue,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (settingKey != null) 'setting_key': settingKey,
      if (settingValue != null) 'setting_value': settingValue,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppConfigCompanion copyWith({
    Value<String>? settingKey,
    Value<String?>? settingValue,
    Value<int>? rowid,
  }) {
    return AppConfigCompanion(
      settingKey: settingKey ?? this.settingKey,
      settingValue: settingValue ?? this.settingValue,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (settingKey.present) {
      map['setting_key'] = Variable<String>(settingKey.value);
    }
    if (settingValue.present) {
      map['setting_value'] = Variable<String>(settingValue.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppConfigCompanion(')
          ..write('settingKey: $settingKey, ')
          ..write('settingValue: $settingValue, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DecksTable extends Decks with TableInfo<$DecksTable, DriftDeck> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DecksTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'decks';
  @override
  VerificationContext validateIntegrity(
    Insertable<DriftDeck> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriftDeck map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftDeck(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
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
  $DecksTable createAlias(String alias) {
    return $DecksTable(attachedDatabase, alias);
  }
}

class DriftDeck extends DataClass implements Insertable<DriftDeck> {
  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  const DriftDeck({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DecksCompanion toCompanion(bool nullToAbsent) {
    return DecksCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DriftDeck.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftDeck(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DriftDeck copyWith({
    int? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => DriftDeck(
    id: id ?? this.id,
    name: name ?? this.name,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DriftDeck copyWithCompanion(DecksCompanion data) {
    return DriftDeck(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriftDeck(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftDeck &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DecksCompanion extends UpdateCompanion<DriftDeck> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const DecksCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  DecksCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<DriftDeck> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  DecksCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return DecksCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
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
    if (name.present) {
      map['name'] = Variable<String>(name.value);
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
    return (StringBuffer('DecksCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $DeckCardsTable extends DeckCards
    with TableInfo<$DeckCardsTable, DriftDeckCard> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeckCardsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _deckIdMeta = const VerificationMeta('deckId');
  @override
  late final GeneratedColumn<int> deckId = GeneratedColumn<int>(
    'deck_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES decks (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<int> cardId = GeneratedColumn<int>(
    'card_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cards (id)',
    ),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, deckId, cardId, category];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'deck_cards';
  @override
  VerificationContext validateIntegrity(
    Insertable<DriftDeckCard> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('deck_id')) {
      context.handle(
        _deckIdMeta,
        deckId.isAcceptableOrUnknown(data['deck_id']!, _deckIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deckIdMeta);
    }
    if (data.containsKey('card_id')) {
      context.handle(
        _cardIdMeta,
        cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriftDeckCard map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftDeckCard(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      deckId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deck_id'],
      )!,
      cardId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}card_id'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
    );
  }

  @override
  $DeckCardsTable createAlias(String alias) {
    return $DeckCardsTable(attachedDatabase, alias);
  }
}

class DriftDeckCard extends DataClass implements Insertable<DriftDeckCard> {
  final int id;
  final int deckId;
  final int cardId;
  final String category;
  const DriftDeckCard({
    required this.id,
    required this.deckId,
    required this.cardId,
    required this.category,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['deck_id'] = Variable<int>(deckId);
    map['card_id'] = Variable<int>(cardId);
    map['category'] = Variable<String>(category);
    return map;
  }

  DeckCardsCompanion toCompanion(bool nullToAbsent) {
    return DeckCardsCompanion(
      id: Value(id),
      deckId: Value(deckId),
      cardId: Value(cardId),
      category: Value(category),
    );
  }

  factory DriftDeckCard.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftDeckCard(
      id: serializer.fromJson<int>(json['id']),
      deckId: serializer.fromJson<int>(json['deckId']),
      cardId: serializer.fromJson<int>(json['cardId']),
      category: serializer.fromJson<String>(json['category']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'deckId': serializer.toJson<int>(deckId),
      'cardId': serializer.toJson<int>(cardId),
      'category': serializer.toJson<String>(category),
    };
  }

  DriftDeckCard copyWith({
    int? id,
    int? deckId,
    int? cardId,
    String? category,
  }) => DriftDeckCard(
    id: id ?? this.id,
    deckId: deckId ?? this.deckId,
    cardId: cardId ?? this.cardId,
    category: category ?? this.category,
  );
  DriftDeckCard copyWithCompanion(DeckCardsCompanion data) {
    return DriftDeckCard(
      id: data.id.present ? data.id.value : this.id,
      deckId: data.deckId.present ? data.deckId.value : this.deckId,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      category: data.category.present ? data.category.value : this.category,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriftDeckCard(')
          ..write('id: $id, ')
          ..write('deckId: $deckId, ')
          ..write('cardId: $cardId, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, deckId, cardId, category);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftDeckCard &&
          other.id == this.id &&
          other.deckId == this.deckId &&
          other.cardId == this.cardId &&
          other.category == this.category);
}

class DeckCardsCompanion extends UpdateCompanion<DriftDeckCard> {
  final Value<int> id;
  final Value<int> deckId;
  final Value<int> cardId;
  final Value<String> category;
  const DeckCardsCompanion({
    this.id = const Value.absent(),
    this.deckId = const Value.absent(),
    this.cardId = const Value.absent(),
    this.category = const Value.absent(),
  });
  DeckCardsCompanion.insert({
    this.id = const Value.absent(),
    required int deckId,
    required int cardId,
    required String category,
  }) : deckId = Value(deckId),
       cardId = Value(cardId),
       category = Value(category);
  static Insertable<DriftDeckCard> custom({
    Expression<int>? id,
    Expression<int>? deckId,
    Expression<int>? cardId,
    Expression<String>? category,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deckId != null) 'deck_id': deckId,
      if (cardId != null) 'card_id': cardId,
      if (category != null) 'category': category,
    });
  }

  DeckCardsCompanion copyWith({
    Value<int>? id,
    Value<int>? deckId,
    Value<int>? cardId,
    Value<String>? category,
  }) {
    return DeckCardsCompanion(
      id: id ?? this.id,
      deckId: deckId ?? this.deckId,
      cardId: cardId ?? this.cardId,
      category: category ?? this.category,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (deckId.present) {
      map['deck_id'] = Variable<int>(deckId.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<int>(cardId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeckCardsCompanion(')
          ..write('id: $id, ')
          ..write('deckId: $deckId, ')
          ..write('cardId: $cardId, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CardsTable cards = $CardsTable(this);
  late final $CardImagesTable cardImages = $CardImagesTable(this);
  late final $CardPricesTable cardPrices = $CardPricesTable(this);
  late final $CardSetsTable cardSets = $CardSetsTable(this);
  late final $BanlistInfosTable banlistInfos = $BanlistInfosTable(this);
  late final $CollectionItemsTable collectionItems = $CollectionItemsTable(
    this,
  );
  late final $AppConfigTable appConfig = $AppConfigTable(this);
  late final $DecksTable decks = $DecksTable(this);
  late final $DeckCardsTable deckCards = $DeckCardsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    cards,
    cardImages,
    cardPrices,
    cardSets,
    banlistInfos,
    collectionItems,
    appConfig,
    decks,
    deckCards,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'decks',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('deck_cards', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$CardsTableCreateCompanionBuilder = CardsCompanion Function({
  Value<int> id,
  required String name,
  required String type,
  required String desc,
  required String race,
  Value<String?> frameType,
  Value<String?> humanReadableCardType,
  Value<int?> atk,
  Value<int?> def,
  Value<int?> level,
  Value<String?> attribute,
  Value<String?> archetype,
  Value<int?> scale,
  Value<int?> linkVal,
  required String ygoProDeckUrl,
  Value<String?> pendDesc,
  Value<String?> monsterDesc,
  Value<String?> typeLineJson,
  Value<String?> linkMarkersJson,
  Value<DateTime?> tcgDate,
  Value<DateTime?> ocgDate,
});
typedef $$CardsTableUpdateCompanionBuilder = CardsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> type,
  Value<String> desc,
  Value<String> race,
  Value<String?> frameType,
  Value<String?> humanReadableCardType,
  Value<int?> atk,
  Value<int?> def,
  Value<int?> level,
  Value<String?> attribute,
  Value<String?> archetype,
  Value<int?> scale,
  Value<int?> linkVal,
  Value<String> ygoProDeckUrl,
  Value<String?> pendDesc,
  Value<String?> monsterDesc,
  Value<String?> typeLineJson,
  Value<String?> linkMarkersJson,
  Value<DateTime?> tcgDate,
  Value<DateTime?> ocgDate,
});

final class $$CardsTableReferences
    extends BaseReferences<_$AppDatabase, $CardsTable, DriftCard> {
  $$CardsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CardImagesTable, List<DriftCardImage>>
  _cardImagesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.cardImages,
    aliasName: 'cards__id__card_images__card_id',
  );

  $$CardImagesTableProcessedTableManager get cardImagesRefs {
    final manager = $$CardImagesTableTableManager(
      $_db,
      $_db.cardImages,
    ).filter((f) => f.cardId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_cardImagesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CardPricesTable, List<DriftCardPrice>>
  _cardPricesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.cardPrices,
    aliasName: 'cards__id__card_prices__card_id',
  );

  $$CardPricesTableProcessedTableManager get cardPricesRefs {
    final manager = $$CardPricesTableTableManager(
      $_db,
      $_db.cardPrices,
    ).filter((f) => f.cardId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_cardPricesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CardSetsTable, List<DriftCardSet>>
  _cardSetsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.cardSets,
    aliasName: 'cards__id__card_sets__card_id',
  );

  $$CardSetsTableProcessedTableManager get cardSetsRefs {
    final manager = $$CardSetsTableTableManager(
      $_db,
      $_db.cardSets,
    ).filter((f) => f.cardId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_cardSetsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BanlistInfosTable, List<DriftBanlistInfo>>
  _banlistInfosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.banlistInfos,
    aliasName: 'cards__id__banlist_infos__card_id',
  );

  $$BanlistInfosTableProcessedTableManager get banlistInfosRefs {
    final manager = $$BanlistInfosTableTableManager(
      $_db,
      $_db.banlistInfos,
    ).filter((f) => f.cardId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_banlistInfosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CollectionItemsTable, List<DriftCollectionItem>>
  _collectionItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.collectionItems,
    aliasName: 'cards__id__collection_items__card_id',
  );

  $$CollectionItemsTableProcessedTableManager get collectionItemsRefs {
    final manager = $$CollectionItemsTableTableManager(
      $_db,
      $_db.collectionItems,
    ).filter((f) => f.cardId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _collectionItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DeckCardsTable, List<DriftDeckCard>>
  _deckCardsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.deckCards,
    aliasName: 'cards__id__deck_cards__card_id',
  );

  $$DeckCardsTableProcessedTableManager get deckCardsRefs {
    final manager = $$DeckCardsTableTableManager(
      $_db,
      $_db.deckCards,
    ).filter((f) => f.cardId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_deckCardsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CardsTableFilterComposer extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get desc => $composableBuilder(
    column: $table.desc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get race => $composableBuilder(
    column: $table.race,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get frameType => $composableBuilder(
    column: $table.frameType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get humanReadableCardType => $composableBuilder(
    column: $table.humanReadableCardType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get atk => $composableBuilder(
    column: $table.atk,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get def => $composableBuilder(
    column: $table.def,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get attribute => $composableBuilder(
    column: $table.attribute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get archetype => $composableBuilder(
    column: $table.archetype,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get scale => $composableBuilder(
    column: $table.scale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get linkVal => $composableBuilder(
    column: $table.linkVal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ygoProDeckUrl => $composableBuilder(
    column: $table.ygoProDeckUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pendDesc => $composableBuilder(
    column: $table.pendDesc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get monsterDesc => $composableBuilder(
    column: $table.monsterDesc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get typeLineJson => $composableBuilder(
    column: $table.typeLineJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get linkMarkersJson => $composableBuilder(
    column: $table.linkMarkersJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get tcgDate => $composableBuilder(
    column: $table.tcgDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get ocgDate => $composableBuilder(
    column: $table.ocgDate,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> cardImagesRefs(
    Expression<bool> Function($$CardImagesTableFilterComposer f) f,
  ) {
    final $$CardImagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cardImages,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardImagesTableFilterComposer(
            $db: $db,
            $table: $db.cardImages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> cardPricesRefs(
    Expression<bool> Function($$CardPricesTableFilterComposer f) f,
  ) {
    final $$CardPricesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cardPrices,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardPricesTableFilterComposer(
            $db: $db,
            $table: $db.cardPrices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> cardSetsRefs(
    Expression<bool> Function($$CardSetsTableFilterComposer f) f,
  ) {
    final $$CardSetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cardSets,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardSetsTableFilterComposer(
            $db: $db,
            $table: $db.cardSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> banlistInfosRefs(
    Expression<bool> Function($$BanlistInfosTableFilterComposer f) f,
  ) {
    final $$BanlistInfosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.banlistInfos,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BanlistInfosTableFilterComposer(
            $db: $db,
            $table: $db.banlistInfos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> collectionItemsRefs(
    Expression<bool> Function($$CollectionItemsTableFilterComposer f) f,
  ) {
    final $$CollectionItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.collectionItems,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionItemsTableFilterComposer(
            $db: $db,
            $table: $db.collectionItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> deckCardsRefs(
    Expression<bool> Function($$DeckCardsTableFilterComposer f) f,
  ) {
    final $$DeckCardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.deckCards,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeckCardsTableFilterComposer(
            $db: $db,
            $table: $db.deckCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CardsTableOrderingComposer
    extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get desc => $composableBuilder(
    column: $table.desc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get race => $composableBuilder(
    column: $table.race,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frameType => $composableBuilder(
    column: $table.frameType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get humanReadableCardType => $composableBuilder(
    column: $table.humanReadableCardType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get atk => $composableBuilder(
    column: $table.atk,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get def => $composableBuilder(
    column: $table.def,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get attribute => $composableBuilder(
    column: $table.attribute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get archetype => $composableBuilder(
    column: $table.archetype,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get scale => $composableBuilder(
    column: $table.scale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get linkVal => $composableBuilder(
    column: $table.linkVal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ygoProDeckUrl => $composableBuilder(
    column: $table.ygoProDeckUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pendDesc => $composableBuilder(
    column: $table.pendDesc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get monsterDesc => $composableBuilder(
    column: $table.monsterDesc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get typeLineJson => $composableBuilder(
    column: $table.typeLineJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get linkMarkersJson => $composableBuilder(
    column: $table.linkMarkersJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get tcgDate => $composableBuilder(
    column: $table.tcgDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get ocgDate => $composableBuilder(
    column: $table.ocgDate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get desc =>
      $composableBuilder(column: $table.desc, builder: (column) => column);

  GeneratedColumn<String> get race =>
      $composableBuilder(column: $table.race, builder: (column) => column);

  GeneratedColumn<String> get frameType =>
      $composableBuilder(column: $table.frameType, builder: (column) => column);

  GeneratedColumn<String> get humanReadableCardType => $composableBuilder(
    column: $table.humanReadableCardType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get atk =>
      $composableBuilder(column: $table.atk, builder: (column) => column);

  GeneratedColumn<int> get def =>
      $composableBuilder(column: $table.def, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get attribute =>
      $composableBuilder(column: $table.attribute, builder: (column) => column);

  GeneratedColumn<String> get archetype =>
      $composableBuilder(column: $table.archetype, builder: (column) => column);

  GeneratedColumn<int> get scale =>
      $composableBuilder(column: $table.scale, builder: (column) => column);

  GeneratedColumn<int> get linkVal =>
      $composableBuilder(column: $table.linkVal, builder: (column) => column);

  GeneratedColumn<String> get ygoProDeckUrl => $composableBuilder(
    column: $table.ygoProDeckUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pendDesc =>
      $composableBuilder(column: $table.pendDesc, builder: (column) => column);

  GeneratedColumn<String> get monsterDesc => $composableBuilder(
    column: $table.monsterDesc,
    builder: (column) => column,
  );

  GeneratedColumn<String> get typeLineJson => $composableBuilder(
    column: $table.typeLineJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get linkMarkersJson => $composableBuilder(
    column: $table.linkMarkersJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get tcgDate =>
      $composableBuilder(column: $table.tcgDate, builder: (column) => column);

  GeneratedColumn<DateTime> get ocgDate =>
      $composableBuilder(column: $table.ocgDate, builder: (column) => column);

  Expression<T> cardImagesRefs<T extends Object>(
    Expression<T> Function($$CardImagesTableAnnotationComposer a) f,
  ) {
    final $$CardImagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cardImages,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardImagesTableAnnotationComposer(
            $db: $db,
            $table: $db.cardImages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> cardPricesRefs<T extends Object>(
    Expression<T> Function($$CardPricesTableAnnotationComposer a) f,
  ) {
    final $$CardPricesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cardPrices,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardPricesTableAnnotationComposer(
            $db: $db,
            $table: $db.cardPrices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> cardSetsRefs<T extends Object>(
    Expression<T> Function($$CardSetsTableAnnotationComposer a) f,
  ) {
    final $$CardSetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cardSets,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardSetsTableAnnotationComposer(
            $db: $db,
            $table: $db.cardSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> banlistInfosRefs<T extends Object>(
    Expression<T> Function($$BanlistInfosTableAnnotationComposer a) f,
  ) {
    final $$BanlistInfosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.banlistInfos,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BanlistInfosTableAnnotationComposer(
            $db: $db,
            $table: $db.banlistInfos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> collectionItemsRefs<T extends Object>(
    Expression<T> Function($$CollectionItemsTableAnnotationComposer a) f,
  ) {
    final $$CollectionItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.collectionItems,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.collectionItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> deckCardsRefs<T extends Object>(
    Expression<T> Function($$DeckCardsTableAnnotationComposer a) f,
  ) {
    final $$DeckCardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.deckCards,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeckCardsTableAnnotationComposer(
            $db: $db,
            $table: $db.deckCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CardsTable,
          DriftCard,
          $$CardsTableFilterComposer,
          $$CardsTableOrderingComposer,
          $$CardsTableAnnotationComposer,
          $$CardsTableCreateCompanionBuilder,
          $$CardsTableUpdateCompanionBuilder,
          (DriftCard, $$CardsTableReferences),
          DriftCard,
          PrefetchHooks Function({
            bool cardImagesRefs,
            bool cardPricesRefs,
            bool cardSetsRefs,
            bool banlistInfosRefs,
            bool collectionItemsRefs,
            bool deckCardsRefs,
          })
        > {
  $$CardsTableTableManager(_$AppDatabase db, $CardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> desc = const Value.absent(),
                Value<String> race = const Value.absent(),
                Value<String?> frameType = const Value.absent(),
                Value<String?> humanReadableCardType = const Value.absent(),
                Value<int?> atk = const Value.absent(),
                Value<int?> def = const Value.absent(),
                Value<int?> level = const Value.absent(),
                Value<String?> attribute = const Value.absent(),
                Value<String?> archetype = const Value.absent(),
                Value<int?> scale = const Value.absent(),
                Value<int?> linkVal = const Value.absent(),
                Value<String> ygoProDeckUrl = const Value.absent(),
                Value<String?> pendDesc = const Value.absent(),
                Value<String?> monsterDesc = const Value.absent(),
                Value<String?> typeLineJson = const Value.absent(),
                Value<String?> linkMarkersJson = const Value.absent(),
                Value<DateTime?> tcgDate = const Value.absent(),
                Value<DateTime?> ocgDate = const Value.absent(),
              }) => CardsCompanion(
                id: id,
                name: name,
                type: type,
                desc: desc,
                race: race,
                frameType: frameType,
                humanReadableCardType: humanReadableCardType,
                atk: atk,
                def: def,
                level: level,
                attribute: attribute,
                archetype: archetype,
                scale: scale,
                linkVal: linkVal,
                ygoProDeckUrl: ygoProDeckUrl,
                pendDesc: pendDesc,
                monsterDesc: monsterDesc,
                typeLineJson: typeLineJson,
                linkMarkersJson: linkMarkersJson,
                tcgDate: tcgDate,
                ocgDate: ocgDate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String type,
                required String desc,
                required String race,
                Value<String?> frameType = const Value.absent(),
                Value<String?> humanReadableCardType = const Value.absent(),
                Value<int?> atk = const Value.absent(),
                Value<int?> def = const Value.absent(),
                Value<int?> level = const Value.absent(),
                Value<String?> attribute = const Value.absent(),
                Value<String?> archetype = const Value.absent(),
                Value<int?> scale = const Value.absent(),
                Value<int?> linkVal = const Value.absent(),
                required String ygoProDeckUrl,
                Value<String?> pendDesc = const Value.absent(),
                Value<String?> monsterDesc = const Value.absent(),
                Value<String?> typeLineJson = const Value.absent(),
                Value<String?> linkMarkersJson = const Value.absent(),
                Value<DateTime?> tcgDate = const Value.absent(),
                Value<DateTime?> ocgDate = const Value.absent(),
              }) => CardsCompanion.insert(
                id: id,
                name: name,
                type: type,
                desc: desc,
                race: race,
                frameType: frameType,
                humanReadableCardType: humanReadableCardType,
                atk: atk,
                def: def,
                level: level,
                attribute: attribute,
                archetype: archetype,
                scale: scale,
                linkVal: linkVal,
                ygoProDeckUrl: ygoProDeckUrl,
                pendDesc: pendDesc,
                monsterDesc: monsterDesc,
                typeLineJson: typeLineJson,
                linkMarkersJson: linkMarkersJson,
                tcgDate: tcgDate,
                ocgDate: ocgDate,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$CardsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                cardImagesRefs = false,
                cardPricesRefs = false,
                cardSetsRefs = false,
                banlistInfosRefs = false,
                collectionItemsRefs = false,
                deckCardsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (cardImagesRefs) db.cardImages,
                    if (cardPricesRefs) db.cardPrices,
                    if (cardSetsRefs) db.cardSets,
                    if (banlistInfosRefs) db.banlistInfos,
                    if (collectionItemsRefs) db.collectionItems,
                    if (deckCardsRefs) db.deckCards,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (cardImagesRefs)
                        await $_getPrefetchedData<
                          DriftCard,
                          $CardsTable,
                          DriftCardImage
                        >(
                          currentTable: table,
                          referencedTable: $$CardsTableReferences
                              ._cardImagesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CardsTableReferences(
                                db,
                                table,
                                p0,
                              ).cardImagesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cardId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (cardPricesRefs)
                        await $_getPrefetchedData<
                          DriftCard,
                          $CardsTable,
                          DriftCardPrice
                        >(
                          currentTable: table,
                          referencedTable: $$CardsTableReferences
                              ._cardPricesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CardsTableReferences(
                                db,
                                table,
                                p0,
                              ).cardPricesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cardId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (cardSetsRefs)
                        await $_getPrefetchedData<
                          DriftCard,
                          $CardsTable,
                          DriftCardSet
                        >(
                          currentTable: table,
                          referencedTable: $$CardsTableReferences
                              ._cardSetsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CardsTableReferences(
                                db,
                                table,
                                p0,
                              ).cardSetsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cardId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (banlistInfosRefs)
                        await $_getPrefetchedData<
                          DriftCard,
                          $CardsTable,
                          DriftBanlistInfo
                        >(
                          currentTable: table,
                          referencedTable: $$CardsTableReferences
                              ._banlistInfosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CardsTableReferences(
                                db,
                                table,
                                p0,
                              ).banlistInfosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cardId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (collectionItemsRefs)
                        await $_getPrefetchedData<
                          DriftCard,
                          $CardsTable,
                          DriftCollectionItem
                        >(
                          currentTable: table,
                          referencedTable: $$CardsTableReferences
                              ._collectionItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CardsTableReferences(
                                db,
                                table,
                                p0,
                              ).collectionItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cardId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (deckCardsRefs)
                        await $_getPrefetchedData<
                          DriftCard,
                          $CardsTable,
                          DriftDeckCard
                        >(
                          currentTable: table,
                          referencedTable: $$CardsTableReferences
                              ._deckCardsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CardsTableReferences(
                                db,
                                table,
                                p0,
                              ).deckCardsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cardId == item.id,
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

typedef $$CardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CardsTable,
      DriftCard,
      $$CardsTableFilterComposer,
      $$CardsTableOrderingComposer,
      $$CardsTableAnnotationComposer,
      $$CardsTableCreateCompanionBuilder,
      $$CardsTableUpdateCompanionBuilder,
      (DriftCard, $$CardsTableReferences),
      DriftCard,
      PrefetchHooks Function({
        bool cardImagesRefs,
        bool cardPricesRefs,
        bool cardSetsRefs,
        bool banlistInfosRefs,
        bool collectionItemsRefs,
        bool deckCardsRefs,
      })
    >;
typedef $$CardImagesTableCreateCompanionBuilder = CardImagesCompanion Function({
  Value<int> id,
  required int cardId,
  required int imageId,
  required String imageUrl,
  required String imageUrlSmall,
  required String imageUrlCropped,
});
typedef $$CardImagesTableUpdateCompanionBuilder = CardImagesCompanion Function({
  Value<int> id,
  Value<int> cardId,
  Value<int> imageId,
  Value<String> imageUrl,
  Value<String> imageUrlSmall,
  Value<String> imageUrlCropped,
});

final class $$CardImagesTableReferences
    extends BaseReferences<_$AppDatabase, $CardImagesTable, DriftCardImage> {
  $$CardImagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CardsTable _cardIdTable(_$AppDatabase db) =>
      db.cards.createAlias('card_images__card_id__cards__id');

  $$CardsTableProcessedTableManager get cardId {
    final $_column = $_itemColumn<int>('card_id')!;

    final manager = $$CardsTableTableManager(
      $_db,
      $_db.cards,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cardIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CardImagesTableFilterComposer
    extends Composer<_$AppDatabase, $CardImagesTable> {
  $$CardImagesTableFilterComposer({
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

  ColumnFilters<int> get imageId => $composableBuilder(
    column: $table.imageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrlSmall => $composableBuilder(
    column: $table.imageUrlSmall,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrlCropped => $composableBuilder(
    column: $table.imageUrlCropped,
    builder: (column) => ColumnFilters(column),
  );

  $$CardsTableFilterComposer get cardId {
    final $$CardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.cards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardsTableFilterComposer(
            $db: $db,
            $table: $db.cards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CardImagesTableOrderingComposer
    extends Composer<_$AppDatabase, $CardImagesTable> {
  $$CardImagesTableOrderingComposer({
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

  ColumnOrderings<int> get imageId => $composableBuilder(
    column: $table.imageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrlSmall => $composableBuilder(
    column: $table.imageUrlSmall,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrlCropped => $composableBuilder(
    column: $table.imageUrlCropped,
    builder: (column) => ColumnOrderings(column),
  );

  $$CardsTableOrderingComposer get cardId {
    final $$CardsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.cards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardsTableOrderingComposer(
            $db: $db,
            $table: $db.cards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CardImagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardImagesTable> {
  $$CardImagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get imageId =>
      $composableBuilder(column: $table.imageId, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get imageUrlSmall => $composableBuilder(
    column: $table.imageUrlSmall,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageUrlCropped => $composableBuilder(
    column: $table.imageUrlCropped,
    builder: (column) => column,
  );

  $$CardsTableAnnotationComposer get cardId {
    final $$CardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.cards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardsTableAnnotationComposer(
            $db: $db,
            $table: $db.cards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CardImagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CardImagesTable,
          DriftCardImage,
          $$CardImagesTableFilterComposer,
          $$CardImagesTableOrderingComposer,
          $$CardImagesTableAnnotationComposer,
          $$CardImagesTableCreateCompanionBuilder,
          $$CardImagesTableUpdateCompanionBuilder,
          (DriftCardImage, $$CardImagesTableReferences),
          DriftCardImage,
          PrefetchHooks Function({bool cardId})
        > {
  $$CardImagesTableTableManager(_$AppDatabase db, $CardImagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardImagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardImagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardImagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> cardId = const Value.absent(),
                Value<int> imageId = const Value.absent(),
                Value<String> imageUrl = const Value.absent(),
                Value<String> imageUrlSmall = const Value.absent(),
                Value<String> imageUrlCropped = const Value.absent(),
              }) => CardImagesCompanion(
                id: id,
                cardId: cardId,
                imageId: imageId,
                imageUrl: imageUrl,
                imageUrlSmall: imageUrlSmall,
                imageUrlCropped: imageUrlCropped,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int cardId,
                required int imageId,
                required String imageUrl,
                required String imageUrlSmall,
                required String imageUrlCropped,
              }) => CardImagesCompanion.insert(
                id: id,
                cardId: cardId,
                imageId: imageId,
                imageUrl: imageUrl,
                imageUrlSmall: imageUrlSmall,
                imageUrlCropped: imageUrlCropped,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CardImagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({cardId = false}) {
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
                    if (cardId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.cardId,
                        referencedTable: $$CardImagesTableReferences
                            ._cardIdTable(db),
                        referencedColumn: $$CardImagesTableReferences
                            ._cardIdTable(db)
                            .id,
                      ) as T;
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

typedef $$CardImagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CardImagesTable,
      DriftCardImage,
      $$CardImagesTableFilterComposer,
      $$CardImagesTableOrderingComposer,
      $$CardImagesTableAnnotationComposer,
      $$CardImagesTableCreateCompanionBuilder,
      $$CardImagesTableUpdateCompanionBuilder,
      (DriftCardImage, $$CardImagesTableReferences),
      DriftCardImage,
      PrefetchHooks Function({bool cardId})
    >;
typedef $$CardPricesTableCreateCompanionBuilder = CardPricesCompanion Function({
  Value<int> id,
  required int cardId,
  Value<double?> cardMarketPrice,
  Value<double?> tcgPlayerPrice,
  Value<double?> ebayPrice,
  Value<double?> amazonPrice,
  Value<double?> coolStuffIncPrice,
});
typedef $$CardPricesTableUpdateCompanionBuilder = CardPricesCompanion Function({
  Value<int> id,
  Value<int> cardId,
  Value<double?> cardMarketPrice,
  Value<double?> tcgPlayerPrice,
  Value<double?> ebayPrice,
  Value<double?> amazonPrice,
  Value<double?> coolStuffIncPrice,
});

final class $$CardPricesTableReferences
    extends BaseReferences<_$AppDatabase, $CardPricesTable, DriftCardPrice> {
  $$CardPricesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CardsTable _cardIdTable(_$AppDatabase db) =>
      db.cards.createAlias('card_prices__card_id__cards__id');

  $$CardsTableProcessedTableManager get cardId {
    final $_column = $_itemColumn<int>('card_id')!;

    final manager = $$CardsTableTableManager(
      $_db,
      $_db.cards,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cardIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CardPricesTableFilterComposer
    extends Composer<_$AppDatabase, $CardPricesTable> {
  $$CardPricesTableFilterComposer({
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

  ColumnFilters<double> get cardMarketPrice => $composableBuilder(
    column: $table.cardMarketPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get tcgPlayerPrice => $composableBuilder(
    column: $table.tcgPlayerPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get ebayPrice => $composableBuilder(
    column: $table.ebayPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amazonPrice => $composableBuilder(
    column: $table.amazonPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get coolStuffIncPrice => $composableBuilder(
    column: $table.coolStuffIncPrice,
    builder: (column) => ColumnFilters(column),
  );

  $$CardsTableFilterComposer get cardId {
    final $$CardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.cards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardsTableFilterComposer(
            $db: $db,
            $table: $db.cards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CardPricesTableOrderingComposer
    extends Composer<_$AppDatabase, $CardPricesTable> {
  $$CardPricesTableOrderingComposer({
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

  ColumnOrderings<double> get cardMarketPrice => $composableBuilder(
    column: $table.cardMarketPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get tcgPlayerPrice => $composableBuilder(
    column: $table.tcgPlayerPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get ebayPrice => $composableBuilder(
    column: $table.ebayPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amazonPrice => $composableBuilder(
    column: $table.amazonPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get coolStuffIncPrice => $composableBuilder(
    column: $table.coolStuffIncPrice,
    builder: (column) => ColumnOrderings(column),
  );

  $$CardsTableOrderingComposer get cardId {
    final $$CardsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.cards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardsTableOrderingComposer(
            $db: $db,
            $table: $db.cards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CardPricesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardPricesTable> {
  $$CardPricesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get cardMarketPrice => $composableBuilder(
    column: $table.cardMarketPrice,
    builder: (column) => column,
  );

  GeneratedColumn<double> get tcgPlayerPrice => $composableBuilder(
    column: $table.tcgPlayerPrice,
    builder: (column) => column,
  );

  GeneratedColumn<double> get ebayPrice =>
      $composableBuilder(column: $table.ebayPrice, builder: (column) => column);

  GeneratedColumn<double> get amazonPrice => $composableBuilder(
    column: $table.amazonPrice,
    builder: (column) => column,
  );

  GeneratedColumn<double> get coolStuffIncPrice => $composableBuilder(
    column: $table.coolStuffIncPrice,
    builder: (column) => column,
  );

  $$CardsTableAnnotationComposer get cardId {
    final $$CardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.cards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardsTableAnnotationComposer(
            $db: $db,
            $table: $db.cards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CardPricesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CardPricesTable,
          DriftCardPrice,
          $$CardPricesTableFilterComposer,
          $$CardPricesTableOrderingComposer,
          $$CardPricesTableAnnotationComposer,
          $$CardPricesTableCreateCompanionBuilder,
          $$CardPricesTableUpdateCompanionBuilder,
          (DriftCardPrice, $$CardPricesTableReferences),
          DriftCardPrice,
          PrefetchHooks Function({bool cardId})
        > {
  $$CardPricesTableTableManager(_$AppDatabase db, $CardPricesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardPricesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardPricesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardPricesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> cardId = const Value.absent(),
                Value<double?> cardMarketPrice = const Value.absent(),
                Value<double?> tcgPlayerPrice = const Value.absent(),
                Value<double?> ebayPrice = const Value.absent(),
                Value<double?> amazonPrice = const Value.absent(),
                Value<double?> coolStuffIncPrice = const Value.absent(),
              }) => CardPricesCompanion(
                id: id,
                cardId: cardId,
                cardMarketPrice: cardMarketPrice,
                tcgPlayerPrice: tcgPlayerPrice,
                ebayPrice: ebayPrice,
                amazonPrice: amazonPrice,
                coolStuffIncPrice: coolStuffIncPrice,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int cardId,
                Value<double?> cardMarketPrice = const Value.absent(),
                Value<double?> tcgPlayerPrice = const Value.absent(),
                Value<double?> ebayPrice = const Value.absent(),
                Value<double?> amazonPrice = const Value.absent(),
                Value<double?> coolStuffIncPrice = const Value.absent(),
              }) => CardPricesCompanion.insert(
                id: id,
                cardId: cardId,
                cardMarketPrice: cardMarketPrice,
                tcgPlayerPrice: tcgPlayerPrice,
                ebayPrice: ebayPrice,
                amazonPrice: amazonPrice,
                coolStuffIncPrice: coolStuffIncPrice,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CardPricesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({cardId = false}) {
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
                    if (cardId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.cardId,
                        referencedTable: $$CardPricesTableReferences
                            ._cardIdTable(db),
                        referencedColumn: $$CardPricesTableReferences
                            ._cardIdTable(db)
                            .id,
                      ) as T;
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

typedef $$CardPricesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CardPricesTable,
      DriftCardPrice,
      $$CardPricesTableFilterComposer,
      $$CardPricesTableOrderingComposer,
      $$CardPricesTableAnnotationComposer,
      $$CardPricesTableCreateCompanionBuilder,
      $$CardPricesTableUpdateCompanionBuilder,
      (DriftCardPrice, $$CardPricesTableReferences),
      DriftCardPrice,
      PrefetchHooks Function({bool cardId})
    >;
typedef $$CardSetsTableCreateCompanionBuilder = CardSetsCompanion Function({
  Value<int> id,
  required int cardId,
  required String setName,
  required String setCode,
  required String setRarity,
  required String setRarityCode,
  Value<double?> setPrice,
});
typedef $$CardSetsTableUpdateCompanionBuilder = CardSetsCompanion Function({
  Value<int> id,
  Value<int> cardId,
  Value<String> setName,
  Value<String> setCode,
  Value<String> setRarity,
  Value<String> setRarityCode,
  Value<double?> setPrice,
});

final class $$CardSetsTableReferences
    extends BaseReferences<_$AppDatabase, $CardSetsTable, DriftCardSet> {
  $$CardSetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CardsTable _cardIdTable(_$AppDatabase db) =>
      db.cards.createAlias('card_sets__card_id__cards__id');

  $$CardsTableProcessedTableManager get cardId {
    final $_column = $_itemColumn<int>('card_id')!;

    final manager = $$CardsTableTableManager(
      $_db,
      $_db.cards,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cardIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CardSetsTableFilterComposer
    extends Composer<_$AppDatabase, $CardSetsTable> {
  $$CardSetsTableFilterComposer({
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

  ColumnFilters<String> get setName => $composableBuilder(
    column: $table.setName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get setCode => $composableBuilder(
    column: $table.setCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get setRarity => $composableBuilder(
    column: $table.setRarity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get setRarityCode => $composableBuilder(
    column: $table.setRarityCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get setPrice => $composableBuilder(
    column: $table.setPrice,
    builder: (column) => ColumnFilters(column),
  );

  $$CardsTableFilterComposer get cardId {
    final $$CardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.cards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardsTableFilterComposer(
            $db: $db,
            $table: $db.cards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CardSetsTableOrderingComposer
    extends Composer<_$AppDatabase, $CardSetsTable> {
  $$CardSetsTableOrderingComposer({
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

  ColumnOrderings<String> get setName => $composableBuilder(
    column: $table.setName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get setCode => $composableBuilder(
    column: $table.setCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get setRarity => $composableBuilder(
    column: $table.setRarity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get setRarityCode => $composableBuilder(
    column: $table.setRarityCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get setPrice => $composableBuilder(
    column: $table.setPrice,
    builder: (column) => ColumnOrderings(column),
  );

  $$CardsTableOrderingComposer get cardId {
    final $$CardsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.cards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardsTableOrderingComposer(
            $db: $db,
            $table: $db.cards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CardSetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardSetsTable> {
  $$CardSetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get setName =>
      $composableBuilder(column: $table.setName, builder: (column) => column);

  GeneratedColumn<String> get setCode =>
      $composableBuilder(column: $table.setCode, builder: (column) => column);

  GeneratedColumn<String> get setRarity =>
      $composableBuilder(column: $table.setRarity, builder: (column) => column);

  GeneratedColumn<String> get setRarityCode => $composableBuilder(
    column: $table.setRarityCode,
    builder: (column) => column,
  );

  GeneratedColumn<double> get setPrice =>
      $composableBuilder(column: $table.setPrice, builder: (column) => column);

  $$CardsTableAnnotationComposer get cardId {
    final $$CardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.cards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardsTableAnnotationComposer(
            $db: $db,
            $table: $db.cards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CardSetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CardSetsTable,
          DriftCardSet,
          $$CardSetsTableFilterComposer,
          $$CardSetsTableOrderingComposer,
          $$CardSetsTableAnnotationComposer,
          $$CardSetsTableCreateCompanionBuilder,
          $$CardSetsTableUpdateCompanionBuilder,
          (DriftCardSet, $$CardSetsTableReferences),
          DriftCardSet,
          PrefetchHooks Function({bool cardId})
        > {
  $$CardSetsTableTableManager(_$AppDatabase db, $CardSetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardSetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardSetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardSetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> cardId = const Value.absent(),
                Value<String> setName = const Value.absent(),
                Value<String> setCode = const Value.absent(),
                Value<String> setRarity = const Value.absent(),
                Value<String> setRarityCode = const Value.absent(),
                Value<double?> setPrice = const Value.absent(),
              }) => CardSetsCompanion(
                id: id,
                cardId: cardId,
                setName: setName,
                setCode: setCode,
                setRarity: setRarity,
                setRarityCode: setRarityCode,
                setPrice: setPrice,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int cardId,
                required String setName,
                required String setCode,
                required String setRarity,
                required String setRarityCode,
                Value<double?> setPrice = const Value.absent(),
              }) => CardSetsCompanion.insert(
                id: id,
                cardId: cardId,
                setName: setName,
                setCode: setCode,
                setRarity: setRarity,
                setRarityCode: setRarityCode,
                setPrice: setPrice,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CardSetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({cardId = false}) {
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
                    if (cardId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.cardId,
                        referencedTable: $$CardSetsTableReferences._cardIdTable(
                          db,
                        ),
                        referencedColumn: $$CardSetsTableReferences
                            ._cardIdTable(db)
                            .id,
                      ) as T;
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

typedef $$CardSetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CardSetsTable,
      DriftCardSet,
      $$CardSetsTableFilterComposer,
      $$CardSetsTableOrderingComposer,
      $$CardSetsTableAnnotationComposer,
      $$CardSetsTableCreateCompanionBuilder,
      $$CardSetsTableUpdateCompanionBuilder,
      (DriftCardSet, $$CardSetsTableReferences),
      DriftCardSet,
      PrefetchHooks Function({bool cardId})
    >;
typedef $$BanlistInfosTableCreateCompanionBuilder =
    BanlistInfosCompanion Function({
      Value<int> cardId,
      Value<String?> banTcg,
      Value<String?> banOcg,
      Value<String?> banGoat,
      Value<String?> banEdison,
    });
typedef $$BanlistInfosTableUpdateCompanionBuilder =
    BanlistInfosCompanion Function({
      Value<int> cardId,
      Value<String?> banTcg,
      Value<String?> banOcg,
      Value<String?> banGoat,
      Value<String?> banEdison,
    });

final class $$BanlistInfosTableReferences
    extends
        BaseReferences<_$AppDatabase, $BanlistInfosTable, DriftBanlistInfo> {
  $$BanlistInfosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CardsTable _cardIdTable(_$AppDatabase db) =>
      db.cards.createAlias('banlist_infos__card_id__cards__id');

  $$CardsTableProcessedTableManager get cardId {
    final $_column = $_itemColumn<int>('card_id')!;

    final manager = $$CardsTableTableManager(
      $_db,
      $_db.cards,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cardIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BanlistInfosTableFilterComposer
    extends Composer<_$AppDatabase, $BanlistInfosTable> {
  $$BanlistInfosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get banTcg => $composableBuilder(
    column: $table.banTcg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get banOcg => $composableBuilder(
    column: $table.banOcg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get banGoat => $composableBuilder(
    column: $table.banGoat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get banEdison => $composableBuilder(
    column: $table.banEdison,
    builder: (column) => ColumnFilters(column),
  );

  $$CardsTableFilterComposer get cardId {
    final $$CardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.cards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardsTableFilterComposer(
            $db: $db,
            $table: $db.cards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BanlistInfosTableOrderingComposer
    extends Composer<_$AppDatabase, $BanlistInfosTable> {
  $$BanlistInfosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get banTcg => $composableBuilder(
    column: $table.banTcg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get banOcg => $composableBuilder(
    column: $table.banOcg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get banGoat => $composableBuilder(
    column: $table.banGoat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get banEdison => $composableBuilder(
    column: $table.banEdison,
    builder: (column) => ColumnOrderings(column),
  );

  $$CardsTableOrderingComposer get cardId {
    final $$CardsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.cards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardsTableOrderingComposer(
            $db: $db,
            $table: $db.cards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BanlistInfosTableAnnotationComposer
    extends Composer<_$AppDatabase, $BanlistInfosTable> {
  $$BanlistInfosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get banTcg =>
      $composableBuilder(column: $table.banTcg, builder: (column) => column);

  GeneratedColumn<String> get banOcg =>
      $composableBuilder(column: $table.banOcg, builder: (column) => column);

  GeneratedColumn<String> get banGoat =>
      $composableBuilder(column: $table.banGoat, builder: (column) => column);

  GeneratedColumn<String> get banEdison =>
      $composableBuilder(column: $table.banEdison, builder: (column) => column);

  $$CardsTableAnnotationComposer get cardId {
    final $$CardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.cards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardsTableAnnotationComposer(
            $db: $db,
            $table: $db.cards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BanlistInfosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BanlistInfosTable,
          DriftBanlistInfo,
          $$BanlistInfosTableFilterComposer,
          $$BanlistInfosTableOrderingComposer,
          $$BanlistInfosTableAnnotationComposer,
          $$BanlistInfosTableCreateCompanionBuilder,
          $$BanlistInfosTableUpdateCompanionBuilder,
          (DriftBanlistInfo, $$BanlistInfosTableReferences),
          DriftBanlistInfo,
          PrefetchHooks Function({bool cardId})
        > {
  $$BanlistInfosTableTableManager(_$AppDatabase db, $BanlistInfosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BanlistInfosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BanlistInfosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BanlistInfosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> cardId = const Value.absent(),
                Value<String?> banTcg = const Value.absent(),
                Value<String?> banOcg = const Value.absent(),
                Value<String?> banGoat = const Value.absent(),
                Value<String?> banEdison = const Value.absent(),
              }) => BanlistInfosCompanion(
                cardId: cardId,
                banTcg: banTcg,
                banOcg: banOcg,
                banGoat: banGoat,
                banEdison: banEdison,
              ),
          createCompanionCallback:
              ({
                Value<int> cardId = const Value.absent(),
                Value<String?> banTcg = const Value.absent(),
                Value<String?> banOcg = const Value.absent(),
                Value<String?> banGoat = const Value.absent(),
                Value<String?> banEdison = const Value.absent(),
              }) => BanlistInfosCompanion.insert(
                cardId: cardId,
                banTcg: banTcg,
                banOcg: banOcg,
                banGoat: banGoat,
                banEdison: banEdison,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BanlistInfosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({cardId = false}) {
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
                    if (cardId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.cardId,
                        referencedTable: $$BanlistInfosTableReferences
                            ._cardIdTable(db),
                        referencedColumn: $$BanlistInfosTableReferences
                            ._cardIdTable(db)
                            .id,
                      ) as T;
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

typedef $$BanlistInfosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BanlistInfosTable,
      DriftBanlistInfo,
      $$BanlistInfosTableFilterComposer,
      $$BanlistInfosTableOrderingComposer,
      $$BanlistInfosTableAnnotationComposer,
      $$BanlistInfosTableCreateCompanionBuilder,
      $$BanlistInfosTableUpdateCompanionBuilder,
      (DriftBanlistInfo, $$BanlistInfosTableReferences),
      DriftBanlistInfo,
      PrefetchHooks Function({bool cardId})
    >;
typedef $$CollectionItemsTableCreateCompanionBuilder =
    CollectionItemsCompanion Function({
      Value<int> id,
      required int cardId,
      required String setCode,
      required String rarity,
      Value<int> collectionNumber,
      Value<int> quantity,
      Value<String> condition,
      Value<String> language,
      Value<bool> isFirstEdition,
      Value<double?> priceAtPurchase,
      Value<String?> notes,
      Value<DateTime> addedAt,
      Value<DateTime> updatedAt,
    });
typedef $$CollectionItemsTableUpdateCompanionBuilder =
    CollectionItemsCompanion Function({
      Value<int> id,
      Value<int> cardId,
      Value<String> setCode,
      Value<String> rarity,
      Value<int> collectionNumber,
      Value<int> quantity,
      Value<String> condition,
      Value<String> language,
      Value<bool> isFirstEdition,
      Value<double?> priceAtPurchase,
      Value<String?> notes,
      Value<DateTime> addedAt,
      Value<DateTime> updatedAt,
    });

final class $$CollectionItemsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CollectionItemsTable,
          DriftCollectionItem
        > {
  $$CollectionItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CardsTable _cardIdTable(_$AppDatabase db) =>
      db.cards.createAlias('collection_items__card_id__cards__id');

  $$CardsTableProcessedTableManager get cardId {
    final $_column = $_itemColumn<int>('card_id')!;

    final manager = $$CardsTableTableManager(
      $_db,
      $_db.cards,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cardIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CollectionItemsTableFilterComposer
    extends Composer<_$AppDatabase, $CollectionItemsTable> {
  $$CollectionItemsTableFilterComposer({
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

  ColumnFilters<String> get setCode => $composableBuilder(
    column: $table.setCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rarity => $composableBuilder(
    column: $table.rarity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get collectionNumber => $composableBuilder(
    column: $table.collectionNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get condition => $composableBuilder(
    column: $table.condition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFirstEdition => $composableBuilder(
    column: $table.isFirstEdition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get priceAtPurchase => $composableBuilder(
    column: $table.priceAtPurchase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CardsTableFilterComposer get cardId {
    final $$CardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.cards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardsTableFilterComposer(
            $db: $db,
            $table: $db.cards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CollectionItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $CollectionItemsTable> {
  $$CollectionItemsTableOrderingComposer({
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

  ColumnOrderings<String> get setCode => $composableBuilder(
    column: $table.setCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rarity => $composableBuilder(
    column: $table.rarity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get collectionNumber => $composableBuilder(
    column: $table.collectionNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get condition => $composableBuilder(
    column: $table.condition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFirstEdition => $composableBuilder(
    column: $table.isFirstEdition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get priceAtPurchase => $composableBuilder(
    column: $table.priceAtPurchase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CardsTableOrderingComposer get cardId {
    final $$CardsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.cards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardsTableOrderingComposer(
            $db: $db,
            $table: $db.cards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CollectionItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CollectionItemsTable> {
  $$CollectionItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get setCode =>
      $composableBuilder(column: $table.setCode, builder: (column) => column);

  GeneratedColumn<String> get rarity =>
      $composableBuilder(column: $table.rarity, builder: (column) => column);

  GeneratedColumn<int> get collectionNumber => $composableBuilder(
    column: $table.collectionNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get condition =>
      $composableBuilder(column: $table.condition, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<bool> get isFirstEdition => $composableBuilder(
    column: $table.isFirstEdition,
    builder: (column) => column,
  );

  GeneratedColumn<double> get priceAtPurchase => $composableBuilder(
    column: $table.priceAtPurchase,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CardsTableAnnotationComposer get cardId {
    final $$CardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.cards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardsTableAnnotationComposer(
            $db: $db,
            $table: $db.cards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CollectionItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CollectionItemsTable,
          DriftCollectionItem,
          $$CollectionItemsTableFilterComposer,
          $$CollectionItemsTableOrderingComposer,
          $$CollectionItemsTableAnnotationComposer,
          $$CollectionItemsTableCreateCompanionBuilder,
          $$CollectionItemsTableUpdateCompanionBuilder,
          (DriftCollectionItem, $$CollectionItemsTableReferences),
          DriftCollectionItem,
          PrefetchHooks Function({bool cardId})
        > {
  $$CollectionItemsTableTableManager(
    _$AppDatabase db,
    $CollectionItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CollectionItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CollectionItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CollectionItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> cardId = const Value.absent(),
                Value<String> setCode = const Value.absent(),
                Value<String> rarity = const Value.absent(),
                Value<int> collectionNumber = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<String> condition = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<bool> isFirstEdition = const Value.absent(),
                Value<double?> priceAtPurchase = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CollectionItemsCompanion(
                id: id,
                cardId: cardId,
                setCode: setCode,
                rarity: rarity,
                collectionNumber: collectionNumber,
                quantity: quantity,
                condition: condition,
                language: language,
                isFirstEdition: isFirstEdition,
                priceAtPurchase: priceAtPurchase,
                notes: notes,
                addedAt: addedAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int cardId,
                required String setCode,
                required String rarity,
                Value<int> collectionNumber = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<String> condition = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<bool> isFirstEdition = const Value.absent(),
                Value<double?> priceAtPurchase = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CollectionItemsCompanion.insert(
                id: id,
                cardId: cardId,
                setCode: setCode,
                rarity: rarity,
                collectionNumber: collectionNumber,
                quantity: quantity,
                condition: condition,
                language: language,
                isFirstEdition: isFirstEdition,
                priceAtPurchase: priceAtPurchase,
                notes: notes,
                addedAt: addedAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CollectionItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({cardId = false}) {
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
                    if (cardId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.cardId,
                        referencedTable: $$CollectionItemsTableReferences
                            ._cardIdTable(db),
                        referencedColumn: $$CollectionItemsTableReferences
                            ._cardIdTable(db)
                            .id,
                      ) as T;
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

typedef $$CollectionItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CollectionItemsTable,
      DriftCollectionItem,
      $$CollectionItemsTableFilterComposer,
      $$CollectionItemsTableOrderingComposer,
      $$CollectionItemsTableAnnotationComposer,
      $$CollectionItemsTableCreateCompanionBuilder,
      $$CollectionItemsTableUpdateCompanionBuilder,
      (DriftCollectionItem, $$CollectionItemsTableReferences),
      DriftCollectionItem,
      PrefetchHooks Function({bool cardId})
    >;
typedef $$AppConfigTableCreateCompanionBuilder = AppConfigCompanion Function({
  required String settingKey,
  Value<String?> settingValue,
  Value<int> rowid,
});
typedef $$AppConfigTableUpdateCompanionBuilder = AppConfigCompanion Function({
  Value<String> settingKey,
  Value<String?> settingValue,
  Value<int> rowid,
});

class $$AppConfigTableFilterComposer
    extends Composer<_$AppDatabase, $AppConfigTable> {
  $$AppConfigTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get settingKey => $composableBuilder(
    column: $table.settingKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get settingValue => $composableBuilder(
    column: $table.settingValue,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppConfigTableOrderingComposer
    extends Composer<_$AppDatabase, $AppConfigTable> {
  $$AppConfigTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get settingKey => $composableBuilder(
    column: $table.settingKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get settingValue => $composableBuilder(
    column: $table.settingValue,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppConfigTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppConfigTable> {
  $$AppConfigTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get settingKey => $composableBuilder(
    column: $table.settingKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get settingValue => $composableBuilder(
    column: $table.settingValue,
    builder: (column) => column,
  );
}

class $$AppConfigTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppConfigTable,
          DriftAppConfig,
          $$AppConfigTableFilterComposer,
          $$AppConfigTableOrderingComposer,
          $$AppConfigTableAnnotationComposer,
          $$AppConfigTableCreateCompanionBuilder,
          $$AppConfigTableUpdateCompanionBuilder,
          (
            DriftAppConfig,
            BaseReferences<_$AppDatabase, $AppConfigTable, DriftAppConfig>,
          ),
          DriftAppConfig,
          PrefetchHooks Function()
        > {
  $$AppConfigTableTableManager(_$AppDatabase db, $AppConfigTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppConfigTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppConfigTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppConfigTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> settingKey = const Value.absent(),
                Value<String?> settingValue = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppConfigCompanion(
                settingKey: settingKey,
                settingValue: settingValue,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String settingKey,
                Value<String?> settingValue = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppConfigCompanion.insert(
                settingKey: settingKey,
                settingValue: settingValue,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppConfigTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppConfigTable,
      DriftAppConfig,
      $$AppConfigTableFilterComposer,
      $$AppConfigTableOrderingComposer,
      $$AppConfigTableAnnotationComposer,
      $$AppConfigTableCreateCompanionBuilder,
      $$AppConfigTableUpdateCompanionBuilder,
      (
        DriftAppConfig,
        BaseReferences<_$AppDatabase, $AppConfigTable, DriftAppConfig>,
      ),
      DriftAppConfig,
      PrefetchHooks Function()
    >;
typedef $$DecksTableCreateCompanionBuilder = DecksCompanion Function({
  Value<int> id,
  required String name,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$DecksTableUpdateCompanionBuilder = DecksCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$DecksTableReferences
    extends BaseReferences<_$AppDatabase, $DecksTable, DriftDeck> {
  $$DecksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DeckCardsTable, List<DriftDeckCard>>
  _deckCardsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.deckCards,
    aliasName: 'decks__id__deck_cards__deck_id',
  );

  $$DeckCardsTableProcessedTableManager get deckCardsRefs {
    final manager = $$DeckCardsTableTableManager(
      $_db,
      $_db.deckCards,
    ).filter((f) => f.deckId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_deckCardsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DecksTableFilterComposer extends Composer<_$AppDatabase, $DecksTable> {
  $$DecksTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
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

  Expression<bool> deckCardsRefs(
    Expression<bool> Function($$DeckCardsTableFilterComposer f) f,
  ) {
    final $$DeckCardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.deckCards,
      getReferencedColumn: (t) => t.deckId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeckCardsTableFilterComposer(
            $db: $db,
            $table: $db.deckCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DecksTableOrderingComposer
    extends Composer<_$AppDatabase, $DecksTable> {
  $$DecksTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
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

class $$DecksTableAnnotationComposer
    extends Composer<_$AppDatabase, $DecksTable> {
  $$DecksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> deckCardsRefs<T extends Object>(
    Expression<T> Function($$DeckCardsTableAnnotationComposer a) f,
  ) {
    final $$DeckCardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.deckCards,
      getReferencedColumn: (t) => t.deckId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeckCardsTableAnnotationComposer(
            $db: $db,
            $table: $db.deckCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DecksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DecksTable,
          DriftDeck,
          $$DecksTableFilterComposer,
          $$DecksTableOrderingComposer,
          $$DecksTableAnnotationComposer,
          $$DecksTableCreateCompanionBuilder,
          $$DecksTableUpdateCompanionBuilder,
          (DriftDeck, $$DecksTableReferences),
          DriftDeck,
          PrefetchHooks Function({bool deckCardsRefs})
        > {
  $$DecksTableTableManager(_$AppDatabase db, $DecksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DecksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DecksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DecksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => DecksCompanion(
                id: id,
                name: name,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => DecksCompanion.insert(
                id: id,
                name: name,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$DecksTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({deckCardsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (deckCardsRefs) db.deckCards],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (deckCardsRefs)
                    await $_getPrefetchedData<
                      DriftDeck,
                      $DecksTable,
                      DriftDeckCard
                    >(
                      currentTable: table,
                      referencedTable: $$DecksTableReferences
                          ._deckCardsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$DecksTableReferences(db, table, p0).deckCardsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.deckId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$DecksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DecksTable,
      DriftDeck,
      $$DecksTableFilterComposer,
      $$DecksTableOrderingComposer,
      $$DecksTableAnnotationComposer,
      $$DecksTableCreateCompanionBuilder,
      $$DecksTableUpdateCompanionBuilder,
      (DriftDeck, $$DecksTableReferences),
      DriftDeck,
      PrefetchHooks Function({bool deckCardsRefs})
    >;
typedef $$DeckCardsTableCreateCompanionBuilder = DeckCardsCompanion Function({
  Value<int> id,
  required int deckId,
  required int cardId,
  required String category,
});
typedef $$DeckCardsTableUpdateCompanionBuilder = DeckCardsCompanion Function({
  Value<int> id,
  Value<int> deckId,
  Value<int> cardId,
  Value<String> category,
});

final class $$DeckCardsTableReferences
    extends BaseReferences<_$AppDatabase, $DeckCardsTable, DriftDeckCard> {
  $$DeckCardsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DecksTable _deckIdTable(_$AppDatabase db) =>
      db.decks.createAlias('deck_cards__deck_id__decks__id');

  $$DecksTableProcessedTableManager get deckId {
    final $_column = $_itemColumn<int>('deck_id')!;

    final manager = $$DecksTableTableManager(
      $_db,
      $_db.decks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_deckIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CardsTable _cardIdTable(_$AppDatabase db) =>
      db.cards.createAlias('deck_cards__card_id__cards__id');

  $$CardsTableProcessedTableManager get cardId {
    final $_column = $_itemColumn<int>('card_id')!;

    final manager = $$CardsTableTableManager(
      $_db,
      $_db.cards,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cardIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DeckCardsTableFilterComposer
    extends Composer<_$AppDatabase, $DeckCardsTable> {
  $$DeckCardsTableFilterComposer({
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

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  $$DecksTableFilterComposer get deckId {
    final $$DecksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deckId,
      referencedTable: $db.decks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DecksTableFilterComposer(
            $db: $db,
            $table: $db.decks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CardsTableFilterComposer get cardId {
    final $$CardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.cards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardsTableFilterComposer(
            $db: $db,
            $table: $db.cards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DeckCardsTableOrderingComposer
    extends Composer<_$AppDatabase, $DeckCardsTable> {
  $$DeckCardsTableOrderingComposer({
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

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  $$DecksTableOrderingComposer get deckId {
    final $$DecksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deckId,
      referencedTable: $db.decks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DecksTableOrderingComposer(
            $db: $db,
            $table: $db.decks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CardsTableOrderingComposer get cardId {
    final $$CardsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.cards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardsTableOrderingComposer(
            $db: $db,
            $table: $db.cards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DeckCardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DeckCardsTable> {
  $$DeckCardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  $$DecksTableAnnotationComposer get deckId {
    final $$DecksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deckId,
      referencedTable: $db.decks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DecksTableAnnotationComposer(
            $db: $db,
            $table: $db.decks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CardsTableAnnotationComposer get cardId {
    final $$CardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.cards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardsTableAnnotationComposer(
            $db: $db,
            $table: $db.cards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DeckCardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DeckCardsTable,
          DriftDeckCard,
          $$DeckCardsTableFilterComposer,
          $$DeckCardsTableOrderingComposer,
          $$DeckCardsTableAnnotationComposer,
          $$DeckCardsTableCreateCompanionBuilder,
          $$DeckCardsTableUpdateCompanionBuilder,
          (DriftDeckCard, $$DeckCardsTableReferences),
          DriftDeckCard,
          PrefetchHooks Function({bool deckId, bool cardId})
        > {
  $$DeckCardsTableTableManager(_$AppDatabase db, $DeckCardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DeckCardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DeckCardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DeckCardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> deckId = const Value.absent(),
                Value<int> cardId = const Value.absent(),
                Value<String> category = const Value.absent(),
              }) => DeckCardsCompanion(
                id: id,
                deckId: deckId,
                cardId: cardId,
                category: category,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int deckId,
                required int cardId,
                required String category,
              }) => DeckCardsCompanion.insert(
                id: id,
                deckId: deckId,
                cardId: cardId,
                category: category,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DeckCardsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({deckId = false, cardId = false}) {
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
                    if (deckId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.deckId,
                        referencedTable: $$DeckCardsTableReferences
                            ._deckIdTable(db),
                        referencedColumn: $$DeckCardsTableReferences
                            ._deckIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (cardId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.cardId,
                        referencedTable: $$DeckCardsTableReferences
                            ._cardIdTable(db),
                        referencedColumn: $$DeckCardsTableReferences
                            ._cardIdTable(db)
                            .id,
                      ) as T;
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

typedef $$DeckCardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DeckCardsTable,
      DriftDeckCard,
      $$DeckCardsTableFilterComposer,
      $$DeckCardsTableOrderingComposer,
      $$DeckCardsTableAnnotationComposer,
      $$DeckCardsTableCreateCompanionBuilder,
      $$DeckCardsTableUpdateCompanionBuilder,
      (DriftDeckCard, $$DeckCardsTableReferences),
      DriftDeckCard,
      PrefetchHooks Function({bool deckId, bool cardId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CardsTableTableManager get cards =>
      $$CardsTableTableManager(_db, _db.cards);
  $$CardImagesTableTableManager get cardImages =>
      $$CardImagesTableTableManager(_db, _db.cardImages);
  $$CardPricesTableTableManager get cardPrices =>
      $$CardPricesTableTableManager(_db, _db.cardPrices);
  $$CardSetsTableTableManager get cardSets =>
      $$CardSetsTableTableManager(_db, _db.cardSets);
  $$BanlistInfosTableTableManager get banlistInfos =>
      $$BanlistInfosTableTableManager(_db, _db.banlistInfos);
  $$CollectionItemsTableTableManager get collectionItems =>
      $$CollectionItemsTableTableManager(_db, _db.collectionItems);
  $$AppConfigTableTableManager get appConfig =>
      $$AppConfigTableTableManager(_db, _db.appConfig);
  $$DecksTableTableManager get decks =>
      $$DecksTableTableManager(_db, _db.decks);
  $$DeckCardsTableTableManager get deckCards =>
      $$DeckCardsTableTableManager(_db, _db.deckCards);
}
