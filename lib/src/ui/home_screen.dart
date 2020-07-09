import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:news_app/src/blocs/news_bloc/bloc.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:news_app/src/blocs/news_feed_bloc/news_feed_bloc.dart';
import 'package:news_app/src/ui/news_feed_widget.dart';
import 'package:quiver/strings.dart';
import 'package:geocoding/geocoding.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NewsBloc _bloc;
  String _country;
  TextEditingController _globalSearchController;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<NewsBloc>(context);
    _globalSearchController = TextEditingController();
    _fetchCountryCode().then((result) {
      _country = result;
      _bloc.add(FetchTopHeadlines(result));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: SafeArea(
          child: Container(
            color: Colors.black,
            child: Row(
              children: [
                SizedBox(width: 5),
                Expanded(
                    child: TextField(
                  maxLines: 1,
                  controller: _globalSearchController,
                  decoration: InputDecoration(hintText: "Search all news"),
                  style: TextStyle(color: Theme.of(context).accentColor),
                  onChanged: (text) {
                    if (isBlank(_globalSearchController.value.text)) {
                      _bloc.add(FetchTopHeadlines(_country));
                    }
                  },
                )), //global search widget
                IconButton(
                  icon: Icon(MdiIcons.searchWeb),
                  onPressed: () => _bloc.add(
                    FetchSearchResults(_globalSearchController.value.text),
                  ),
                ),
                IconButton(
                  icon: Icon(MdiIcons.refreshCircle),
                  onPressed: () => _bloc.add(
                    FetchTopHeadlines(_country),
                  ),
                ),
              ],
            ),
          ),
        ),
        preferredSize: Size.fromHeight(60),
      ),
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
          } else if (state is GlobalSearchResultsObtained) {
            return BlocProvider(
              create: (BuildContext context) => NewsFeedBloc(state.newsModel),
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
  Future<String> _fetchCountryCode() async {
    // Position position = await Geolocator()
    //     .getLastKnownPosition(desiredAccuracy: LocationAccuracy.lowest);
    // List<Placemark> placemark = await Geolocator()
    //     .placemarkFromCoordinates(position.latitude, position.longitude);
    // return placemark.first.country;
    // return 'in';

    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return _fetchCountryCode();
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return _fetchCountryCode();
      }
    }

    _locationData = await location.getLocation();

    final locationObtained = await placemarkFromCoordinates(
        _locationData.latitude, _locationData.longitude);
    print(locationObtained.first.isoCountryCode);
    return locationObtained.first.isoCountryCode;
  }
}
