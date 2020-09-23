import 'package:Headlines/src/models/model.dart';
import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsTile extends StatefulWidget {
  final ArticlesModel articlesModel;
  NewsTile({Key key, this.articlesModel}) : super(key: key);

  @override
  _NewsTileState createState() => _NewsTileState();
}

class _NewsTileState extends State<NewsTile> {
  double _height = 180.0;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (await canLaunch(widget.articlesModel.url)) {
          await launch(widget.articlesModel.url);
        } else {
          throw 'Could not launch ${widget.articlesModel.url}';
        }
      },
      child: Container(
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
        child: Column(
          children: [
            Container(
              height: _height,
              child: Stack(
                children: [
                  isBlank(widget.articlesModel.urlToImage)
                      ? Container()
                      : ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: Image.network(
                            widget.articlesModel.urlToImage,
                            height: _height,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                  Container(
                    padding: EdgeInsets.all(5),
                    alignment: Alignment.bottomLeft,
                    child: Text(
                        widget.articlesModel.title.substring(
                            0, widget.articlesModel.title.indexOf("-")),
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
            SizedBox(
              height: 5,
            ),
            Text(
              widget.articlesModel.description ??
                  widget.articlesModel.content ??
                  "",
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .copyWith(color: Colors.white),
              maxLines: 3,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 5),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                _dateToString(widget.articlesModel.publishedAt),
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(color: Theme.of(context).accentColor),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                widget.articlesModel.source.name,
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(color: Color(0xff64d0ff)),
              ),
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
    return "$day/$month/$year at $hours:$check$minutes hrs";
  }
}
