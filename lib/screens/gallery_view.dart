import 'package:flutter/material.dart';

class MyGallery extends StatelessWidget {
  const MyGallery({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Infinite Gallery'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const Center(child: Text('Gallery implementation coming soon...')),
    );
  }
}
