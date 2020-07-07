import 'package:equatable/equatable.dart';

abstract class NewsEvent extends Equatable {}

class FetchTopHeadlines extends NewsEvent {
  final String country;

  FetchTopHeadlines(this.country);

  @override
  List<Object> get props => [this.country];
}
