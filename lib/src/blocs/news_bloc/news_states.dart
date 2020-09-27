import 'package:equatable/equatable.dart';
import 'package:Headlines/src/models/model.dart';

abstract class NewsState extends Equatable {}

class FeedLoading extends NewsState {
  @override
  List<Object> get props => ["FeedLoading"];
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

class HealthHeadlinesFetched extends NewsState {
  final List<ArticlesModel> newsModel;
  final String country;

  HealthHeadlinesFetched(this.newsModel, this.country);

  @override
  List<Object> get props => [this.newsModel, this.country];
}

class SportsHeadlinesFetched extends NewsState {
  final List<ArticlesModel> newsModel;
  final String country;

  SportsHeadlinesFetched(this.newsModel, this.country);

  @override
  List<Object> get props => [this.newsModel, this.country];
}

class ScienceHeadlinesFetched extends NewsState {
  final List<ArticlesModel> newsModel;
  final String country;

  ScienceHeadlinesFetched(this.newsModel, this.country);

  @override
  List<Object> get props => [this.newsModel, this.country];
}

class TechnologyHeadlinesFetched extends NewsState {
  final List<ArticlesModel> newsModel;
  final String country;

  TechnologyHeadlinesFetched(this.newsModel, this.country);

  @override
  List<Object> get props => [this.newsModel, this.country];
}

class BusinessHeadlinesFetched extends NewsState {
  final List<ArticlesModel> newsModel;
  final String country;

  BusinessHeadlinesFetched(this.newsModel, this.country);

  @override
  List<Object> get props => [this.newsModel, this.country];
}

class EntertainmentHeadlinesFetched extends NewsState {
  final List<ArticlesModel> newsModel;
  final String country;

  EntertainmentHeadlinesFetched(this.newsModel, this.country);

  @override
  List<Object> get props => [this.newsModel, this.country];
}
