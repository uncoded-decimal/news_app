import 'package:equatable/equatable.dart';
import 'package:news_app/src/models/model.dart';

abstract class NewsState extends Equatable {}

class Loading extends NewsState {
  @override
  List<Object> get props => ["Loading"];
}

class Error extends NewsState {
  final String errorMessage;

  Error(this.errorMessage);

  @override
  List<Object> get props => [this.errorMessage];
}

class TopHeadlinesFetched extends NewsState {
  final List<ArticlesModel> newsModel;
  final String country;

  TopHeadlinesFetched(this.newsModel, this.country);

  @override
  List<Object> get props => [this.newsModel, this.country];
}
