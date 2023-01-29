import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas_app/helpers/debouncer.dart';
import 'package:peliculas_app/models/models.dart';
import 'package:peliculas_app/models/search_movies_response.dart';

class MoviesService extends GetxService {
  String _baseUrl = 'api.themoviedb.org';
  String _apiKey = '11163ecd337ca9f7e80642696c7f56a6';
  String _language = 'es-ES';

  Map<int, List<Cast>> movieActors = {};

  final debouncer = Debouncer(duration: Duration(milliseconds: 500));

  final StreamController<List<Movie>> _suggestionStreamController =
      StreamController.broadcast();

  Stream<List<Movie>> get suggestionStream =>
      _suggestionStreamController.stream;

  MoviesService() {}

  _getJsonData(String endpoint, [int page = 1]) async {
    final url = Uri.https(
      _baseUrl,
      endpoint,
      {'api_key': _apiKey, 'language': _language, 'page': '$page'},
    );

    final response = await http.get(url);
    return response.body;
  }

  Future<List<Movie>> getEstrenos() async {
    final jsonData = await _getJsonData('3/movie/now_playing');
    final estrenosResponse = EstrenosResponse.fromJson(jsonData);
    return estrenosResponse.results;
  }

  Future<List<Movie>> getPopulares([page = 1]) async {
    final jsonData = await _getJsonData('3/movie/popular', page);
    final popularesResponse = PopularesResponse.fromJson(jsonData);
    return popularesResponse.results;
  }

  Future<List<Cast>> getCast(int movieId) async {
    if (movieActors.containsKey(movieId)) return movieActors[movieId]!;

    final jsonData = await _getJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson(jsonData);

    movieActors[movieId] = creditsResponse.cast;

    return creditsResponse.cast;
  }

  Future<List<Movie>> searchMovies(String query) async {
    Future.delayed(const Duration(milliseconds: 150));

    final url = Uri.https(
      _baseUrl,
      '3/search/movie',
      {
        'api_key': _apiKey,
        'language': _language,
        'query': query,
      },
    );

    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson(response.body);

    return searchResponse.results;
  }

  /* USADO PARA IMPLEMENTACION DE UN DEBOUNCER
    void getSuggestionsByQuery(String searchTerm) {
      debouncer.value = '';
      debouncer.onValue = (value) async {
        final results = await searchMovies(value);
        _suggestionStreamController.add(results);
      };

      final timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
        debouncer.value = searchTerm;
      });

      Future.delayed(const Duration(milliseconds: 301))
          .then((_) => timer.cancel());
    }
  */
}
