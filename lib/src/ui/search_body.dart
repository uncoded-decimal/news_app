import 'package:Headlines/src/blocs/search_bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      bloc: BlocProvider.of<SearchBloc>(context),
      buildWhen: (previous, current) {
        if (current is SearchLoading ||
            current is GlobalSearchResultsObtained ||
            current is SearchInit) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        if (state is SearchLoading) {
          return LinearProgressIndicator();
        } else if (state is GlobalSearchResultsObtained) {
          return ListView.builder(
            itemCount: state.newsModel.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[700],
                ),
                margin: EdgeInsets.all(3),
                child: ListTile(
                  onTap: () async {
                    if (await canLaunch(state.newsModel.elementAt(index).url)) {
                      await launch(state.newsModel.elementAt(index).url);
                    } else {
                      throw 'Could not launch ${state.newsModel.elementAt(index).url}';
                    }
                  },
                  title: Text(
                    state.newsModel.elementAt(index).title,
                    style: Theme.of(context).textTheme.subtitle2.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF64ffda),
                        ),
                  ),
                  subtitle: Text(
                    state.newsModel.elementAt(index).description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
              );
            },
          );
        } else if (state is SearchInit) {
          return LimitedBox(
            child: state.keys.isNotEmpty
                ? Wrap(
                    children: state.keys
                        .map((e) => GestureDetector(
                              onTap: () {
                                BlocProvider.of<SearchBloc>(context)
                                    .add(FetchSearchResults(e));
                              },
                              child: Chip(
                                label: Text(e),
                              ),
                            ))
                        .toList(),
                    spacing: 3,
                    runSpacing: 0.0,
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.start,
                  )
                : Container(),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
