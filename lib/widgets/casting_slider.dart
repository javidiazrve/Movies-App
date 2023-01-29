import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peliculas_app/models/models.dart';

import '../services/services.dart';

class CastingSlider extends StatelessWidget {
  final int movieID;

  const CastingSlider({required this.movieID});

  @override
  Widget build(BuildContext context) {
    final moviesService = Get.find<MoviesService>();

    return FutureBuilder(
      future: moviesService.getCast(movieID),
      builder: (BuildContext context, AsyncSnapshot<List<Cast>> snapshot) {
        if (!snapshot.hasData) {
          return Container(
            height: 180,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final cast = snapshot.data!;

        return Container(
          width: double.infinity,
          height: 190,
          margin: EdgeInsets.only(bottom: 30, top: 10),
          child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: cast.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index) {
                return _CastingCard(
                  actor: cast[index],
                );
              }),
        );
      },
    );
  }
}

class _CastingCard extends StatelessWidget {
  final Cast actor;

  const _CastingCard({required this.actor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      width: 100,
      height: 120,
      // color: Colors.red,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              placeholder: AssetImage('assets/no-image.jpg'),
              image: NetworkImage(actor.fullProfilePath),
              height: 140,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                actor.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
