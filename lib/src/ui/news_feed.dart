import 'package:headlines/src/models/articles_model.dart';
import 'package:headlines/src/utils/constants.dart';
import 'package:headlines/src/models/source_model.dart';
import 'package:headlines/src/ui/news_tile.dart';
import 'package:flutter/material.dart';

class NewsFeedPage extends StatefulWidget {
  final bool isFeed;
  final Function onSearchButtonPressed;
  final double filterWidgetMargin;
  final String title;
  final List<ArticlesModel> articles;
  NewsFeedPage({
    Key key,
    this.isFeed,
    this.onSearchButtonPressed,
    this.filterWidgetMargin,
    this.articles,
    this.title,
  }) : super(key: key);

  @override
  _NewsFeedPageState createState() => _NewsFeedPageState();
}

class _NewsFeedPageState extends State<NewsFeedPage>
    with AutomaticKeepAliveClientMixin {
  Map<SourceModel, bool> sources = {};
  ScrollController _scrollController;
  bool _showLabel = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels > 250) {
          setState(() {
            _showLabel = true;
          });
        } else {
          setState(() {
            _showLabel = false;
          });
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        controller: _scrollController,
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
                    child: !widget.isFeed
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
                  widget.isFeed
                      ? SizedBox(
                          width: 10,
                        )
                      : Container(),
                  Text(
                    widget.title,
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
            feed(),
          ],
        ),
      ),
      floatingActionButton: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: Icon(
              Icons.sort_by_alpha,
            ),
            onPressed: () => showDialog(
              context: this.context,
              barrierDismissible: true,
              builder: (_) => _filtersWidget(),
            ).then((value) => setState(() {})),
          ),
          SizedBox(
            width: 8,
          ),
          FloatingActionButton(
            child: widget.isFeed ? Icon(Icons.search) : Icon(Icons.close),
            onPressed: () => widget.onSearchButtonPressed(),
          ),
          SizedBox(
            width: 8,
          ),
          (_showLabel)
              ? InkWell(
                  onTap: () => _scrollController.animateTo(
                    0,
                    duration: Duration(
                      milliseconds: Constants.duration,
                    ),
                    curve: Curves.bounceInOut,
                  ),
                  child: Container(
                    margin: EdgeInsets.only(right: 0),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Text(
                      widget.title,
                      style: Theme.of(context).textTheme.headline6.copyWith(
                            color: Colors.black,
                          ),
                    ),
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xff64ffd0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(25),
                        // bottomLeft: Radius.circular(25),
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget feed() {
    if (widget.articles != null && widget.articles.length != 0) {
      widget.articles.forEach((article) {
        sources.putIfAbsent(article.source, () => true);
      });
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: widget.articles.length + 1,
          itemBuilder: (context, index) {
            if (index == widget.articles.length) {
              return Container(
                height: 100,
                alignment: Alignment.bottomCenter,
                child: Text("Provided by newsapi.org"),
                padding: EdgeInsets.all(5),
              );
            }
            if (!sources[widget.articles.elementAt(index).source]) {
              return Container();
            }
            return NewsTile(
              articlesModel: widget.articles.elementAt(index),
            );
          },
        ),
      );
    } else {
      return Text("No articles found for you");
    }
  }

  Widget _filtersWidget() => StatefulBuilder(
        builder: (context, setState) {
          return Card(
            // child: Container(
            //   height: _feedHeight / 1.5,
            margin: EdgeInsets.symmetric(
              horizontal: 15,
              vertical: widget.filterWidgetMargin / 2,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: sources.keys.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Sources",
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        Divider(),
                      ],
                    ),
                  );
                }
                return CheckboxListTile(
                  title: Text(sources.keys.elementAt(index - 1).name),
                  onChanged: (bool value) => setState(() =>
                      sources[sources.keys.elementAt(index - 1)] =
                          !sources[sources.keys.elementAt(index - 1)]),
                  value: sources[sources.keys.elementAt(index - 1)],
                );
              },
            ),
            // ),
          );
        },
      );

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
