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
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
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
          return SizedBox(
            height: width * 0.4,
            child: ListView.builder(
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
