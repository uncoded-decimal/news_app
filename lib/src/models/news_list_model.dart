
import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:news_app/src/models/article_model.dart';

import 'serializers.dart';


part 'news_list_model.g.dart';

abstract class NewsListModel
    implements Built<NewsListModel, NewsListModelBuilder> {
  NewsListModel._();

  factory NewsListModel([updates(NewsListModelBuilder b)]) = _$NewsListModel;

  @BuiltValueField(wireName: 'status')
  String get status;
  @BuiltValueField(wireName: 'totalResults')
  int get totalResults;
  @BuiltValueField(wireName: 'articles')
  BuiltList<ArticleModel> get articles;
  String toJson() {
    return json
        .encode(serializers.serializeWith(NewsListModel.serializer, this));
  }

  static NewsListModel fromJson(String jsonString) {
    return serializers.deserializeWith(
        NewsListModel.serializer, json.decode(jsonString));
  }

  static NewsListModel fromMap(Map<String, dynamic> data) {
    if (data == null) return null;
    final map = Map.from(data);
    final user = serializers.deserializeWith(NewsListModel.serializer, map);
    return user;
  }

  Map<String, dynamic> toMap() {
    return serializers.serializeWith(NewsListModel.serializer, this) as Map;
  }

  static Serializer<NewsListModel> get serializer => _$newsListModelSerializer;
}