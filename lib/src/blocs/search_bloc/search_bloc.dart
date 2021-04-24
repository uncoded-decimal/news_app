import 'package:headlines/src/blocs/search_bloc/bloc.dart';
import 'package:headlines/src/data/search_repository.dart';
import 'package:headlines/src/models/model.dart';
import 'package:headlines/src/services/dio_http_service.dart';
import 'package:headlines/src/services/news_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final NewsService _newsService;
  final SearchRepository _searchRepository;
  SearchBloc({@required DioHttpService httpService})
      : this._newsService = NewsService(httpService),
        this._searchRepository = SearchRepository(),
        super(SearchInit(keys: []));

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is InitSearch) {
      yield* _handleSearchOptions();
    } else if (event is FetchSearchResults) {
      yield* _fetchSearchResults(event.query);
    }
  }

  Stream<SearchState> _fetchSearchResults(String query) async* {
    yield SearchLoading();
    try {
      query = query.trim();
      print("performing search for $query");
      _searchRepository.addToList(query);
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

  Stream<SearchState> _handleSearchOptions() async* {
    final keys = _searchRepository.getSearchTerms();
    yield SearchInit(keys: keys.isEmpty ? [] : keys);
  }
}
