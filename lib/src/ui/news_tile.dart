import 'package:headlines/src/models/model.dart';
import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsTile extends StatelessWidget {
  final ArticlesModel articlesModel;
  final double _imageHeight = 180.0;
  NewsTile({Key key, this.articlesModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.grey[800],
          boxShadow: [
            BoxShadow(
              color: Colors.grey[900],
              blurRadius: 2,
              spreadRadius: 1,
              offset: Offset(1, 0),
            ),
          ]),
      child: InkWell(
        onTap: () async {
          if (await canLaunch(articlesModel.url)) {
            await launch(articlesModel.url);
          } else {
            throw 'Could not launch ${articlesModel.url}';
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isBlank(articlesModel.urlToImage)
                ? Container(
                    padding: EdgeInsets.all(5),
                    alignment: Alignment.center,
                    child: Text(
                        articlesModel.title
                            .substring(0, articlesModel.title.indexOf("-")),
                        style: Theme.of(context).textTheme.headline6),
                  )
                : Container(
                    height: _imageHeight,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: Image.network(
                            articlesModel.urlToImage,
                            height: _imageHeight,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          alignment: Alignment.bottomLeft,
                          child: Text(
                              articlesModel.title.substring(
                                  0, articlesModel.title.indexOf("-")),
                              style: Theme.of(context).textTheme.headline6),
                          decoration: BoxDecoration(
                            // color: Colors.black38,
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                              colors: [
                                Colors.black,
                                Colors.black45,
                                Colors.transparent,
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            isNotEmpty(articlesModel.description) ||
                    isNotEmpty(articlesModel.content)
                ? SizedBox(
                    height: 5,
                  )
                : Container(),
            isNotEmpty(articlesModel.description) ||
                    isNotEmpty(articlesModel.content)
                ? Text(
                    articlesModel.description ?? articlesModel.content ?? "",
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(color: Colors.white),
                    maxLines: 3,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  )
                : Container(),
            SizedBox(height: 5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          _dateToString(articlesModel.publishedAt),
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(color: Theme.of(context).accentColor),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          articlesModel.source.name,
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(color: Color(0xff64d0ff)),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                    child: Icon(Icons.share),
                    onTap: () {
                      Share.share(articlesModel.url);
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _dateToString(DateTime datetime) {
    if (datetime == null) return "";
    final day = datetime.day;
    final month = datetime.month;
    final year = datetime.year;
    final hours = datetime.hour;
    final minutes = datetime.minute;
    final check = (minutes % 10 == minutes) ? "0" : "";
    // final seconds = datetime.second;
    if (day == DateTime.now().day) {
      return "Today at $hours:$check$minutes hrs";
    } else if (day == DateTime.now().day - 1) {
      return "Yesterday at $hours:$check$minutes hrs";
    }
    return "$day/$month/$year at $hours:$check$minutes hrs";
  }
}
