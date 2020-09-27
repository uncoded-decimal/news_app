import 'package:equatable/equatable.dart';

abstract class NewsEvent extends Equatable {}

class FetchTopHeadlines extends NewsEvent {
  final String country;

  FetchTopHeadlines(this.country);

  @override
  List<Object> get props => [this.country];
}

class FetchTechnologyHeadlines extends NewsEvent {
  final String country;

  FetchTechnologyHeadlines(this.country);

  @override
  List<Object> get props => [this.country];
}

class FetchScienceHeadlines extends NewsEvent {
  final String country;

  FetchScienceHeadlines(this.country);

  @override
  List<Object> get props => [this.country];
}

class FetchHealthHeadlines extends NewsEvent {
  final String country;

  FetchHealthHeadlines(this.country);

  @override
  List<Object> get props => [this.country];
}

class FetchSportsHeadlines extends NewsEvent {
  final String country;

  FetchSportsHeadlines(this.country);

  @override
  List<Object> get props => [this.country];
}

class FetchBusinessHeadlines extends NewsEvent {
  final String country;

  FetchBusinessHeadlines(this.country);

  @override
  List<Object> get props => [this.country];
}

class FetchEntertainmentHeadlines extends NewsEvent {
  final String country;

  FetchEntertainmentHeadlines(this.country);

  @override
  List<Object> get props => [this.country];
}
