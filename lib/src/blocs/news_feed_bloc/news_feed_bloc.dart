import 'package:news_app/src/blocs/news_feed_bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/src/models/model.dart';
import 'package:quiver/strings.dart';

class NewsFeedBloc extends Bloc<NewsFeedEvent, NewsFeedState> {
  List<ArticlesModel> _articles;

  NewsFeedBloc(this._articles) : super(FeedLoading());

  @override
  Stream<NewsFeedState> mapEventToState(NewsFeedEvent event) async* {
    if (event is ShowDefaultFeed) {
      yield DefaultFeed(
          articles: this._articles, topic: "Showing default feed");
    } else if (event is SearchFeed) {
      yield* _performSearch(event.query);
    }
  }

  Stream<NewsFeedState> _performSearch(String query) async* {
    List<ArticlesModel> searchResults = [];
    this._articles.forEach((element) {
      if (_hasResult(element.title, query) ||
          _hasResult(element.content, query) ||
          _hasResult(element.description, query)) {
        searchResults.add(element);
      }
    });
    if (searchResults.length == 0) {
      yield SearchResults(
          articles: searchResults,
          query: 'No articles were found for this query');
    } else {
      yield SearchResults(
          articles: searchResults, query: 'Showing results for $query');
    }
  }

  bool _hasResult(String text, String query) {
    if (isBlank(text)) {
      return false;
    } else {
      return text.toLowerCase().contains(query.toLowerCase());
    }
  }
}
