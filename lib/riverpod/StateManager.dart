import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tmdb_lite/models/ModelMovie.dart';
import 'package:flutter_tmdb_lite/utils/ApiSetup.dart';

class StateManager {
  final int? pageNumber;
  StateManager(this.pageNumber);

  static final movieStateFuture = FutureProvider<List<Movie>>((ref) async {
    return ApiSetup.getMovieList();
  });
}
