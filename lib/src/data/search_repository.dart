import 'package:hive/hive.dart';

class SearchRepository {
  Box _searchBox;
  List<String> _searchTerms = [];

  SearchRepository() {
    _initRepository();
  }

  Future<void> _initRepository() async {
    _searchBox = await Hive.openBox("search");
  }

  void addToList(String key) {
    if (_searchTerms == null) {
      _searchTerms = [key];
    } else {
      if (_searchTerms.length >= 10) {
        _searchTerms.removeAt(0);
      }
      int indexAlreadyPresent = _searchTerms.indexOf(key);
      if (indexAlreadyPresent >= 0) {
        //remove already present item
        _searchTerms.removeAt(indexAlreadyPresent);
      }
      _searchTerms.add(key);
    }
    _searchBox.put("search_terms", _searchTerms);
  }

  List<String> getSearchTerms() {
    _searchTerms = _searchBox.get("search_terms");
    if (_searchTerms == null) {
      return [];
    }
    return _searchTerms.reversed.toList();
  }
}
