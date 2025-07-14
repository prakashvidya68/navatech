import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navatech_assignment/blocs/gallery_bloc/gallery_bloc.dart';
import 'package:navatech_assignment/widgets/infinite_gallery_row.dart';
import 'package:shimmer/shimmer.dart';

class GalleryView extends StatefulWidget {
  const GalleryView({super.key});

  @override
  State<GalleryView> createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  int _previousAlbumCount = 0;
  bool _isAddingToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isLoadingMore) return;

    // Check if user reached the top
    if (_scrollController.position.pixels <=
        _scrollController.position.minScrollExtent + 100) {
      if (!_isAddingToTop) {
        debugPrint('Reached top, adding albums to top');

        _isAddingToTop = true;
        final currentState = context.read<GalleryBloc>().state;
        if (currentState is AlbumsLoaded) {
          _previousAlbumCount = currentState.albums.length;
          debugPrint('Previous album count: $_previousAlbumCount');
        }
        context.read<GalleryBloc>().add(const AddAlbumsToTop());
      }
    }

    // Check if user reached the bottom
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      debugPrint('Reached bottom, adding albums to bottom');
      _isLoadingMore = true;
      context.read<GalleryBloc>().add(const AddAlbumsToBottom());
      _isLoadingMore = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GalleryBloc, GalleryState>(
        builder: (context, state) {
          if (state is GalleryInitial) {
            context.read<GalleryBloc>().add(LoadAlbums());
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GalleryLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is GalleryError) {
            return Center(child: Text(state.message));
          }
          final currentState = state as AlbumsLoaded;

          // Adjust scroll position when albums are added to top
          if (_isAddingToTop && _previousAlbumCount > 0) {
            debugPrint(
              'Adjusting scroll position. Current albums: ${currentState.albums.length}, Previous: $_previousAlbumCount',
            );
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // Future.delayed(const Duration(milliseconds: 10), () {
              if (_scrollController.hasClients) {
                final addedCount =
                    currentState.albums.length - _previousAlbumCount;
                // Each album item is approximately 240px (40px padding + ~200px content)
                final itemHeight = 240.0;
                final offsetToAdd = addedCount * itemHeight;
                debugPrint(
                  'Adding offset: $offsetToAdd, Current offset: ${_scrollController.offset}',
                );
                _scrollController.jumpTo(-100 - kToolbarHeight + offsetToAdd);
                _isAddingToTop = false;
                _previousAlbumCount = 0;
              }
              // });
            });
          }

          return getAlbumsList(currentState, context);
        },
      ),
    );
  }

  Widget getAlbumsList(AlbumsLoaded currentState, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.grey[200],
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: currentState.albums.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0, left: 8),
                  child: Text(
                    currentState.albums[index].title.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                getInfiniteScrollView(currentState, index),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget getInfiniteScrollView(AlbumsLoaded currentState, int index) {
    return InfiniteGalleryRow(
      albumId: currentState.albums[index].id,
      index: index,
    );
  }
}
