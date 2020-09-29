import 'dart:async';

import 'package:Headlines/src/blocs/news_bloc/bloc.dart';
import 'package:Headlines/src/blocs/search_bloc/bloc.dart';
import 'package:Headlines/src/ui/news_feed.dart';
import 'package:Headlines/src/ui/search_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart';
import '../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  SearchBloc _searchBloc;
  NewsBloc _newsBloc;
  PageController _categoryController;
  TextEditingController _globalSearchController;
  AnimationController _bottomSheetController;
  double _feedHeight;
  double _searchHeight;
  bool isFeed = true;
  FocusNode _searchFocusNode;
  List<Widget> newsPages = [];
  double _progressValue = 0.0;

  @override
  void initState() {
    super.initState();
    _searchFocusNode = FocusNode();
    _searchBloc = BlocProvider.of<SearchBloc>(context);
    _newsBloc = BlocProvider.of<NewsBloc>(context);
    _categoryController = PageController(
      initialPage: 0,
      keepPage: true,
    )..addListener(() => setState(() {
          _progressValue = (_categoryController.page + 1) / (newsPages.length);
        }));
    _globalSearchController = TextEditingController();
    _fetchCountryCode().then((country) => buildPages(country));
    _bottomSheetController = AnimationController(vsync: this);
  }

  void buildPages(String country) {
    print("Showing results for ::: $country");
    _newsBloc
      ..add(FetchTopHeadlines(country))
      ..listen((state) {
        if (state is TopHeadlinesFetched) {
          newsPages.add(NewsFeedPage(
            title: "TOP HEADLINES",
            isFeed: isFeed,
            filterWidgetMargin: _searchHeight,
            articles: state.newsModel,
            onSearchButtonPressed: _searchButtonPress,
          ));
          _newsBloc.add(FetchSportsHeadlines(country));
        } else if (state is SportsHeadlinesFetched) {
          newsPages.add(NewsFeedPage(
            isFeed: isFeed,
            title: "SPORTS",
            articles: state.newsModel,
            filterWidgetMargin: _searchHeight,
            onSearchButtonPressed: _searchButtonPress,
          ));
          _newsBloc.add(FetchHealthHeadlines(country));
        } else if (state is HealthHeadlinesFetched) {
          newsPages.add(NewsFeedPage(
            isFeed: isFeed,
            title: "HEALTH",
            articles: state.newsModel,
            filterWidgetMargin: _searchHeight,
            onSearchButtonPressed: _searchButtonPress,
          ));
          _newsBloc.add(FetchScienceHeadlines(country));
        } else if (state is ScienceHeadlinesFetched) {
          newsPages.add(NewsFeedPage(
            title: "SCIENCE",
            articles: state.newsModel,
            isFeed: isFeed,
            filterWidgetMargin: _searchHeight,
            onSearchButtonPressed: _searchButtonPress,
          ));
          _newsBloc.add(FetchTechnologyHeadlines(country));
        } else if (state is TechnologyHeadlinesFetched) {
          newsPages.add(NewsFeedPage(
            isFeed: isFeed,
            title: "TECHNOLOGY",
            articles: state.newsModel,
            filterWidgetMargin: _searchHeight,
            onSearchButtonPressed: _searchButtonPress,
          ));
          _newsBloc.add(FetchBusinessHeadlines(country));
        } else if (state is BusinessHeadlinesFetched) {
          newsPages.add(NewsFeedPage(
            isFeed: isFeed,
            title: "BUSINESS",
            articles: state.newsModel,
            filterWidgetMargin: _searchHeight,
            onSearchButtonPressed: _searchButtonPress,
          ));
          _newsBloc.add(FetchEntertainmentHeadlines(country));
        } else if (state is EntertainmentHeadlinesFetched) {
          newsPages.add(NewsFeedPage(
            isFeed: isFeed,
            title: "ENTERTAINMENT",
            articles: state.newsModel,
            filterWidgetMargin: _searchHeight,
            onSearchButtonPressed: _searchButtonPress,
          ));
        }
        if (!(state is FeedLoading) && !(state is Error)) {
          if (!(state is TopHeadlinesFetched)) {
            /// Need to do this because the PageView is built only
            /// after the Second state is yielded by the newsBloc
            _progressValue = (_categoryController.page + 1) / newsPages.length;
          }
          setState(() {});
        }
      });
  }

  void _formModes() {
    final screenHeight = MediaQuery.of(context).size.height;
    _feedHeight = screenHeight -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).viewPadding.top / 2 -
        MediaQuery.of(context).viewInsets.top;
    _searchHeight = screenHeight / 3;
  }

  void _searchButtonPress() {
    _globalSearchController.clear();
    _searchBloc.add(InitSearch());
    if (!isFeed) {
      _searchFocusNode.unfocus();
    }
    setState(() {
      isFeed = !isFeed;
    });
  }

  Widget _appBar() => AppBar(
        leading: BackButton(
          onPressed: () => _searchButtonPress(),
        ),
        title: TextField(
          focusNode: _searchFocusNode,
          controller: _globalSearchController,
          style: TextStyle(color: Theme.of(context).accentColor),
          decoration: InputDecoration.collapsed(
            hintText: "Search topics...",
          ),
          maxLines: 1,
          onEditingComplete: () {
            _searchFocusNode.unfocus();
            _searchBloc.add(FetchSearchResults(_globalSearchController.text));
          },
        ),
        actions: [
          BlocBuilder<SearchBloc, SearchState>(
              bloc: _searchBloc,
              buildWhen: (previous, current) {
                if (current is SearchLoading ||
                    current is GlobalSearchResultsObtained ||
                    current is SearchInit) {
                  return true;
                }
                return false;
              },
              builder: (context, state) {
                if (state is SearchLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is SearchInit) {
                  return IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        _globalSearchController.clear();
                      });
                } else if (state is GlobalSearchResultsObtained) {
                  return IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        //go back to init
                        _searchBloc.add(InitSearch());
                        _globalSearchController.clear();
                      });
                } else {
                  return Container();
                }
              }),
        ],
        backgroundColor: Colors.grey[900],
      );

  @override
  Widget build(BuildContext context) {
    _formModes();
    return Scaffold(
      appBar: _appBar(),
      body: SearchWidget(),
      // endDrawer: Container(
      //   color: Colors.red,
      // ),
      backgroundColor: Colors.black,
      bottomNavigationBar: BottomSheet(
        animationController: _bottomSheetController,
        onClosing: () {
          print(
              "Oh hey animationController closed. This shouldn't be happenning...");
        },
        builder: (context) {
          return AnimatedContainer(
            duration: Duration(milliseconds: Constants.duration),
            height: isFeed ? _feedHeight : _searchHeight,
            padding: EdgeInsets.symmetric(horizontal: 3),
            margin: EdgeInsets.only(top: 10),
            child: Scaffold(
              body: (newsPages.length == 0)
                  ? Container(
                      child: CircularProgressIndicator(),
                      alignment: Alignment.center,
                    )
                  : PageView.builder(
                      controller: _categoryController,
                      physics: BouncingScrollPhysics(),
                      pageSnapping: true,
                      itemCount: newsPages.length,
                      itemBuilder: (context, index) {
                        return newsPages.elementAt(index);
                      },
                    ),
              bottomNavigationBar: !(newsPages.length == 0)
                  ? LinearProgressIndicator(
                      backgroundColor: Color(0xff64ffd0),
                      value: _progressValue,
                    )
                  : Container(),
            ),
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
      ),
    );
  }

  Future<String> _fetchCountryCode() async {
    try {
      final timer = Timer(Duration(seconds: 2), () {
        print("Location timer completed");
        throw Exception("Timeout before obtaining location");
      });
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
      timer.cancel();
      print(locationObtained.first.isoCountryCode);
      return locationObtained.first.isoCountryCode;
    } catch (e) {
      print("Error with location: $e");
      return "US";
    }
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _categoryController.dispose();
    _bottomSheetController.dispose();
    _globalSearchController.dispose();
    super.dispose();
  }
}
