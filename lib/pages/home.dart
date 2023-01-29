import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peliculas_app/models/movie.dart';
import 'package:peliculas_app/search/search_delegate.dart';
import '../services/services.dart';
import '../widgets/widgets.dart';

class HomePage extends StatelessWidget {
  late HomeController homeCtrl;

  HomePage() {
    homeCtrl = Get.put(HomeController());
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    loading() {
      return Container(
        width: double.infinity,
        height: size.height * 0.5,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Peliculas'),
        elevation: 0,
        actions: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: IconButton(
              icon: Icon(Icons.search_outlined),
              onPressed: () =>
                  showSearch(context: context, delegate: MovieSearchDelegate()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Obx(
          () => Column(
            children: [
              // Tarjetas de peliculas
              homeCtrl.cargandoEstrenos.value
                  ? loading()
                  : CardSwiper(
                      movies: homeCtrl.estrenos,
                    ),

              // Slider de peliculas
              homeCtrl.cargandoPopulares.value
                  ? loading()
                  : MovieSlider(
                      category: 'Populares',
                      movies: homeCtrl.populares,
                      onNextPage: () => homeCtrl.getPopulares(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeController extends GetxController {
  late List<Movie> estrenos = [];
  RxList<Movie> _populares = <Movie>[].obs;
  Rx<bool> cargandoEstrenos = true.obs;
  Rx<bool> cargandoPopulares = true.obs;

  bool buscandoPopulares = false;
  int popularPage = 0;

  final moviesService = Get.find<MoviesService>();

  HomeController() {
    getEstrenos();
    getPopulares();
  }

  getEstrenos() async {
    estrenos = await moviesService.getEstrenos();
    cargandoEstrenos.value = false;
  }

  getPopulares() async {
    if (!buscandoPopulares) {
      buscandoPopulares = true;
      popularPage++;
      populares = await moviesService.getPopulares(popularPage);
      cargandoPopulares.value = false;
      buscandoPopulares = false;
    }
  }

  set populares(List<Movie> movies) {
    _populares.value += movies;
    _populares.refresh();
  }

  List<Movie> get populares {
    return _populares.toList();
  }
}
