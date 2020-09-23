import 'package:equatable/equatable.dart';
import 'package:Headlines/src/models/articles_model.dart';

abstract class SearchState extends Equatable {}

class SearchLoading extends SearchState {
  @override
  List<Object> get props => ["SearchLoading"];
}

class SearchInit extends SearchState {
  final List<String> keys;
  SearchInit({this.keys});
  @override
  List<Object> get props => [this.keys];
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
  @override
  List<Object> get props => [this.message];
}

class GlobalSearchResultsObtained extends SearchState {
  final List<ArticlesModel> newsModel;
  final String query;

  GlobalSearchResultsObtained(this.newsModel, this.query);

  @override
  List<Object> get props => [this.newsModel, this.query];
}
