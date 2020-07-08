import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class NewsFeedEvent extends Equatable{}

class ShowDefaultFeed extends NewsFeedEvent{
  @override
  List<Object> get props => ["Show default feed"];
}

class ShowRecents extends NewsFeedEvent{
  @override
  List<Object> get props => ["Show recents first"];
}

class SearchFeed extends NewsFeedEvent{
  final String query;
  SearchFeed({@required this.query});
  @override
  List<Object> get props => [this.query];
}

class FilterFeed extends NewsFeedEvent{
  final String selectedSource;
  FilterFeed({@required this.selectedSource});
  @override
  List<Object> get props => [this.selectedSource];
}

class RemoveFilter extends NewsFeedEvent{
  final String selectedSource;
  RemoveFilter({@required this.selectedSource});
  @override
  List<Object> get props => [this.selectedSource];
}