import 'package:equatable/equatable.dart';

abstract class NewsEvent extends Equatable {}

class FetchTopheadlines extends NewsEvent {
  final String country;

  FetchTopheadlines(this.country);

  @override
  List<Object> get props => [this.country];
}

class FetchTechnologyheadlines extends NewsEvent {
  final String country;

  FetchTechnologyheadlines(this.country);

  @override
  List<Object> get props => [this.country];
}

class FetchScienceheadlines extends NewsEvent {
  final String country;

  FetchScienceheadlines(this.country);

  @override
  List<Object> get props => [this.country];
}

class FetchHealthheadlines extends NewsEvent {
  final String country;

  FetchHealthheadlines(this.country);

  @override
  List<Object> get props => [this.country];
}

class FetchSportsheadlines extends NewsEvent {
  final String country;

  FetchSportsheadlines(this.country);

  @override
  List<Object> get props => [this.country];
}

class FetchBusinessheadlines extends NewsEvent {
  final String country;

  FetchBusinessheadlines(this.country);

  @override
  List<Object> get props => [this.country];
}

class FetchEntertainmentheadlines extends NewsEvent {
  final String country;

  FetchEntertainmentheadlines(this.country);

  @override
  List<Object> get props => [this.country];
}
