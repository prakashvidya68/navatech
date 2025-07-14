import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navatech_assignment/blocs/gallery_bloc/gallery_bloc.dart';
import 'package:shimmer/shimmer.dart';

class InfiniteGalleryRow extends StatefulWidget {
  const InfiniteGalleryRow({
    super.key,
    required this.albumId,
    required this.index,
  });
  final int albumId;
  final int index;

  @override
  State<InfiniteGalleryRow> createState() => _InfiniteGalleryRowState();
}

class _InfiniteGalleryRowState extends State<InfiniteGalleryRow> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  bool _isAddingToStart = false;
  int _previousPhotoCount = 0;
  bool _hasInitializedScroll = false;

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

    // Check if user reached the left end of horizontal list
    if (_scrollController.position.pixels <=
        _scrollController.position.minScrollExtent + 100) {
      if (!_isAddingToStart) {
        debugPrint(
          'Reached left end, adding more photos to start of album ${widget.albumId}',
        );
        _isAddingToStart = true;
        final currentState = context.read<GalleryBloc>().state;
        if (currentState is AlbumsLoaded) {
          _previousPhotoCount =
              currentState.photosByAlbum[widget.albumId]?.length ?? 0;
          debugPrint('Previous photo count: $_previousPhotoCount');
        }
        context.read<GalleryBloc>().add(AddPhotosToAlbumStart(widget.albumId));
      }
    }

    // Check if user reached the right end of horizontal list
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      debugPrint(
        'Reached right end, adding more photos to album ${widget.albumId}',
      );
      _isLoadingMore = true;
      context.read<GalleryBloc>().add(AddPhotosToAlbum(widget.albumId));
      _isLoadingMore = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GalleryBloc, GalleryState>(
      builder: (context, state) {
        if (state is! AlbumsLoaded) return const SizedBox.shrink();
        if (state.photosByAlbum[widget.albumId]?.isEmpty ?? true) {
          context.read<GalleryBloc>().add(LoadPhotosForAlbum(widget.albumId));
          return getShimerPhotos(state, widget.index, context);
        }
        if (state.photosByAlbum[widget.albumId]?.isNotEmpty ?? false) {
          final width = MediaQuery.of(context).size.width - 32;

          final photos = state.photosByAlbum[widget.albumId];
          final allPhotos = state.allPhotosByAlbum[widget.albumId];

          // Initialize scroll position to the beginning of the second set (middle section)
          if (!_hasInitializedScroll &&
              photos != null &&
              allPhotos != null &&
              photos.length == allPhotos.length * 3) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_scrollController.hasClients) {
                final itemWidth = width * 0.4 + 16; // width + margin
                final offsetToSecondSet = allPhotos.length * itemWidth;
                debugPrint(
                  'Initializing scroll position to offset: $offsetToSecondSet',
                );
                _scrollController.jumpTo(offsetToSecondSet);
                _hasInitializedScroll = true;
              }
            });
          }

          // Adjust scroll position when photos are added to start
          if (_isAddingToStart && _previousPhotoCount > 0) {
            debugPrint(
              'Adjusting scroll position. Current photos: ${photos?.length}, Previous: $_previousPhotoCount',
            );
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Future.delayed(const Duration(milliseconds: 10), () {
                if (_scrollController.hasClients) {
                  final addedCount =
                      (photos?.length ?? 0) - _previousPhotoCount;
                  // Each photo item is approximately 160px (40% of screen width - 32px padding)
                  final itemWidth = width * 0.4 + 16; // width + margin
                  final offsetToAdd = addedCount * itemWidth;
                  debugPrint(
                    'Adding offset: $offsetToAdd, Current offset: ${_scrollController.offset}',
                  );
                  _scrollController.jumpTo(offsetToAdd);
                  _isAddingToStart = false;
                  _previousPhotoCount = 0;
                }
              });
            });
          }

          return SizedBox(
            height: width * 0.4,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: photos?.length ?? 0,
              itemBuilder: (context, index) {
                return Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.only(right: 16),
                  width: width * 0.4,
                  height: width * 0.4,
                  child: CachedNetworkImage(
                    imageUrl: photos![index].thumbnailUrl,
                    fit: BoxFit.cover,
                    placeholder:
                        (context, url) => Image.network(
                          "https://picsum.photos/300/200.jpg",
                          fit: BoxFit.cover,
                        ),
                    errorWidget:
                        (context, url, error) => Image.network(
                          "https://picsum.photos/300/200.jpg",
                          fit: BoxFit.cover,
                        ),
                  ),
                );
              },
            ),
          );
        }
        return getShimerPhotos(state, widget.index, context);
      },
    );
  }

  Widget getShimerPhotos(
    AlbumsLoaded currentState,
    int index,
    BuildContext context,
  ) {
    final width = MediaQuery.of(context).size.width - 32;

    return SizedBox(
      height: width * 0.4,
      child: ListView.builder(
        itemCount: 6,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.only(right: 16),
              width: width * 0.4,
              height: width * 0.4,
            ),
          );
        },
      ),
    );
  }
}
