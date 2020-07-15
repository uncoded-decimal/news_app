import 'package:equatable/equatable.dart';
import 'package:Headlines/src/models/articles_model.dart';

abstract class NewsFeedState extends Equatable {}

class FeedLoading extends NewsFeedState {
  @override
  List<Object> get props => ["Feed Loading"];
}

class DefaultFeed extends NewsFeedState {
  final String topic;
  final List<ArticlesModel> articles;
  final Map<String, bool> articleSources;
  DefaultFeed({
    this.topic,
    this.articles,
    this.articleSources,
  });
  @override
  List<Object> get props => [
        this.topic,
        this.articles,
        this.articleSources,
      ];
}

class OperatedFeed extends NewsFeedState {
  final String topic;
  final List<ArticlesModel> articles;
  final Map<String, bool> articleSources;
  OperatedFeed({
    this.topic,
    this.articles,
    this.articleSources,
  });
  @override
  List<Object> get props => [
        this.topic,
        this.articles,
        this.articleSources,
      ];
}
