import 'package:Headlines/src/blocs/search_bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Headlines/src/blocs/news_bloc/bloc.dart';
import 'package:Headlines/src/services/dio_http_service.dart';
import 'package:Headlines/src/ui/home_screen.dart';
import 'package:Headlines/src/utils/themes.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String path = (await getApplicationDocumentsDirectory()).path;
  Hive.init(path);
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
