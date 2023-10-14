// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'milk_data.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMilkRecordCollection on Isar {
  IsarCollection<MilkRecord> get milkRecords => this.collection();
}

const MilkRecordSchema = CollectionSchema(
  name: r'MilkRecord',
  id: -8463935901784821570,
  properties: {
    r'date': PropertySchema(
      id: 0,
      name: r'date',
      type: IsarType.string,
    ),
    r'hashId': PropertySchema(
      id: 1,
      name: r'hashId',
      type: IsarType.string,
    ),
    r'shift': PropertySchema(
      id: 2,
      name: r'shift',
      type: IsarType.byte,
      enumMap: _MilkRecordshiftEnumValueMap,
    ),
    r'totalLitres': PropertySchema(
      id: 3,
      name: r'totalLitres',
      type: IsarType.double,
    ),
    r'uuid': PropertySchema(
      id: 4,
      name: r'uuid',
      type: IsarType.string,
    )
  },
  estimateSize: _milkRecordEstimateSize,
  serialize: _milkRecordSerialize,
  deserialize: _milkRecordDeserialize,
  deserializeProp: _milkRecordDeserializeProp,
  idName: r'id',
  indexes: {
    r'hashId': IndexSchema(
      id: -7070364231115312276,
      name: r'hashId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'hashId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _milkRecordGetId,
  getLinks: _milkRecordGetLinks,
  attach: _milkRecordAttach,
  version: '3.1.0+1',
);

int _milkRecordEstimateSize(
  MilkRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.date.length * 3;
  bytesCount += 3 + object.hashId.length * 3;
  bytesCount += 3 + object.uuid.length * 3;
  return bytesCount;
}

void _milkRecordSerialize(
  MilkRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.date);
  writer.writeString(offsets[1], object.hashId);
  writer.writeByte(offsets[2], object.shift.index);
  writer.writeDouble(offsets[3], object.totalLitres);
  writer.writeString(offsets[4], object.uuid);
}

MilkRecord _milkRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MilkRecord(
    date: reader.readString(offsets[0]),
    shift: _MilkRecordshiftValueEnumMap[reader.readByteOrNull(offsets[2])] ??
        Shift.morning,
    totalLitres: reader.readDouble(offsets[3]),
    uuid: reader.readString(offsets[4]),
  );
  object.id = id;
  return object;
}

P _milkRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (_MilkRecordshiftValueEnumMap[reader.readByteOrNull(offset)] ??
          Shift.morning) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _MilkRecordshiftEnumValueMap = {
  'morning': 0,
  'evening': 1,
};
const _MilkRecordshiftValueEnumMap = {
  0: Shift.morning,
  1: Shift.evening,
};

Id _milkRecordGetId(MilkRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _milkRecordGetLinks(MilkRecord object) {
  return [];
}

void _milkRecordAttach(IsarCollection<dynamic> col, Id id, MilkRecord object) {
  object.id = id;
}

extension MilkRecordByIndex on IsarCollection<MilkRecord> {
  Future<MilkRecord?> getByHashId(String hashId) {
    return getByIndex(r'hashId', [hashId]);
  }

  MilkRecord? getByHashIdSync(String hashId) {
    return getByIndexSync(r'hashId', [hashId]);
  }

  Future<bool> deleteByHashId(String hashId) {
    return deleteByIndex(r'hashId', [hashId]);
  }

  bool deleteByHashIdSync(String hashId) {
    return deleteByIndexSync(r'hashId', [hashId]);
  }

  Future<List<MilkRecord?>> getAllByHashId(List<String> hashIdValues) {
    final values = hashIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'hashId', values);
  }

  List<MilkRecord?> getAllByHashIdSync(List<String> hashIdValues) {
    final values = hashIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'hashId', values);
  }

  Future<int> deleteAllByHashId(List<String> hashIdValues) {
    final values = hashIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'hashId', values);
  }

  int deleteAllByHashIdSync(List<String> hashIdValues) {
    final values = hashIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'hashId', values);
  }

  Future<Id> putByHashId(MilkRecord object) {
    return putByIndex(r'hashId', object);
  }

  Id putByHashIdSync(MilkRecord object, {bool saveLinks = true}) {
    return putByIndexSync(r'hashId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByHashId(List<MilkRecord> objects) {
    return putAllByIndex(r'hashId', objects);
  }

  List<Id> putAllByHashIdSync(List<MilkRecord> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'hashId', objects, saveLinks: saveLinks);
  }
}

