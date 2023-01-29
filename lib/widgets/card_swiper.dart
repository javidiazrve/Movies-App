import 'package:flutter/material.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:get/get.dart';

import '../models/models.dart';

class CardSwiper extends StatelessWidget {
  List<Movie> movies;

  CardSwiper({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height * 0.5,
      // color: Colors.amber,
      child: Swiper(
        physics: const BouncingScrollPhysics(),
        itemCount: movies.length,
        layout: SwiperLayout.STACK,
        itemWidth: size.width * 0.6,
        itemHeight: size.height * 0.4,
        itemBuilder: (_, index) {
          final movie = movies[index];
          movie.heroId = 'swipper-${movie.id}';

          return GestureDetector(
            onTap: () => Get.toNamed('details', arguments: movie),
            child: Hero(
              tag: movie.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: AssetImage('assets/loading.gif'),
                  image: NetworkImage(movie.fullPosterUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
