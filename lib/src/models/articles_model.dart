library articles;

import 'dart:convert';

import 'package:news_app/src/models/model.dart';

import 'serializers.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'articles_model.g.dart';

abstract class ArticlesModel
    implements Built<ArticlesModel, ArticlesModelBuilder> {
  ArticlesModel._();

  factory ArticlesModel([updates(ArticlesModelBuilder b)]) = _$ArticlesModel;

  @BuiltValueField(wireName: 'source')
  SourceModel get source;
  @nullable
  @BuiltValueField(wireName: 'author')
  String get author;
  @BuiltValueField(wireName: 'title')
  String get title;
  @nullable
  @BuiltValueField(wireName: 'description')
  String get description;
  @nullable
  @BuiltValueField(wireName: 'url')
  String get url;
  @nullable
  @BuiltValueField(wireName: 'urlToImage')
  String get urlToImage;
  @BuiltValueField(wireName: 'publishedAt')
  String get publishedAt;
  @nullable
  @BuiltValueField(wireName: 'content')
  String get content;
  String toJson() {
    return json
        .encode(serializers.serializeWith(ArticlesModel.serializer, this));
  }

  static ArticlesModel fromJson(String jsonString) {
    return serializers.deserializeWith(
        ArticlesModel.serializer, json.decode(jsonString));
  }

  static ArticlesModel fromMap(Map<String, dynamic> data) {
    if (data == null) return null;
    final content = serializers.deserializeWith(ArticlesModel.serializer, data);
    return content;
  }

  static Serializer<ArticlesModel> get serializer => _$articlesModelSerializer;
}
