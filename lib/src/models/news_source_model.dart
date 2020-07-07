import 'dart:convert';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'serializers.dart';


part 'news_source_model.g.dart';

abstract class NewsSourceModel
    implements Built<NewsSourceModel, NewsSourceModelBuilder> {
  NewsSourceModel._();

  factory NewsSourceModel([updates(NewsSourceModelBuilder b)]) =
      _$NewsSourceModel;

  @nullable
  @BuiltValueField(wireName: 'id')
  String get id;
  @BuiltValueField(wireName: 'name')
  String get name;
  String toJson() {
    return json
        .encode(serializers.serializeWith(NewsSourceModel.serializer, this));
  }

  static NewsSourceModel fromJson(String jsonString) {
    return serializers.deserializeWith(
        NewsSourceModel.serializer, json.decode(jsonString));
  }

  static Serializer<NewsSourceModel> get serializer =>
      _$newsSourceModelSerializer;

  static NewsSourceModel fromMap(Map<String, dynamic> data) {
    if (data == null) return null;
    final map = Map.from(data);
    final user = serializers.deserializeWith(NewsSourceModel.serializer, map);
    return user;
  }

  Map<String, dynamic> toMap() {
    return serializers.serializeWith(NewsSourceModel.serializer, this) as Map;
  }
}
