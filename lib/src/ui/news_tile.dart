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
        margin: EdgeInsets.all(3),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Colors.black,
            boxShadow: [
              BoxShadow(
                offset: Offset(1, 1),
                color: Colors.blue[100],
              ),
              BoxShadow(
                offset: Offset(-1, -1),
                color: Colors.grey[200],
              ),
            ]),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: isBlank(widget.articlesModel.urlToImage)
                      ? Text('No image', style: TextStyle(color: Colors.white),)
                      : Image.network(
                          widget.articlesModel.urlToImage,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  flex: 4,
                  child: Text(widget.articlesModel.title,
                      style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white))
                ),
              ],
            ),
            SizedBox(height: 5,),
            Text(
              widget.articlesModel.description ?? widget.articlesModel.content ?? "",
              style: Theme.of(context).textTheme.caption.copyWith(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
