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
    } else if (event is FetchTechnologyHeadlines) {
      yield* _fetchTopTechnology(event.country);
    } else if (event is FetchScienceHeadlines) {
      yield* _fetchTopScience(event.country);
    } else if (event is FetchHealthHeadlines) {
      yield* _fetchTopHealth(event.country);
    } else if (event is FetchSportsHeadlines) {
      yield* _fetchTopSports(event.country);
    } else if (event is FetchBusinessHeadlines) {
      yield* _fetchTopBusiness(event.country);
    } else if (event is FetchEntertainmentHeadlines) {
      yield* _fetchTopEntertainment(event.country);
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
        yield TechnologyHeadlinesFetched(models.toList(), country);
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
        yield SportsHeadlinesFetched(models.toList(), country);
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
        yield HealthHeadlinesFetched(models.toList(), country);
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
        yield ScienceHeadlinesFetched(models.toList(), country);
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
        yield BusinessHeadlinesFetched(models.toList(), country);
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
        yield EntertainmentHeadlinesFetched(models.toList(), country);
      } catch (e) {
        print(e);
        yield Error("An error occured");
      }
    }
  }
}
