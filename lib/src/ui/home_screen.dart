import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;
import 'package:Headlines/src/blocs/news_bloc/bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:quiver/strings.dart';

import '../blocs/news_bloc/news_states.dart';
import '../constants.dart';
import 'news_tile.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NewsBloc _bloc;
  TextEditingController _globalSearchController;
  String _country;

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

  Widget _appBar() => PreferredSize(
        child: SafeArea(
          child: Container(
            child: Row(
              children: [
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundImage: AssetImage(Constants.appIcon),
                  radius: 15,
                ),
                SizedBox(width: 10),
                Expanded(
                    child: TextField(
                  maxLines: 1,
                  controller: _globalSearchController,
                  decoration: InputDecoration(
                    hintText: "Search all news",
                    contentPadding: EdgeInsets.zero,
                    suffix: isEmpty(_globalSearchController.value.text)
                        ? IconButton(
                            icon: Icon(MdiIcons.searchWeb),
                            onPressed: () {
                              if (isBlank(_globalSearchController.value.text)) {
                                _bloc.add(FetchSearchResults(
                                    _globalSearchController.value.text));
                              }
                            },
                          )
                        : IconButton(
                            icon: Transform.rotate(
                                angle: math.pi / 4, child: Icon(MdiIcons.plus)),
                            onPressed: () {
                              _globalSearchController.clear();
                            },
                          ),
                  ),
                  style: TextStyle(color: Theme.of(context).accentColor),
                  onChanged: (text) {
                    setState(() {});
                  },
                  textInputAction: TextInputAction.done,
                  onSubmitted: (text) {
                    if (isNotBlank(_globalSearchController.value.text)) {
                      _bloc.add(FetchSearchResults(
                          _globalSearchController.value.text));
                    }
                  },
                )),
                IconButton(
                  icon: Icon(MdiIcons.home),
                  onPressed: () => _bloc.add(
                    FetchTopHeadlines(_country),
                  ),
                  tooltip: "Headlines",
                ),
              ],
            ),
          ),
        ),
        preferredSize: Size.fromHeight(50),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: Colors.grey,
      bottomNavigationBar: DraggableScrollableSheet(
        expand: true,
        initialChildSize: 0.9,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: Colors.grey[800], width: 3),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              controller: scrollController,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: 8,
                      bottom: 5,
                    ),
                    child: Text(
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
                  ),
                  BlocBuilder<NewsBloc, NewsState>(
                    buildWhen: (previous, current) {
                      if (current is Loading ||
                          current is Error ||
                          current is TopHeadlinesFetched) {
                        return true;
                      }
                      return false;
                    },
                    builder: (context, state) {
                      if (state is Loading) {
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
                                  articlesModel:
                                      state.newsModel.elementAt(index),
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
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _globalSearchController.dispose();
    super.dispose();
  }
}
