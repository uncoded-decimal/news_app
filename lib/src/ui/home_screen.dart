import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/src/blocs/news_bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:news_app/src/blocs/news_feed_bloc/news_feed_bloc.dart';
import 'package:news_app/src/ui/news_feed_widget.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NewsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<NewsBloc>(context);
    _fetchCountry().then((country) {
      _bloc.add(FetchTopHeadlines(country));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<NewsBloc, NewsState>(
        builder: (context, state) {
          if (state is Loading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is TopHeadlinesFetched) {
            return (state.newsModel.length <= 0)
                ? Center(
                    child: InkWell(
                      onTap: () {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("Fetching top headlines for \"US\""),
                          duration: Duration(
                            seconds: 4,
                          ),
                        ));
                        _bloc.add(FetchTopHeadlines("us"));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.grey,
                            size: 60,
                          ),
                          Text(
                              "No articles were found for your location: ${state.country}\nPress icon to search news for US")
                        ],
                      ),
                    ),
                  )
                : BlocProvider(
                    create: (BuildContext context) =>
                        NewsFeedBloc(state.newsModel),
                    child: NewsFeed(),
                  );
          } else if (state is Error) {
            return Center(
              child: InkWell(
                onTap: () {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("Fetching top headlines for \"us\""),
                    duration: Duration(
                      seconds: 4,
                    ),
                  ));
                  _bloc.add(FetchTopHeadlines("us"));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cancel,
                      color: Colors.grey,
                      size: 60,
                    ),
                    Text("Press to search news for US")
                  ],
                ),
              ),
            );
          } else {
            return Container();
          }
        },
        listener: (context, state) {
          if (state is Error) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(state.errorMessage),
              duration: Duration(
                seconds: 10,
              ),
            ));
          }
        },
      ),
    );
  }

  /// Since updating my Android Studio the geolocator plugin has
  /// been crashing with an error. 
  /// 
  /// Follow the issue here:
  /// https://github.com/Baseflow/flutter-geolocator/issues/465 
  /// 
  Future<String> _fetchCountry() async {
    // Position position = await Geolocator()
    //     .getLastKnownPosition(desiredAccuracy: LocationAccuracy.lowest);
    // List<Placemark> placemark = await Geolocator()
    //     .placemarkFromCoordinates(position.latitude, position.longitude);
    // return placemark.first.country;
    return 'in';
  }
}
