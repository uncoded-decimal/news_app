import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:headlines/src/utils/constants.dart';
import 'package:headlines/src/services/dio_http_service.dart';

class NewsService {
  final DioHttpService _httpService;

  NewsService(DioHttpService httpService) : this._httpService = httpService;

  Future<Response> fetchTopheadlines({@required String country}) async {
    String path =
        "/top-headlines?country=$country&apiKey=${Constants.newsApiKey}";
    final response = await _httpService.handleGetRequestWithoutToken(path);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else {
      throw Exception({
        "statusCode": response.statusCode,
        "statusMessage": response.statusMessage,
        "message": "Unable to fetch levels list",
      });
    }
  }

  Future<Response> fetchTopNews(
      {@required String country, @required String category}) async {
    String path =
        "/top-headlines?country=$country&category=$category&apiKey=${Constants.newsApiKey}";
    final response = await _httpService.handleGetRequestWithoutToken(path);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else {
      throw Exception({
        "statusCode": response.statusCode,
        "statusMessage": response.statusMessage,
        "message": "Unable to fetch levels list",
      });
    }
  }

  Future<Response> fetchGlobalSearchResults({@required query}) async {
    String path = "/everything?q=$query&apiKey=${Constants.newsApiKey}";
    final response = await _httpService.handleGetRequestWithoutToken(path);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else {
      throw Exception({
        "statusCode": response.statusCode,
        "statusMessage": response.statusMessage,
        "message": "Unable to fetch search results",
      });
    }
  }
}
