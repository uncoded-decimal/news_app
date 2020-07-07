import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/src/blocs/news_feed_bloc/bloc.dart';
import 'package:news_app/src/models/model.dart';
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
            return _feedBody(state.topic, state.articles);
          } else if (state is SearchResults) {
            return _feedBody(state.query, state.articles);
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

  Widget _feedBody(String topic, List<ArticlesModel> articles) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        //Search Bar
        Expanded(
          flex: 1,
          child: TextField(
            maxLines: 1,
            controller: _searchController,
            decoration:
                InputDecoration(hintText: "Search through current feed"),
            onChanged: (currentText) {
              if (isEmpty(_searchController.value.text)) {
                _newsFeedBloc.add(ShowDefaultFeed());
              } else {
                final searchText = _searchController.value.text;
                _newsFeedBloc.add(SearchFeed(query: searchText));
              }
            },
          ),
        ),
        //Topics Bar
        Expanded(
          flex: 1,
          child: Container(
            width: double.infinity,
            alignment: Alignment.centerLeft,
            child: Text(topic ?? ""),
            color: Colors.grey[300],
          ),
        ),
        //News Feed
        Expanded(
          flex: 14,
          child: Container(
            child: ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final element = articles.elementAt(index);
                return ListTile(
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
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
