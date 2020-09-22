import 'package:Headlines/src/blocs/search_bloc/bloc.dart';
import 'package:Headlines/src/models/model.dart';
import 'package:Headlines/src/services/dio_http_service.dart';
import 'package:Headlines/src/services/news_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final NewsService _newsService;
  SearchBloc({@required DioHttpService httpService})
      : this._newsService = NewsService(httpService),
        super(SearchInit());

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is InitSearch) {
      yield SearchInit();
    } else if (event is FetchSearchResults) {
      yield* _fetchSearchResults(event.query);
    }
  }

  Stream<SearchState> _fetchSearchResults(String query) async* {
    yield SearchLoading();
    try {
      print("performing search for $query");
      final response = await _newsService.fetchGlobalSearchResults(
          query: query.toLowerCase());
      final models = (response.data["articles"] as List<dynamic>)
          .map((e) => ArticlesModel.fromMap(e));
      yield GlobalSearchResultsObtained(
          models.toList()
            ..sort((a, b) => b.publishedAt.compareTo(a.publishedAt)),
          query);
    } catch (e) {
      print(e);
      yield SearchError("An error occured");
    }
  }
}
