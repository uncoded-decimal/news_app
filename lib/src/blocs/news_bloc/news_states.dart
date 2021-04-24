import 'package:equatable/equatable.dart';
import 'package:headlines/src/models/model.dart';

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

class TopheadlinesFetched extends NewsState {
  final List<ArticlesModel> newsModel;
  final String country;

  TopheadlinesFetched(this.newsModel, this.country);

  @override
  List<Object> get props => [this.newsModel, this.country];
}

class HealthheadlinesFetched extends NewsState {
  final List<ArticlesModel> newsModel;
  final String country;

  HealthheadlinesFetched(this.newsModel, this.country);

  @override
  List<Object> get props => [this.newsModel, this.country];
}

class SportsheadlinesFetched extends NewsState {
  final List<ArticlesModel> newsModel;
  final String country;

  SportsheadlinesFetched(this.newsModel, this.country);

  @override
  List<Object> get props => [this.newsModel, this.country];
}

class ScienceheadlinesFetched extends NewsState {
  final List<ArticlesModel> newsModel;
  final String country;

  ScienceheadlinesFetched(this.newsModel, this.country);

  @override
  List<Object> get props => [this.newsModel, this.country];
}

class TechnologyheadlinesFetched extends NewsState {
  final List<ArticlesModel> newsModel;
  final String country;

  TechnologyheadlinesFetched(this.newsModel, this.country);

  @override
  List<Object> get props => [this.newsModel, this.country];
}

class BusinessheadlinesFetched extends NewsState {
  final List<ArticlesModel> newsModel;
  final String country;

  BusinessheadlinesFetched(this.newsModel, this.country);

  @override
  List<Object> get props => [this.newsModel, this.country];
}

class EntertainmentheadlinesFetched extends NewsState {
  final List<ArticlesModel> newsModel;
  final String country;

  EntertainmentheadlinesFetched(this.newsModel, this.country);

  @override
  List<Object> get props => [this.newsModel, this.country];
}
