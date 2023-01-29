import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peliculas_app/services/movies.service.dart';

import '../models/models.dart';

class MovieSearchDelegate extends SearchDelegate {
  late MoviesService moviesService;

  MovieSearchDelegate() {
    moviesService = Get.find();
  }

  @override
  // TODO: implement searchFieldLabel
  String get searchFieldLabel => 'Buscar Pelicula';

  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: const Icon(
        Icons.arrow_back_ios_new,
        color: Colors.red,
      ),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults

    return FutureBuilder(
        future: moviesService.searchMovies(query),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return _emptyContainer();

          final movies = snapshot.data!;

          return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: movies.length,
            itemBuilder: (_, index) => _MovieItem(movie: movies[index]),
          );
        });
  }

  Widget _emptyContainer() {
    return Center(
      child: SizedBox(
        height: 150,
        child: Column(
          children: const [
            Icon(
              Icons.error_outline,
              color: Colors.black38,
              size: 130,
            ),
            Text('No se encontró ninguna pelicula.')
          ],
        ),
      ),
    );
  }

  Widget _mensajePrincipal() {
    return Center(
      child: SizedBox(
        height: 150,
        child: Column(
          children: const [
            Icon(
              Icons.movie_filter_outlined,
              color: Colors.black38,
              size: 130,
            ),
            Text('Busca tu pelicula favorita.')
          ],
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    if (query.isEmpty) return _mensajePrincipal();

    final MoviesService movieService = Get.find();

    /* 
      DEBOUNCER

      movieService.getSuggestionsByQuery(query);
    
      return StreamBuilder(
      stream: movieService.getSuggestionsByQuery(query),
      builder: (_, snapshot) {
        if (!snapshot.hasData) return _emptyContainer();

        final movies = snapshot.data!;

        return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: movies.length,
            itemBuilder: (_, index) => _MovieItem(movie: movies[index]));
      },
    );
    */

    return FutureBuilder(
      future: movieService.searchMovies(query),
      builder: (_, snapshot) {
        if (!snapshot.hasData || snapshot.data?.length == 0)
          return _emptyContainer();

        final movies = snapshot.data!;

        return ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: movies.length,
          itemBuilder: (_, index) => _MovieItem(movie: movies[index]),
        );
      },
    );
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;
  const _MovieItem({required this.movie});

  @override
  Widget build(BuildContext context) {
    movie.heroId = 'search-${movie.id}';

    return ListTile(
      leading: Hero(
        tag: movie.heroId!,
        child: FadeInImage(
          image: NetworkImage(movie.fullPosterUrl),
          placeholder: AssetImage('assets/no-image.jpg'),
          width: 50,
          height: 100,
          fit: BoxFit.contain,
        ),
      ),
      title: Text(movie.title),
      subtitle: Text(movie.originalTitle),
      onTap: () {
        Get.toNamed('details', arguments: movie);
      },
    );
  }
}
