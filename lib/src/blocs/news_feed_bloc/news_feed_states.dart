import 'package:equatable/equatable.dart';
import 'package:news_app/src/models/articles_model.dart';

abstract class NewsFeedState extends Equatable {}

class FeedLoading extends NewsFeedState {
  @override
  List<Object> get props => ["Feed Loading"];
}

class DefaultFeed extends NewsFeedState {
  final String topic;
  final List<ArticlesModel> articles;
  DefaultFeed({
    this.topic,
    this.articles,
  });
  @override
  List<Object> get props => [this.topic, this.articles];
}

class SearchResults extends NewsFeedState {
  final String query;
  final List<ArticlesModel> articles;
  SearchResults({
    this.query,
    this.articles,
  });
  @override
  List<Object> get props => [this.query, this.articles];
}
