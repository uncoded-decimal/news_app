import 'package:news_app/src/models/articles_model.dart';
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
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: Colors.black87,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey[200],
                  spreadRadius: 0.5,
                  blurRadius: 2,
                  offset: Offset(0, 1.5)),
            ]),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: isBlank(widget.articlesModel.urlToImage)
                      ? Text(
                          'No image',
                          style: TextStyle(color: Colors.white),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          child: Image.network(
                            widget.articlesModel.urlToImage,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                    flex: 4,
                    child: Text(widget.articlesModel.title,
                        style: Theme.of(context).textTheme.headline6
                        // .copyWith(color: Colors.white),
                        )),
              ],
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
              maxLines: 4,
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
            )
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
