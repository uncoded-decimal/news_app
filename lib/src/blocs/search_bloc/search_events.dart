import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {}

class FetchSearchResults extends SearchEvent {
  final String query;
  FetchSearchResults(this.query);
  @override
  List<Object> get props => [this.query];
}

class InitSearch extends SearchEvent {
  @override
  List<Object> get props => ["InitSearch"];
}
