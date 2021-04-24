import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:headlines/src/blocs/news_bloc/bloc.dart';
import 'package:headlines/src/models/articles_model.dart';
import 'package:headlines/src/services/dio_http_service.dart';
import 'package:headlines/src/services/news_service.dart';
import 'package:quiver/strings.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsService _newsService;
  NewsBloc({@required DioHttpService httpService})
      : this._newsService = NewsService(httpService),
        super(FeedLoading());

  @override
  Stream<NewsState> mapEventToState(NewsEvent event) async* {
    if (event is FetchTopheadlines) {
      yield* _fetchTopheadlines(event.country);
    } else if (event is FetchTechnologyheadlines) {
      yield* _fetchTopTechnology(event.country);
    } else if (event is FetchScienceheadlines) {
      yield* _fetchTopScience(event.country);
    } else if (event is FetchHealthheadlines) {
      yield* _fetchTopHealth(event.country);
    } else if (event is FetchSportsheadlines) {
      yield* _fetchTopSports(event.country);
    } else if (event is FetchBusinessheadlines) {
      yield* _fetchTopBusiness(event.country);
    } else if (event is FetchEntertainmentheadlines) {
      yield* _fetchTopEntertainment(event.country);
    }
  }

  Stream<NewsState> _fetchTopheadlines(String country) async* {
    yield FeedLoading();
    if (isBlank(country)) {
      yield Error("Error fetching Top headlines for your region");
    } else {
      try {
        final response = await _newsService.fetchTopheadlines(
            country: country.toLowerCase().substring(0, 2));
        final models = (response.data["articles"] as List<dynamic>)
            .map((e) => ArticlesModel.fromMap(e));
        yield TopheadlinesFetched(models.toList(), country);
      } catch (e) {
        print(e);
        yield Error("An error occured");
      }
    }
  }

  Stream<NewsState> _fetchTopTechnology(String country) async* {
    yield FeedLoading();
    if (isBlank(country)) {
      yield Error("Error fetching technology headlines for your region");
    } else {
      try {
        final response = await _newsService.fetchTopNews(
          country: country.toLowerCase().substring(0, 2),
          category: "technology",
        );
        final models = (response.data["articles"] as List<dynamic>)
            .map((e) => ArticlesModel.fromMap(e));
        yield TechnologyheadlinesFetched(models.toList(), country);
      } catch (e) {
        print(e);
        yield Error("An error occured");
      }
    }
  }

  Stream<NewsState> _fetchTopSports(String country) async* {
    yield FeedLoading();
    if (isBlank(country)) {
      yield Error("Error fetching Sports headlines for your region");
    } else {
      try {
        final response = await _newsService.fetchTopNews(
          country: country.toLowerCase().substring(0, 2),
          category: "sports",
        );
        final models = (response.data["articles"] as List<dynamic>)
            .map((e) => ArticlesModel.fromMap(e));
        yield SportsheadlinesFetched(models.toList(), country);
      } catch (e) {
        print(e);
        yield Error("An error occured");
      }
    }
  }

  Stream<NewsState> _fetchTopHealth(String country) async* {
    yield FeedLoading();
    if (isBlank(country)) {
      yield Error("Error fetching health headlines for your region");
    } else {
      try {
        final response = await _newsService.fetchTopNews(
          country: country.toLowerCase().substring(0, 2),
          category: "health",
        );
        final models = (response.data["articles"] as List<dynamic>)
            .map((e) => ArticlesModel.fromMap(e));
        yield HealthheadlinesFetched(models.toList(), country);
      } catch (e) {
        print(e);
        yield Error("An error occured");
      }
    }
  }

  Stream<NewsState> _fetchTopScience(String country) async* {
    yield FeedLoading();
    if (isBlank(country)) {
      yield Error("Error fetching Sports headlines for your region");
    } else {
      try {
        final response = await _newsService.fetchTopNews(
          country: country.toLowerCase().substring(0, 2),
          category: "science",
        );
        final models = (response.data["articles"] as List<dynamic>)
            .map((e) => ArticlesModel.fromMap(e));
        yield ScienceheadlinesFetched(models.toList(), country);
      } catch (e) {
        print(e);
        yield Error("An error occured");
      }
    }
  }

  Stream<NewsState> _fetchTopBusiness(String country) async* {
    yield FeedLoading();
    if (isBlank(country)) {
      yield Error("Error fetching Business headlines for your region");
    } else {
      try {
        final response = await _newsService.fetchTopNews(
          country: country.toLowerCase().substring(0, 2),
          category: "business",
        );
        final models = (response.data["articles"] as List<dynamic>)
            .map((e) => ArticlesModel.fromMap(e));
        yield BusinessheadlinesFetched(models.toList(), country);
      } catch (e) {
        print(e);
        yield Error("An error occured");
      }
    }
  }

  Stream<NewsState> _fetchTopEntertainment(String country) async* {
    yield FeedLoading();
    if (isBlank(country)) {
      yield Error("Error fetching Entertainment headlines for your region");
    } else {
      try {
        final response = await _newsService.fetchTopNews(
          country: country.toLowerCase().substring(0, 2),
          category: "entertainment",
        );
        final models = (response.data["articles"] as List<dynamic>)
            .map((e) => ArticlesModel.fromMap(e));
        yield EntertainmentheadlinesFetched(models.toList(), country);
      } catch (e) {
        print(e);
        yield Error("An error occured");
      }
    }
  }
}
