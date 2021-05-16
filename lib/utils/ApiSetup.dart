import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_tmdb_lite/utils/Constants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tmdb_lite/models/ModelMovie.dart';

class ApiSetup {
  static List<Movie> parsePhotos(String responseBody) {
    List<Movie> listMovies = [];
    for (var mov in jsonDecode(responseBody)['results']) {
      final movie = Movie.fromJson(mov);
      listMovies.add(movie);
    }
    return listMovies;
  }

  static Future<List<Movie>> getMovieList() async {
    final response = await http.get(Uri.parse(
        "https://api.themoviedb.org/3/movie/now_playing?api_key=${Constants.apiKey}&language=en-US&page=1"));
    if (response.statusCode == 200) {
      return compute(parsePhotos, response.body);
    } else {
      print("Error here");
    }
    throw Exception("Some Random Error");
  }

  static Future<List<Movie>> searchMovie(String query) async {
    List<Movie> listMovies = [];
    String apiUrl =
        "https://api.themoviedb.org/3/search/movie?api_key=${Constants.apiKey}&language=en-US&page=1&include_adult=false&query=$query";
    await http.get(Uri.parse(apiUrl)).then((response) {
      if (response.statusCode == 200) {
        for (var mov in jsonDecode(response.body)['results']) {
          final movie = Movie.fromJson(mov);
          listMovies.add(movie);
        }
      }
    });
    return listMovies;
  }

  static Future<List<Movie>> randomMovie() async {
    List<Movie> listMovies = [];
    var random = Random();
    int number = random.nextInt(20);
    String apiUrl =
        "https://api.themoviedb.org/3/movie/now_playing?api_key=${Constants.apiKey}&language=en-US&page=$number";
    await http.get(Uri.parse(apiUrl)).then((response) {
      if (response.statusCode == 200) {
        for (var mov in jsonDecode(response.body)['results']) {
          final movie = Movie.fromJson(mov);
          listMovies.add(movie);
        }
      }
    });
    return listMovies;
  }
}
