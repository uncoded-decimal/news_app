// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_list_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<NewsListModel> _$newsListModelSerializer =
    new _$NewsListModelSerializer();

class _$NewsListModelSerializer implements StructuredSerializer<NewsListModel> {
  @override
  final Iterable<Type> types = const [NewsListModel, _$NewsListModel];
  @override
  final String wireName = 'NewsListModel';

  @override
  Iterable<Object> serialize(Serializers serializers, NewsListModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'status',
      serializers.serialize(object.status,
          specifiedType: const FullType(String)),
      'totalResults',
      serializers.serialize(object.totalResults,
          specifiedType: const FullType(int)),
      'articles',
      serializers.serialize(object.articles,
          specifiedType:
              const FullType(BuiltList, const [const FullType(ArticleModel)])),
    ];

    return result;
  }

  @override
  NewsListModel deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new NewsListModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'status':
          result.status = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'totalResults':
          result.totalResults = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'articles':
          result.articles.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(ArticleModel)]))
              as BuiltList<Object>);
          break;
      }
    }

    return result.build();
  }
}

class _$NewsListModel extends NewsListModel {
  @override
  final String status;
  @override
  final int totalResults;
  @override
  final BuiltList<ArticleModel> articles;

  factory _$NewsListModel([void Function(NewsListModelBuilder) updates]) =>
      (new NewsListModelBuilder()..update(updates)).build();

  _$NewsListModel._({this.status, this.totalResults, this.articles})
      : super._() {
    if (status == null) {
      throw new BuiltValueNullFieldError('NewsListModel', 'status');
    }
    if (totalResults == null) {
      throw new BuiltValueNullFieldError('NewsListModel', 'totalResults');
    }
    if (articles == null) {
      throw new BuiltValueNullFieldError('NewsListModel', 'articles');
    }
  }

  @override
  NewsListModel rebuild(void Function(NewsListModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NewsListModelBuilder toBuilder() => new NewsListModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NewsListModel &&
        status == other.status &&
        totalResults == other.totalResults &&
        articles == other.articles;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc(0, status.hashCode), totalResults.hashCode),
        articles.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('NewsListModel')
          ..add('status', status)
          ..add('totalResults', totalResults)
          ..add('articles', articles))
        .toString();
  }
}

class NewsListModelBuilder
    implements Builder<NewsListModel, NewsListModelBuilder> {
  _$NewsListModel _$v;

  String _status;
  String get status => _$this._status;
  set status(String status) => _$this._status = status;

  int _totalResults;
  int get totalResults => _$this._totalResults;
  set totalResults(int totalResults) => _$this._totalResults = totalResults;

  ListBuilder<ArticleModel> _articles;
  ListBuilder<ArticleModel> get articles =>
      _$this._articles ??= new ListBuilder<ArticleModel>();
  set articles(ListBuilder<ArticleModel> articles) =>
      _$this._articles = articles;

  NewsListModelBuilder();

  NewsListModelBuilder get _$this {
    if (_$v != null) {
      _status = _$v.status;
      _totalResults = _$v.totalResults;
      _articles = _$v.articles?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NewsListModel other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$NewsListModel;
  }

  @override
  void update(void Function(NewsListModelBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$NewsListModel build() {
    _$NewsListModel _$result;
    try {
      _$result = _$v ??
          new _$NewsListModel._(
              status: status,
              totalResults: totalResults,
              articles: articles.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'articles';
        articles.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'NewsListModel', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
