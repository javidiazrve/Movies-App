import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peliculas_app/services/movies.service.dart';
import 'pages/pages.dart';

void main() async {
  await initServices();
  runApp(const MyApp());
}

Future<void> initServices() async {
  await Get.putAsync(() async => await MoviesService());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peliculas',
      getPages: [
        GetPage(name: '/home', page: () => HomePage()),
        GetPage(name: '/details', page: () => DetailsPage())
      ],
      initialRoute: '/home',
      theme: ThemeData.light().copyWith(
        appBarTheme: const AppBarTheme(
          color: Colors.red,
        ),
      ),
    );
  }
}
