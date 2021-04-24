import 'dart:io';

import 'package:headlines/src/blocs/search_bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:headlines/src/blocs/news_bloc/bloc.dart';
import 'package:headlines/src/services/dio_http_service.dart';
import 'package:headlines/src/ui/home_screen.dart';
import 'package:headlines/src/utils/themes.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory;
  if (kIsWeb) {
  } else {
    directory = await getApplicationDocumentsDirectory();
    String path = directory.path;
    Hive.init(path);
  }
  runApp(MaterialApp(
    title: 'News App',
    theme: buildDarkTheme(),
    home: RepositoryProvider(
      create: (BuildContext context) => DioHttpService(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (ctx) => NewsBloc(
                  httpService: RepositoryProvider.of<DioHttpService>(ctx))),
          BlocProvider(
              create: (ctx) => SearchBloc(
                  httpService: RepositoryProvider.of<DioHttpService>(ctx))),
        ],
        child: HomeScreen(),
      ),
    ),
  ));
}
