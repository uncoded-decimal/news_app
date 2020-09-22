import 'package:Headlines/src/blocs/search_bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Headlines/src/blocs/news_bloc/bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart';
import 'package:quiver/strings.dart';
import 'package:url_launcher/url_launcher.dart';

import '../blocs/news_bloc/news_states.dart';
import '../constants.dart';
import 'news_tile.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  NewsBloc _bloc;
  SearchBloc _searchBloc;
  TextEditingController _globalSearchController;
  String _country;
  AnimationController _bottomSheetController;
  double _feedHeight;
  double _searchHeight;
  bool isFeed = true;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<NewsBloc>(context);
    _searchBloc = BlocProvider.of<SearchBloc>(context);
    _globalSearchController = TextEditingController();
    _fetchCountryCode().then((result) {
      _country = result;
      _bloc.add(FetchTopHeadlines(result));
    });
    _bottomSheetController = AnimationController(vsync: this);
  }

  void _formModes() {
    final screenHeight = MediaQuery.of(context).size.height;
    _feedHeight = screenHeight -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).viewPadding.top -
        MediaQuery.of(context).viewInsets.top;
    _searchHeight = screenHeight / 3;
  }

  void _feedButtonPress() {
    _globalSearchController.clear();
    _searchBloc.add(InitSearch());
    setState(() {
      isFeed = !isFeed;
    });
  }

  Widget _appBar() => AppBar(
        leading: BackButton(
          onPressed: () => _feedButtonPress(),
        ),
        title: TextField(
          controller: _globalSearchController,
          style: TextStyle(color: Theme.of(context).accentColor),
          decoration: InputDecoration.collapsed(
            hintText: "Search topics...",
          ),
          maxLines: 1,
          onEditingComplete: () =>
              _searchBloc.add(FetchSearchResults(_globalSearchController.text)),
        ),
        actions: [
          isEmpty(_globalSearchController.text)
              ? Container()
              : IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    _globalSearchController.clear();
                    _searchBloc.add(InitSearch());
                  })
        ],
        backgroundColor: Colors.grey[900],
      );

  @override
  Widget build(BuildContext context) {
    _formModes();
    return Scaffold(
      appBar: _appBar(),
      body: _searchBody(),
      backgroundColor: Colors.black,
      bottomNavigationBar: BottomSheet(
        animationController: _bottomSheetController,
        onClosing: () {
          print("Oh hey it closed. This shouldn't be happenning...");
        },
        builder: (context) {
          return _newsListContainer();
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

  Widget _newsListContainer() => AnimatedContainer(
        duration: Duration(milliseconds: Constants.duration),
        height: isFeed ? _feedHeight : _searchHeight,
        padding: EdgeInsets.symmetric(horizontal: 3),
        margin: EdgeInsets.only(top: 10),
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            child: isFeed ? Icon(Icons.search) : Icon(Icons.close),
            onPressed: () => _feedButtonPress(),
          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            // controller: scrollController,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: 8,
                    bottom: 5,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: Constants.duration),
                        child: !isFeed
                            ? Container(
                                width: 0.0,
                              )
                            : CircleAvatar(
                                backgroundImage: AssetImage(
                                  Constants.appIcon,
                                ),
                                radius: 15,
                              ),
                      ),
                      isFeed
                          ? SizedBox(
                              width: 10,
                            )
                          : Container(),
                      Text(
                        "TOP HEADLINES",
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            .copyWith(fontWeight: FontWeight.bold, shadows: [
                          Shadow(
                            blurRadius: 2,
                            color: Colors.grey,
                          )
                        ]),
                      ),
                    ],
                  ),
                ),
                BlocBuilder<NewsBloc, NewsState>(
                  buildWhen: (previous, current) {
                    if (current is FeedLoading ||
                        current is Error ||
                        current is TopHeadlinesFetched) {
                      return true;
                    }
                    return false;
                  },
                  builder: (context, state) {
                    if (state is FeedLoading) {
                      return Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (state is TopHeadlinesFetched) {
                      if (state.newsModel.length != 0) {
                        return Container(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: state.newsModel.length,
                            itemBuilder: (context, index) {
                              return NewsTile(
                                articlesModel: state.newsModel.elementAt(index),
                              );
                            },
                          ),
                        );
                      } else {
                        return Container(
                          child: Center(
                            child: Text("No feed found for you"),
                          ),
                        );
                      }
                    } else if (state is Error) {
                      return Container(
                        child: Center(
                          child:
                              Text("En error occured: ${state.errorMessage}"),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      );

  Future<String> _fetchCountryCode() async {
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

  Widget _searchBody() {
    return BlocBuilder<SearchBloc, SearchState>(
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
          return LinearProgressIndicator();
        } else if (state is GlobalSearchResultsObtained) {
          return ListView.builder(
            itemCount: state.newsModel.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[700],
                ),
                margin: EdgeInsets.all(3),
                child: ListTile(
                  onTap: () async {
                    if (await canLaunch(state.newsModel.elementAt(index).url)) {
                      await launch(state.newsModel.elementAt(index).url);
                    } else {
                      throw 'Could not launch ${state.newsModel.elementAt(index).url}';
                    }
                  },
                  title: Text(
                    state.newsModel.elementAt(index).title,
                    style: Theme.of(context).textTheme.subtitle2.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF64ffda),
                        ),
                  ),
                  subtitle: Text(
                    state.newsModel.elementAt(index).description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
              );
            },
          );
        } else if (state is SearchInit) {
          return Container();
        } else {
          return Container();
        }
      },
    );
  }

  @override
  void dispose() {
    _bottomSheetController.dispose();
    _globalSearchController.dispose();
    super.dispose();
  }
}
