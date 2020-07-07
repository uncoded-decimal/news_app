import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/src/blocs/bloc.dart';
import 'package:geolocator/geolocator.dart';

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
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                    "${state.newsModel.length} articles found for your location: ${state.country}"),
                (state.newsModel.length <= 0)
                    ? InkWell(
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
                      )
                    : Container(),
              ],
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

  Future<String> _fetchCountry() async {
    Position position = await Geolocator()
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.lowest);
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    // placemark.forEach((element) {print("placemark = ${element.country}");});
    return placemark.first.country.toLowerCase();
  }
}
