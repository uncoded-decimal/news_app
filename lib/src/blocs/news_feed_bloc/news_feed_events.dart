import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class NewsFeedEvent extends Equatable{}

class ShowDefaultFeed extends NewsFeedEvent{
  @override
  List<Object> get props => ["Show default feed"];
}

class SearchFeed extends NewsFeedEvent{
  final String query;
  SearchFeed({@required this.query});
  @override
  List<Object> get props => [this.query];
}