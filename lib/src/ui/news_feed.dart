import 'package:Headlines/src/models/articles_model.dart';
import 'package:Headlines/src/utils/constants.dart';
import 'package:Headlines/src/models/source_model.dart';
import 'package:Headlines/src/ui/news_tile.dart';
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      floatingActionButton: Row(
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
          )
        ],
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
}
