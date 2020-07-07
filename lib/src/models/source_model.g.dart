// GENERATED CODE - DO NOT MODIFY BY HAND

part of source;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<SourceModel> _$sourceModelSerializer = new _$SourceModelSerializer();

class _$SourceModelSerializer implements StructuredSerializer<SourceModel> {
  @override
  final Iterable<Type> types = const [SourceModel, _$SourceModel];
  @override
  final String wireName = 'SourceModel';

  @override
  Iterable<Object> serialize(Serializers serializers, SourceModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
    ];
    if (object.id != null) {
      result
        ..add('id')
        ..add(serializers.serialize(object.id,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  SourceModel deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SourceModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$SourceModel extends SourceModel {
  @override
  final String id;
  @override
  final String name;

  factory _$SourceModel([void Function(SourceModelBuilder) updates]) =>
      (new SourceModelBuilder()..update(updates)).build();

  _$SourceModel._({this.id, this.name}) : super._() {
    if (name == null) {
      throw new BuiltValueNullFieldError('SourceModel', 'name');
    }
  }

  @override
  SourceModel rebuild(void Function(SourceModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SourceModelBuilder toBuilder() => new SourceModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SourceModel && id == other.id && name == other.name;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, id.hashCode), name.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('SourceModel')
          ..add('id', id)
          ..add('name', name))
        .toString();
  }
}

class SourceModelBuilder implements Builder<SourceModel, SourceModelBuilder> {
  _$SourceModel _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  SourceModelBuilder();

  SourceModelBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _name = _$v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SourceModel other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$SourceModel;
  }

  @override
  void update(void Function(SourceModelBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$SourceModel build() {
    final _$result = _$v ?? new _$SourceModel._(id: id, name: name);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
