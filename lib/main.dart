import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/src/blocs/news_bloc/bloc.dart';
import 'package:news_app/src/services/dio_http_service.dart';
import 'package:news_app/src/ui/home_screen.dart';

void main() {
  runApp(MaterialApp(
    title: 'News App',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: RepositoryProvider(
      create: (BuildContext context) => DioHttpService(),
      child: BlocProvider(
        create: (BuildContext ctx) =>
            NewsBloc(httpService: RepositoryProvider.of<DioHttpService>(ctx)),
        child: HomeScreen(),
      ),
    ),
  ));
}