import 'dart:convert';

import 'package:peliculas_app/models/models.dart';

class PopularesResponse {
  PopularesResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  int page;
  List<Movie> results;
  int totalPages;
  int totalResults;

  factory PopularesResponse.fromJson(String str) =>
      PopularesResponse.fromMap(json.decode(str));

  factory PopularesResponse.fromMap(Map<String, dynamic> json) =>
      PopularesResponse(
        page: json["page"],
        results: List<Movie>.from(json["results"].map((x) => Movie.fromMap(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );
}
