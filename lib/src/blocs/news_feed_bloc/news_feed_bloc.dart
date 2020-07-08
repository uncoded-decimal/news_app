import 'package:news_app/src/blocs/news_feed_bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/src/models/model.dart';
import 'package:quiver/strings.dart';

class NewsFeedBloc extends Bloc<NewsFeedEvent, NewsFeedState> {
  List<ArticlesModel> _articles;
  List<ArticlesModel> _listToShow;
  Map<String, bool> _articleSources = {};

  NewsFeedBloc(this._articles) : super(FeedLoading()) {
    //to get all article sources
    _articles.forEach((element) {
      _articleSources.putIfAbsent(element.source.name, () => true);
    });
  }

  @override
  Stream<NewsFeedState> mapEventToState(NewsFeedEvent event) async* {
    if (event is ShowDefaultFeed) {
      _listToShow = this._articles;
      yield DefaultFeed(
          articles: _listToShow,
          topic: "Showing default feed",
          articleSources: _articleSources);
    } else if (event is SearchFeed) {
      yield* _performSearch(event.query);
    } else if (event is FilterFeed) {
      yield* _performFilter(event.selectedSource);
    } else if (event is RemoveFilter) {
      yield* _removeFilter(event.selectedSource);
    } else if (event is ShowRecents) {
      yield* _sortForRecents();
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
    _listToShow = searchResults;
    if (searchResults.length == 0) {
      yield OperatedFeed(
        articles: _listToShow,
        topic: 'No articles were found for this query',
        articleSources: _articleSources,
      );
    } else {
      yield OperatedFeed(
        articles: _listToShow,
        topic: 'Showing results for $query',
        articleSources: _articleSources,
      );
    }
  }

  ///Sometimes `content` or `description` for the news item may be `null`.
  ///This function helps avoid errors on `null` parameters.
  ///
  bool _hasResult(String text, String query) {
    if (isBlank(text)) {
      return false;
    } else {
      return text.toLowerCase().contains(query.toLowerCase());
    }
  }

  ///adds to list the articles from `selectedSource`.
  Stream<NewsFeedState> _performFilter(String selectedSource) async* {
    yield FeedLoading();
    this._articleSources[selectedSource] = true;
    List<ArticlesModel> filteredList = [];
    _articles.forEach((element) {
      final articleSource = element.source.name; //also the key for map
      if (_articleSources[articleSource]) {
        //if true for [articleSource]
        filteredList.add(element);
      }
    });
    _listToShow = filteredList;
    yield OperatedFeed(
      topic: "News filtered",
      articles: _listToShow,
      articleSources: _articleSources,
    );
  }

  ///Removes articles from `selectedSource`.
  Stream<NewsFeedState> _removeFilter(String selectedSource) async* {
    yield FeedLoading();
    this._articleSources[selectedSource] = false;
    _listToShow.removeWhere((item) =>
        (item.source.name).compareTo(selectedSource) ==
        0); //removes items from the current list whereever source is `selectedSource`
    yield OperatedFeed(
      topic: "News filtered",
      articles: _listToShow,
      articleSources: _articleSources,
    );
  }

  Stream<NewsFeedState> _sortForRecents() async* {
    yield FeedLoading();
    _listToShow.sort((a, b) => a.publishedAt.compareTo(b.publishedAt));
    yield OperatedFeed(
      topic: "Viewing Recents",
      articles: _listToShow,
      articleSources: _articleSources,
    );
  }
}
