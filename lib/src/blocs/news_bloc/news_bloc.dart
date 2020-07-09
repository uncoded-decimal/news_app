import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/src/blocs/news_bloc/bloc.dart';
import 'package:news_app/src/models/articles_model.dart';
import 'package:news_app/src/services/dio_http_service.dart';
import 'package:news_app/src/services/news_service.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsService _newsService;
  NewsBloc({@required DioHttpService httpService})
      : this._newsService = NewsService(httpService),
        super(Loading());

  @override
  Stream<NewsState> mapEventToState(NewsEvent event) async* {
    if (event is FetchTopHeadlines) {
      yield* _fetchTopHeadlines(event.country);
    } else if (event is FetchSearchResults){
      yield* _fetchSearchResults(event.query);
    }
  }

  Stream<NewsState> _fetchTopHeadlines(String country) async* {
    yield Loading();
    try {
      final response = await _newsService.fetchTopHeadlines(country: country.toLowerCase().substring(0,2));
      final models =  (response.data["articles"] as List<dynamic>).map((e) => ArticlesModel.fromMap(e));
      yield TopHeadlinesFetched( models.toList(), country);
    } catch (e) {
      print(e);
      yield Error("An error occured: $e");
    }
  }

  Stream<NewsState> _fetchSearchResults(String query) async* {
    yield Loading();
    try {
      final response = await _newsService.fetchGlobalSearchResults(query: query.toLowerCase());
      final models =  (response.data["articles"] as List<dynamic>).map((e) => ArticlesModel.fromMap(e));
      yield GlobalSearchResultsObtained(models.toList(), query);
    } catch (e) {
      print(e);
      yield Error("An error occured: $e");
    }
  }
}
