import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/src/blocs/bloc.dart';
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
    }
  }

  Stream<NewsState> _fetchTopHeadlines(String country) async* {
    yield Loading();
    try {
      final response = await _newsService.fetchTopHeadlines(country: country);
      //final model = ArticlesModel.fromMap(response.data["articles"]);
      final models =  (response.data["articles"] as List<dynamic>).map((e) => ArticlesModel.fromMap(e));
      print(models);
      yield TopHeadlinesFetched(models.toList(), country);
    } catch (e) {
      print(e);
      yield Error("An error occured");
    }
  }
}