extension MilkRecordQueryWhereSort
    on QueryBuilder<MilkRecord, MilkRecord, QWhere> {
  QueryBuilder<MilkRecord, MilkRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MilkRecordQueryWhere
    on QueryBuilder<MilkRecord, MilkRecord, QWhereClause> {
  QueryBuilder<MilkRecord, MilkRecord, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterWhereClause> hashIdEqualTo(
      String hashId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'hashId',
        value: [hashId],
      ));
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterWhereClause> hashIdNotEqualTo(
      String hashId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'hashId',
              lower: [],
              upper: [hashId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'hashId',
              lower: [hashId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'hashId',
              lower: [hashId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'hashId',
              lower: [],
              upper: [hashId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension MilkRecordQueryFilter
    on QueryBuilder<MilkRecord, MilkRecord, QFilterCondition> {
  QueryBuilder<MilkRecord, MilkRecord, QAfterFilterCondition> dateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterFilterCondition> dateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterFilterCondition> dateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterFilterCondition> dateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterFilterCondition> dateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterFilterCondition> dateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterFilterCondition> dateContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterFilterCondition> dateMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'date',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterFilterCondition> dateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: '',
      ));
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterFilterCondition> dateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'date',
        value: '',
      ));
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterFilterCondition> hashIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterFilterCondition> hashIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hashId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterFilterCondition> hashIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hashId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterFilterCondition> hashIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hashId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterFilterCondition> hashIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'hashId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterFilterCondition> hashIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'hashId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterFilterCondition> hashIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'hashId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterFilterCondition> hashIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'hashId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterFilterCondition> hashIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashId',
        value: '',
      ));
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterFilterCondition>
      hashIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'hashId',
        value: '',
      ));
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterFilterCondition> shiftEqualTo(
      Shift value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shift',
        value: value,
      ));
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterFilterCondition> shiftGreaterThan(
    Shift value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'shift',
        value: value,
      ));
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterFilterCondition> shiftLessThan(
    Shift value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'shift',
        value: value,
      ));
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterFilterCondition> shiftBetween(
    Shift lower,
    Shift upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'shift',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterFilterCondition>
      totalLitresEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalLitres',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterFilterCondition>
      totalLitresGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalLitres',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterFilterCondition>
      totalLitresLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalLitres',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterFilterCondition>
      totalLitresBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalLitres',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterFilterCondition> uuidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterFilterCondition> uuidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterFilterCondition> uuidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterFilterCondition> uuidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uuid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterFilterCondition> uuidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterFilterCondition> uuidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterFilterCondition> uuidContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterFilterCondition> uuidMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uuid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterFilterCondition> uuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: '',
      ));
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterFilterCondition> uuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uuid',
        value: '',
      ));
    });
  }
}

extension MilkRecordQueryObject
    on QueryBuilder<MilkRecord, MilkRecord, QFilterCondition> {}

extension MilkRecordQueryLinks
    on QueryBuilder<MilkRecord, MilkRecord, QFilterCondition> {}

extension MilkRecordQuerySortBy
    on QueryBuilder<MilkRecord, MilkRecord, QSortBy> {
  QueryBuilder<MilkRecord, MilkRecord, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterSortBy> sortByHashId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashId', Sort.asc);
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterSortBy> sortByHashIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashId', Sort.desc);
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterSortBy> sortByShift() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shift', Sort.asc);
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterSortBy> sortByShiftDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shift', Sort.desc);
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterSortBy> sortByTotalLitres() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalLitres', Sort.asc);
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterSortBy> sortByTotalLitresDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalLitres', Sort.desc);
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterSortBy> sortByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterSortBy> sortByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension MilkRecordQuerySortThenBy
    on QueryBuilder<MilkRecord, MilkRecord, QSortThenBy> {
  QueryBuilder<MilkRecord, MilkRecord, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterSortBy> thenByHashId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashId', Sort.asc);
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterSortBy> thenByHashIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashId', Sort.desc);
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterSortBy> thenByShift() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shift', Sort.asc);
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterSortBy> thenByShiftDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shift', Sort.desc);
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterSortBy> thenByTotalLitres() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalLitres', Sort.asc);
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterSortBy> thenByTotalLitresDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalLitres', Sort.desc);
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterSortBy> thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QAfterSortBy> thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension MilkRecordQueryWhereDistinct
    on QueryBuilder<MilkRecord, MilkRecord, QDistinct> {
  QueryBuilder<MilkRecord, MilkRecord, QDistinct> distinctByDate(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QDistinct> distinctByHashId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hashId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QDistinct> distinctByShift() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shift');
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QDistinct> distinctByTotalLitres() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalLitres');
    });
  }

  QueryBuilder<MilkRecord, MilkRecord, QDistinct> distinctByUuid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uuid', caseSensitive: caseSensitive);
    });
  }
}

extension MilkRecordQueryProperty
    on QueryBuilder<MilkRecord, MilkRecord, QQueryProperty> {
  QueryBuilder<MilkRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MilkRecord, String, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<MilkRecord, String, QQueryOperations> hashIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hashId');
    });
  }

  QueryBuilder<MilkRecord, Shift, QQueryOperations> shiftProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shift');
    });
  }

  QueryBuilder<MilkRecord, double, QQueryOperations> totalLitresProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalLitres');
    });
  }

  QueryBuilder<MilkRecord, String, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }
}
