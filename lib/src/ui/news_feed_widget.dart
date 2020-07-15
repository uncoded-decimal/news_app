import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Headlines/src/blocs/news_feed_bloc/bloc.dart';
import 'package:Headlines/src/models/model.dart';
import 'package:Headlines/src/ui/news_tile.dart';
import 'package:quiver/strings.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'dart:math' as math;

class NewsFeed extends StatefulWidget {
  NewsFeed({
    Key key,
  }) : super(key: key);

  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  NewsFeedBloc _newsFeedBloc;
  TextEditingController _searchController;
  bool _showFilterDropdown = false;
  List<String> listOfArticleSources = [];
  List<ArticlesModel> articles = [];
  List<ArticlesModel> articlesToShow = [];
  ScrollController _scrollController = ScrollController();
  int page = 1;
  int loadSize = 10;

  @override
  void initState() {
    super.initState();
    _newsFeedBloc = BlocProvider.of<NewsFeedBloc>(context)
      ..add(ShowDefaultFeed());
    _searchController = TextEditingController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _onScrollEnd();
      }
    });
  }

  //actions to perform when end of the list is reached
  void _onScrollEnd() {
    page++;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<NewsFeedBloc, NewsFeedState>(
        builder: (BuildContext context, state) {
          if (state is FeedLoading) {
            return CircularProgressIndicator();
          } else if (state is DefaultFeed) {
            this.articles = state.articles;
            articlesToShow = articles.sublist(
                0,
                (page * loadSize > articles.length)
                    ? articles.length
                    : page * loadSize);
            return _feedBody(state.topic, state.articleSources);
          } else if (state is OperatedFeed) {
            this.articles = state.articles;
            articlesToShow = articles.sublist(
                0,
                (articles.length >= page * loadSize)
                    ? page * loadSize
                    : articles.length);
            return _feedBody(
              state.topic,
              state.articleSources,
            );
          } else {
            return Container(
              child: Text("Oops! Something went really wrong..."),
            );
          }
        },
        listener: (BuildContext context, state) {},
      ),
    );
  }

  Widget _feedBody(
    String topic,
    Map<String, bool> articleSources,
  ) {
    return Column(
      children: [
        //News Feed
        Expanded(
          // flex: 14,
          child: Container(
            padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
            color: Colors.black,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: articlesToShow.length + 1,
              itemBuilder: (context, index) {
                if (index >= articles.length) {
                  //end of the parent list has been reached
                  //but the child list expects more
                  return Container();
                } else if (index == articlesToShow.length) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: CircularProgressIndicator(),
                    alignment: Alignment.center,
                  );
                }
                final element = articlesToShow.elementAt(index);
                return NewsTile(
                  articlesModel: element,
                );
              },
            ),
          ),
        ),
        //Topics Bar
        _topicsBar(
          topic,
          articleSources,
        ),
      ],
    );
  }

  Widget _topicsBar(
    String topic,
    Map<String, bool> articleSources,
  ) =>
      AnimatedContainer(
        width: double.infinity,
        alignment: Alignment.centerLeft,
        color: Colors.grey[800],
        duration: Duration(milliseconds: 300),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                //Search Bar
                Flexible(
                  child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextField(
                        maxLines: 1,
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "Search current feed",
                          contentPadding: EdgeInsets.zero,
                          suffix: isEmpty(_searchController.value.text)
                              ? IconButton(
                                  icon: Icon(MdiIcons.searchWeb),
                                  onPressed: () {
                                    if (isBlank(_searchController.value.text)) {
                                      _newsFeedBloc.add(ShowDefaultFeed());
                                    }
                                  },
                                )
                              : IconButton(
                                  icon: Transform.rotate(
                                      angle: math.pi / 4,
                                      child: Icon(MdiIcons.plus)),
                                  onPressed: () {
                                    _searchController.clear();
                                  },
                                ),
                        ),
                        style: TextStyle(color: Theme.of(context).accentColor),
                        onChanged: (text) {
                          setState(() {});
                          if (isEmpty(_searchController.value.text)) {
                            page = 1;
                            _newsFeedBloc.add(ShowDefaultFeed());
                          } else {
                            page = 1;
                            _newsFeedBloc.add(SearchFeed(
                                query: _searchController.value.text));
                          }
                        },
                        textInputAction: TextInputAction.go,
                        onSubmitted: (text) {
                          if (isBlank(_searchController.value.text)) {
                            page = 1;
                            _newsFeedBloc.add(SearchFeed(
                                query: _searchController.value.text));
                          }
                        },
                      )
                      ),
                ),
                IconButton(
                    tooltip: "Filter",
                    icon: Icon(
                      MdiIcons.filter,
                      color: _showFilterDropdown
                          ? Theme.of(context).accentColor
                          : Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _showFilterDropdown = !_showFilterDropdown;
                      });
                    }),
                IconButton(
                  icon: Icon(
                    MdiIcons.sort,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    page = 1;
                    _newsFeedBloc.add(ShowRecents());
                  },
                  tooltip: "Recents",
                ),
              ],
            ),
            _showFilterDropdown
                ? _filterBox(
                    articleSources,
                  )
                : Container(),
          ],
        ),
      );

  ///The Container displaying filters for all the news sources available
  Widget _filterBox(
    Map<String, bool> articleSources,
  ) {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 12, 5, 10),
      color: Colors.grey[500],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Select the news sources you want to see"),
          Container(
            height: MediaQuery.of(context).size.height / 5,
            margin: EdgeInsets.only(top: 10),
            color: Colors.white,
            child: ListView.builder(
              itemCount: articleSources.length,
              itemBuilder: (context, index) {
                final articleSource = articleSources.keys.elementAt(index);
                return CheckboxListTile(
                    title: Text(
                      articleSource,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    value: articleSources[articleSource],
                    dense: true,
                    onChanged: (value) {
                      setState(() {
                        if (!articleSources[articleSource]) {
                          page = 1;
                          //add the current news source
                          _newsFeedBloc
                              .add(FilterFeed(selectedSource: articleSource));
                        } else {
                          page = 1;
                          _newsFeedBloc
                              .add(RemoveFilter(selectedSource: articleSource));
                        }
                      });
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}
