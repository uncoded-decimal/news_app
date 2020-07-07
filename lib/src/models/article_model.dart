library article_model;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:news_app/src/models/news_source_model.dart';

import 'serializers.dart';


part 'article_model.g.dart';

abstract class ArticleModel
    implements Built<ArticleModel, ArticleModelBuilder> {
  ArticleModel._();

  factory ArticleModel([updates(ArticleModelBuilder b)]) = _$ArticleModel;

  @BuiltValueField(wireName: 'source')
  NewsSourceModel get source;
  @BuiltValueField(wireName: 'author')
  String get author;
  @BuiltValueField(wireName: 'title')
  String get title;
  @BuiltValueField(wireName: 'description')
  String get description;
  @BuiltValueField(wireName: 'url')
  String get url;
  @BuiltValueField(wireName: 'urlToImage')
  String get urlToImage;
  @BuiltValueField(wireName: 'publishedAt')
  String get publishedAt;
  @BuiltValueField(wireName: 'content')
  String get content;
  String toJson() {
    return json
        .encode(serializers.serializeWith(ArticleModel.serializer, this));
  }

  static ArticleModel fromJson(String jsonString) {
    return serializers.deserializeWith(
        ArticleModel.serializer, json.decode(jsonString));
  }

  static ArticleModel fromMap(Map<String, dynamic> data) {
    if (data == null) return null;
    final map = Map.from(data);
    final user = serializers.deserializeWith(ArticleModel.serializer, map);
    return user;
  }

  Map<String, dynamic> toMap() {
    return serializers.serializeWith(ArticleModel.serializer, this) as Map;
  }

  static Serializer<ArticleModel> get serializer => _$articleModelSerializer;
}