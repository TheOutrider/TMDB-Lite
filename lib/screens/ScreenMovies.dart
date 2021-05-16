import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tmdb_lite/models/ModelMovie.dart';
import 'package:flutter_tmdb_lite/riverpod/StateManager.dart';
import 'package:flutter_tmdb_lite/utils/ApiSetup.dart';
import 'package:flutter_tmdb_lite/utils/AppWidgets.dart';
import 'package:flutter_tmdb_lite/utils/Constants.dart';
import 'package:flutter_tmdb_lite/utils/Helper.dart';

import 'ScreenDetails.dart';

class ScreenMovies extends StatefulWidget {
  @override
  _ScreenMoviesState createState() => _ScreenMoviesState();
}

class _ScreenMoviesState extends State<ScreenMovies> {
  TextEditingController controllerSearch = new TextEditingController();
  int pageNumber = 1;
  List<Movie> listMovies = [];
  bool isLoading = true, isSearching = false;

  searchMovie(String query) async {
    listMovies.clear();
    await ApiSetup.searchMovie(query).then((searchedMovieList) {
      searchedMovieList.forEach((movie) {
        listMovies.add(movie);
      });
    });
    setState(() {
      isLoading = false;
    });
  }

  Widget alertText(String title, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Text(
        title,
        style: TextStyle(color: color),
      ),
    );
  }

  Future<bool> willPop() async {
    showDialog(
        context: context,
        builder: (context) {
          if (Platform.isAndroid) {
            return AlertDialog(
              title: Text("Exit"),
              content: Text("Are you sure you want to Exit !"),
              actions: [
                InkWell(
                    onTap: () {
                      SystemNavigator.pop();
                    },
                    child: alertText('Yes', Color(0xFF212121))),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: alertText('No', Colors.red),
                )
              ],
            );
          } else if (Platform.isIOS) {
            return CupertinoAlertDialog(
              title: Text("Exit"),
              content: Text("Are you sure you want to Exit !"),
              actions: [
                CupertinoDialogAction(
                  child: Text(
                    "Yes",
                    style: TextStyle(color: Color(0xFF212121)),
                  ),
                  onPressed: () => exit(0),
                ),
                CupertinoDialogAction(
                  child: Text("No", style: TextStyle(color: Colors.red)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }
          return Container();
        });

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: willPop,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(4),
                  margin: EdgeInsets.only(top: 12, bottom: 18),
                  height: 53,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                          child: TextField(
                        onTap: () {
                          setState(() {
                            isSearching = false;
                          });
                        },
                        controller: controllerSearch,
                        onSubmitted: (value) {
                          setState(() {
                            isLoading = true;
                            isSearching = true;
                          });
                          searchMovie(value);
                        },
                        decoration: InputDecoration(
                            hintText: "Search Movies",
                            contentPadding:
                                EdgeInsets.only(left: 18, bottom: 8),
                            border: InputBorder.none),
                      )),
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: GestureDetector(
                            child: isSearching
                                ? Icon(Icons.clear)
                                : Icon(Icons.search),
                            onTap: () {
                              if (controllerSearch.text.isNotEmpty) {
                                if (!isSearching) {
                                  searchMovie(controllerSearch.text);
                                  isSearching = true;
                                } else {
                                  controllerSearch.clear();
                                  listMovies.clear();
                                  isSearching = false;
                                }
                                setState(() {
                                  isLoading = true;
                                });
                              }
                            }),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("TMDB ",
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Constants.colorLight)),
                      Text("Lite",
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Constants.colorTertiary)),
                    ],
                  ),
                ),
                isSearching
                    ? isLoading
                        ? Flexible(child: shimmer())
                        : Flexible(
                            child: ListView.builder(
                                itemCount: listMovies.length,
                                itemBuilder: (context, index) {
                                  var item = listMovies[index];
                                  return movieTile(item, context);
                                }))
                    : Flexible(child: MovieWidget())
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MovieWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context,
      T Function<T>(ProviderBase<Object, T> provider) watch) {
    AsyncValue<List<Movie>> movies = watch(StateManager.movieStateFuture);
    return movies.when(
        data: (movies) {
          return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                var item = movies[index];
                return movieTile(item, context);
              });
        },
        loading: () => shimmer(),
        error: (err, stack) => Container(
              alignment: Alignment.center,
              child: widgetError(err.toString()),
            ));
  }
}

Widget movieTile(item, context) {
  return GestureDetector(
    onTap: () {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ScreenDetails(
                title: item.title,
                overview: item.overview,
                releaseDate: item.releaseDate,
                voteCount: item.voteCount.toString(),
                voteAverage: item.voteAverage.toString(),
                imageUrl: "https://image.tmdb.org/t/p/w500${item.posterPath}",
              )));
    },
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
      ),
      margin: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(7), bottomLeft: Radius.circular(7)),
              child: FadeInImage(
                height: 160,
                width: 100,
                placeholder: AssetImage('assets/tmdb.jpg'),
                image: NetworkImage(
                    "https://image.tmdb.org/t/p/w500${item.posterPath}"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title! ?? "NA",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Constants.colorDark)),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0, bottom: 10),
                    child: Text(item.overview! ?? "NA",
                        maxLines: 3,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Constants.colorDark)),
                  ),
                  Text(
                      item.releaseDate != null
                          ? "Release Date : ${AppHelper.dateFormatter(item.releaseDate!)}"
                          : "Release Date : NA",
                      maxLines: 3,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Constants.colorLight)),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
