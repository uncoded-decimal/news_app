// GENERATED CODE - DO NOT MODIFY BY HAND

part of article_model;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ArticleModel> _$articleModelSerializer =
    new _$ArticleModelSerializer();

class _$ArticleModelSerializer implements StructuredSerializer<ArticleModel> {
  @override
  final Iterable<Type> types = const [ArticleModel, _$ArticleModel];
  @override
  final String wireName = 'ArticleModel';

  @override
  Iterable<Object> serialize(Serializers serializers, ArticleModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'source',
      serializers.serialize(object.source,
          specifiedType: const FullType(NewsSourceModel)),
      'author',
      serializers.serialize(object.author,
          specifiedType: const FullType(String)),
      'title',
      serializers.serialize(object.title,
          specifiedType: const FullType(String)),
      'description',
      serializers.serialize(object.description,
          specifiedType: const FullType(String)),
      'url',
      serializers.serialize(object.url, specifiedType: const FullType(String)),
      'urlToImage',
      serializers.serialize(object.urlToImage,
          specifiedType: const FullType(String)),
      'publishedAt',
      serializers.serialize(object.publishedAt,
          specifiedType: const FullType(String)),
      'content',
      serializers.serialize(object.content,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  ArticleModel deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ArticleModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'source':
          result.source.replace(serializers.deserialize(value,
                  specifiedType: const FullType(NewsSourceModel))
              as NewsSourceModel);
          break;
        case 'author':
          result.author = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'title':
          result.title = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'description':
          result.description = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'url':
          result.url = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'urlToImage':
          result.urlToImage = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'publishedAt':
          result.publishedAt = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'content':
          result.content = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$ArticleModel extends ArticleModel {
  @override
  final NewsSourceModel source;
  @override
  final String author;
  @override
  final String title;
  @override
  final String description;
  @override
  final String url;
  @override
  final String urlToImage;
  @override
  final String publishedAt;
  @override
  final String content;

  factory _$ArticleModel([void Function(ArticleModelBuilder) updates]) =>
      (new ArticleModelBuilder()..update(updates)).build();

  _$ArticleModel._(
      {this.source,
      this.author,
      this.title,
      this.description,
      this.url,
      this.urlToImage,
      this.publishedAt,
      this.content})
      : super._() {
    if (source == null) {
      throw new BuiltValueNullFieldError('ArticleModel', 'source');
    }
    if (author == null) {
      throw new BuiltValueNullFieldError('ArticleModel', 'author');
    }
    if (title == null) {
      throw new BuiltValueNullFieldError('ArticleModel', 'title');
    }
    if (description == null) {
      throw new BuiltValueNullFieldError('ArticleModel', 'description');
    }
    if (url == null) {
      throw new BuiltValueNullFieldError('ArticleModel', 'url');
    }
    if (urlToImage == null) {
      throw new BuiltValueNullFieldError('ArticleModel', 'urlToImage');
    }
    if (publishedAt == null) {
      throw new BuiltValueNullFieldError('ArticleModel', 'publishedAt');
    }
    if (content == null) {
      throw new BuiltValueNullFieldError('ArticleModel', 'content');
    }
  }

  @override
  ArticleModel rebuild(void Function(ArticleModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ArticleModelBuilder toBuilder() => new ArticleModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ArticleModel &&
        source == other.source &&
        author == other.author &&
        title == other.title &&
        description == other.description &&
        url == other.url &&
        urlToImage == other.urlToImage &&
        publishedAt == other.publishedAt &&
        content == other.content;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc($jc($jc(0, source.hashCode), author.hashCode),
                            title.hashCode),
                        description.hashCode),
                    url.hashCode),
                urlToImage.hashCode),
            publishedAt.hashCode),
        content.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ArticleModel')
          ..add('source', source)
          ..add('author', author)
          ..add('title', title)
          ..add('description', description)
          ..add('url', url)
          ..add('urlToImage', urlToImage)
          ..add('publishedAt', publishedAt)
          ..add('content', content))
        .toString();
  }
}

class ArticleModelBuilder
    implements Builder<ArticleModel, ArticleModelBuilder> {
  _$ArticleModel _$v;

  NewsSourceModelBuilder _source;
  NewsSourceModelBuilder get source =>
      _$this._source ??= new NewsSourceModelBuilder();
  set source(NewsSourceModelBuilder source) => _$this._source = source;

  String _author;
  String get author => _$this._author;
  set author(String author) => _$this._author = author;

  String _title;
  String get title => _$this._title;
  set title(String title) => _$this._title = title;

  String _description;
  String get description => _$this._description;
  set description(String description) => _$this._description = description;

  String _url;
  String get url => _$this._url;
  set url(String url) => _$this._url = url;

  String _urlToImage;
  String get urlToImage => _$this._urlToImage;
  set urlToImage(String urlToImage) => _$this._urlToImage = urlToImage;

  String _publishedAt;
  String get publishedAt => _$this._publishedAt;
  set publishedAt(String publishedAt) => _$this._publishedAt = publishedAt;

  String _content;
  String get content => _$this._content;
  set content(String content) => _$this._content = content;

  ArticleModelBuilder();

  ArticleModelBuilder get _$this {
    if (_$v != null) {
      _source = _$v.source?.toBuilder();
      _author = _$v.author;
      _title = _$v.title;
      _description = _$v.description;
      _url = _$v.url;
      _urlToImage = _$v.urlToImage;
      _publishedAt = _$v.publishedAt;
      _content = _$v.content;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ArticleModel other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$ArticleModel;
  }

  @override
  void update(void Function(ArticleModelBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ArticleModel build() {
    _$ArticleModel _$result;
    try {
      _$result = _$v ??
          new _$ArticleModel._(
              source: source.build(),
              author: author,
              title: title,
              description: description,
              url: url,
              urlToImage: urlToImage,
              publishedAt: publishedAt,
              content: content);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'source';
        source.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'ArticleModel', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
