import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/src/blocs/news_feed_bloc/bloc.dart';
import 'package:news_app/src/models/model.dart';
import 'package:news_app/src/ui/news_tile.dart';
import 'package:quiver/strings.dart';

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
        //Search Bar
        TextField(
          maxLines: 1,
          controller: _searchController,
          decoration: InputDecoration(hintText: "Search through current feed"),
          onChanged: (currentText) {
            if (isEmpty(_searchController.value.text)) {
              page = 1;
              _newsFeedBloc.add(ShowDefaultFeed());
            } else {
              final searchText = _searchController.value.text;
              page = 1;
              _newsFeedBloc.add(SearchFeed(query: searchText));
            }
          },
        ),
        //Topics Bar
        _topicsBar(
          topic,
          articleSources,
        ),
        //News Feed
        Expanded(
          // flex: 14,
          child: Container(
            padding: EdgeInsets.fromLTRB(2, 5, 2, 2),
            color: Colors.grey[500],
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
        color: Colors.grey[300],
        duration: Duration(milliseconds: 300),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 5,
                ),
                Expanded(
                    child: Text(
                  topic ?? "",
                  style: TextStyle(
                      color: Colors.grey[500], fontStyle: FontStyle.italic),
                )),
                FlatButton(
                    child: Column(
                      children: [
                        Icon(
                          Icons.filter,
                          color: Theme.of(context).primaryColor,
                        ),
                        Text(
                          "Filter",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                    onPressed: () {
                      setState(() {
                        _showFilterDropdown = !_showFilterDropdown;
                      });
                    }),
                FlatButton(
                  child: Column(
                    children: [
                      Icon(Icons.refresh,
                          color: Theme.of(context).primaryColor),
                      Text(
                        "Recents",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      )
                    ],
                  ),
                  onPressed: () {
                    page = 1;
                    _newsFeedBloc.add(ShowRecents());
                  },
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
      // height: MediaQuery.of(context).size.height / 2.9,
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
