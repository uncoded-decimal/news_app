import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Headlines/src/blocs/news_bloc/bloc.dart';
import 'package:Headlines/src/models/articles_model.dart';
import 'package:Headlines/src/services/dio_http_service.dart';
import 'package:Headlines/src/services/news_service.dart';
import 'package:quiver/strings.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsService _newsService;
  NewsBloc({@required DioHttpService httpService})
      : this._newsService = NewsService(httpService),
        super(FeedLoading());

  @override
  Stream<NewsState> mapEventToState(NewsEvent event) async* {
    if (event is FetchTopHeadlines) {
      yield* _fetchTopHeadlines(event.country);
    }
  }

  Stream<NewsState> _fetchTopHeadlines(String country) async* {
    yield FeedLoading();
    if (isBlank(country)) {
      yield Error("Error fetching Top Headlines for your region");
    } else {
      try {
        final response = await _newsService.fetchTopHeadlines(
            country: country.toLowerCase().substring(0, 2));
        final models = (response.data["articles"] as List<dynamic>)
            .map((e) => ArticlesModel.fromMap(e));
        yield TopHeadlinesFetched(models.toList(), country);
      } catch (e) {
        print(e);
        yield Error("An error occured");
      }
    }
  }
}
