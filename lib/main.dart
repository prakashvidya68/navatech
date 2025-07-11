import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navatech_assignment/blocs/gallery_bloc/gallery_bloc.dart';
import 'package:navatech_assignment/views/gallery_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => GalleryBloc())],
      child: MaterialApp(
        title: 'Navatech',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const GalleryView(),
      ),
    );
  }
}
