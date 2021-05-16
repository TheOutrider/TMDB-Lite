import 'package:flutter/material.dart';
import 'package:flutter_tmdb_lite/models/ModelMovie.dart';
import 'package:flutter_tmdb_lite/utils/ApiSetup.dart';
import 'package:flutter_tmdb_lite/utils/Constants.dart';
import 'package:flutter_tmdb_lite/utils/Helper.dart';
import 'dart:io' show Platform;
import 'ScreenImage.dart';

class ScreenDetails extends StatefulWidget {
  final String? imageUrl, title, overview, releaseDate, voteCount, voteAverage;

  ScreenDetails({
    this.imageUrl,
    this.title,
    this.overview,
    this.releaseDate,
    this.voteCount,
    this.voteAverage,
  });

  @override
  _ScreenDetailsState createState() => _ScreenDetailsState();
}

class _ScreenDetailsState extends State<ScreenDetails> {
  List<Movie> listMovies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getMovieData();
  }

  getMovieData() async {
    await ApiSetup.randomMovie().then((movieList) {
      movieList.forEach((movie) {
        listMovies.add(movie);
      });
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ScreenImageView(imageUrl: widget.imageUrl!)));
                  },
                  child: FadeInImage(
                    height: 300,
                    width: double.infinity,
                    placeholder: AssetImage('assets/tmdb.jpg'),
                    image: NetworkImage(widget.imageUrl!),
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Constants.colorLight,
                        Constants.colorTertiary
                      ]),
                      shape: BoxShape.circle),
                  margin: EdgeInsets.only(top: 35, left: 5),
                  child: IconButton(
                    color: Colors.white,
                    icon: Icon(Platform.isIOS
                        ? Icons.arrow_back_ios
                        : Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0, bottom: 8),
                    child: Text(widget.title!,
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Constants.colorDark)),
                  ),
                  Text(widget.overview!,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF1C1B1B))),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    child: Text(
                        "Release Date : " +
                            AppHelper.dateFormatter(widget.releaseDate!),
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            color: Constants.colorTertiary)),
                  ),
                  Text("Vote Count : " + widget.voteCount!,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Constants.colorLight)),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text("Vote Average : " + widget.voteAverage!,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Constants.colorLight)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 18.0, top: 5),
                    child: Divider(
                      thickness: 2,
                      color: Colors.grey[300],
                    ),
                  ),
                  Text("More from us",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Constants.colorDark)),
                  isLoading
                      ? Center(
                          child: Padding(
                              padding: EdgeInsets.all(28),
                              child: CircularProgressIndicator()),
                        )
                      : listMovies.length == 0
                          ? Text("WERROR")
                          : Container(
                              margin: EdgeInsets.only(top: 16),
                              height: 160,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: listMovies.length,
                                  itemBuilder: (context, index) {
                                    var item = listMovies[index];
                                    return Container(
                                      height: 160,
                                      width: 120,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ScreenDetails(
                                                        title: item.title,
                                                        overview: item.overview,
                                                        releaseDate:
                                                            item.releaseDate,
                                                        voteCount: item
                                                            .voteCount
                                                            .toString(),
                                                        voteAverage: item
                                                            .voteAverage
                                                            .toString(),
                                                        imageUrl:
                                                            "https://image.tmdb.org/t/p/w500${item.posterPath}",
                                                      )));
                                        },
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          margin: EdgeInsets.only(
                                              right: 16, bottom: 5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(5),
                                                    topRight:
                                                        Radius.circular(5)),
                                                child: FadeInImage(
                                                  height: 120,
                                                  width: 120,
                                                  placeholder: AssetImage(
                                                      'assets/tmdb.jpg'),
                                                  image: NetworkImage(
                                                      "https://image.tmdb.org/t/p/w500${item.posterPath}"),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Flexible(
                                                  child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Text(item.title!,
                                                    textAlign:
                                                        TextAlign.justify,
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Constants
                                                            .colorDark)),
                                              ))
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
