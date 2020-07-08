import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/src/blocs/news_feed_bloc/bloc.dart';
import 'package:news_app/src/models/model.dart';
import 'package:quiver/strings.dart';
import 'package:url_launcher/url_launcher.dart';

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

  @override
  void initState() {
    super.initState();
    _newsFeedBloc = BlocProvider.of<NewsFeedBloc>(context)
      ..add(ShowDefaultFeed());
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<NewsFeedBloc, NewsFeedState>(
        builder: (BuildContext context, state) {
          if (state is FeedLoading) {
            return CircularProgressIndicator();
          } else if (state is DefaultFeed) {
            return _feedBody(state.topic, state.articles, state.articleSources);
          } else if (state is OperatedFeed) {
            return _feedBody(
              state.topic,
              state.articles,
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
    List<ArticlesModel> articles,
    Map<String, bool> articleSources,
  ) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        //Search Bar
        TextField(
          maxLines: 1,
          controller: _searchController,
          decoration: InputDecoration(hintText: "Search through current feed"),
          onChanged: (currentText) {
            if (isEmpty(_searchController.value.text)) {
              _newsFeedBloc.add(ShowDefaultFeed());
            } else {
              final searchText = _searchController.value.text;
              _newsFeedBloc.add(SearchFeed(query: searchText));
            }
          },
        ),
        //Topics Bar
        _topicsBar(
          topic,
          articles,
          articleSources,
        ),
        //News Feed
        Expanded(
          // flex: 14,
          child: Container(
            child: ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final element = articles.elementAt(index);
                return InkWell(
                  onTap: () async {
                    if (await canLaunch(element.url)) {
                      await launch(element.url);
                    } else {
                      throw 'Could not launch ${element.url}';
                    }
                  },
                  child: ListTile(
                    leading: isBlank(element.urlToImage)
                        ? Container(
                            child: Text("Image not found"),
                            width: size.width / 5,
                            height: size.height / 8,
                          )
                        : Image.network(
                            element.urlToImage,
                            width: size.width / 5,
                            height: size.height / 8,
                          ),
                    title: Text(element.title),
                    subtitle: Text(element.description ?? ""),
                  ),
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
    List<ArticlesModel> articles,
    Map<String, bool> articleSources,
  ) =>
      AnimatedContainer(
        width: double.infinity,
        alignment: Alignment.centerLeft,
        color: Colors.grey[300],
        duration: Duration(milliseconds: 300),
        height:
            _showFilterDropdown ? MediaQuery.of(context).size.height / 2.2 : 50,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(topic ?? "")),
                IconButton(
                    icon: Icon(Icons.filter),
                    onPressed: () {
                      setState(() {
                        _showFilterDropdown = !_showFilterDropdown;
                      });
                    }),
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
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
      height: MediaQuery.of(context).size.height / 2.9,
      padding: EdgeInsets.fromLTRB(5, 12, 5, 0),
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
                    title: Text(articleSource),
                    value: articleSources[articleSource],
                    dense: true,
                    onChanged: (value) {
                      setState(() {
                        if (!articleSources[articleSource]) {
                          //add the current news source
                          _newsFeedBloc
                              .add(FilterFeed(selectedSource: articleSource));
                        } else {
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
