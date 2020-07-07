library source;

import 'dart:convert';

import 'serializers.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'source_model.g.dart';

abstract class SourceModel implements Built<SourceModel, SourceModelBuilder> {
  SourceModel._();

  factory SourceModel([updates(SourceModelBuilder b)]) = _$SourceModel;

  @nullable
  @BuiltValueField(wireName: 'id')
  String get id;
  @BuiltValueField(wireName: 'name')
  String get name;
  String toJson() {
    return json.encode(serializers.serializeWith(SourceModel.serializer, this));
  }

  static SourceModel fromJson(String jsonString) {
    return serializers.deserializeWith(
        SourceModel.serializer, json.decode(jsonString));
  }

  static Serializer<SourceModel> get serializer => _$sourceModelSerializer;
}
