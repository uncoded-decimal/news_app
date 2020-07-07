import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:news_app/src/constants.dart';
import 'package:news_app/src/services/dio_http_service.dart';

class NewsService {
  final DioHttpService _httpService;

  NewsService(DioHttpService httpService) : this._httpService = httpService;

  Future<Response> fetchTopHeadlines({@required String country}) async {
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
}
