import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/models.dart';

class MovieSlider extends StatefulWidget {
  String category;
  List<Movie> movies;
  Function onNextPage;

  MovieSlider({
    super.key,
    required this.category,
    required this.movies,
    required this.onNextPage,
  });

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {
  final ScrollController scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 500) {
        widget.onNextPage();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(widget.category,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
                controller: scrollController,
                itemCount: widget.movies.length,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (_, int index) {
                  final movie = widget.movies[index];
                  movie.heroId = 'slider-${movie.id}';
                  return _MoviePoster(movie: movie);
                }),
          ),
        ],
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  Movie movie;
  _MoviePoster({required this.movie});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 280,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Get.toNamed('details', arguments: movie),
            child: Hero(
              tag: movie.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: AssetImage('assets/loading.gif'),
                  image: NetworkImage(movie.fullPosterUrl),
                  fit: BoxFit.cover,
                  height: 200,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            movie.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
