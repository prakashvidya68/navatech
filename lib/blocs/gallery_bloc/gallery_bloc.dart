import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navatech_assignment/models/models/album.dart';
import 'package:navatech_assignment/models/models/photo.dart';
import 'package:navatech_assignment/repositories/gallery_repo.dart';
import 'package:navatech_assignment/services/cache_service/cache_service.dart';
import 'package:navatech_assignment/services/cache_service/cache_service_impl.dart';

part 'gallery_event.dart';
part 'gallery_state.dart';

class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  final GalleryRepo galleryRepo = GalleryRepo();
  final CacheService cacheService = CacheServiceImpl();

  GalleryBloc() : super(GalleryInitial()) {
    on<LoadAlbums>(_onLoadAlbums);
    on<LoadPhotosForAlbum>(_onLoadPhotosForAlbum);
    on<RefreshData>(_onRefreshData);
    on<AddAlbumsToTop>(_onAddAlbumsToTop);
    on<AddAlbumsToBottom>(_onAddAlbumsToBottom);
  }

  FutureOr<void> _onLoadAlbums(
    LoadAlbums event,
    Emitter<GalleryState> emit,
  ) async {
    emit(GalleryLoading());
    try {
      final cachedAlbums = await cacheService.getAll<Album>('albums');
      if (cachedAlbums.isNotEmpty) {
        // On first load, add albums to top to make it feel infinite
        final albumsWithTop = [...cachedAlbums, ...cachedAlbums];
        emit(
          AlbumsLoaded(
            albums: albumsWithTop,
            allAlbums: cachedAlbums,
            photosByAlbum: {},
            hasAlbumsAtTop: true,
          ),
        );
      }
      final albums = await galleryRepo.getAlbums();
      await cacheService.putAll<Album>('albums', albums);
      // On first load, add albums to top to make it feel infinite
      final albumsWithTop = [...albums, ...albums];
      emit(
        AlbumsLoaded(
          albums: albumsWithTop,
          allAlbums: albums,
          photosByAlbum: {},
          hasAlbumsAtTop: true,
        ),
      );
    } catch (e) {
      emit(GalleryError(e.toString()));
    }
  }

  FutureOr<void> _onLoadPhotosForAlbum(
    LoadPhotosForAlbum event,
    Emitter<GalleryState> emit,
  ) async {
    final currentState = state;
    if (currentState is! AlbumsLoaded) {
      return;
    }

    try {
      final cachedPhotos = await cacheService.getAll<Photo>(
        'photos_album_${event.albumId}',
      );
      if (cachedPhotos.isNotEmpty) {
        emit(
          currentState.copyWith(
            photosByAlbum: {
              ...currentState.photosByAlbum,
              ...{event.albumId: cachedPhotos},
            },
          ),
        );
        return;
      }
      final photos = await galleryRepo.getPhotosByAlbumId(event.albumId);
      await cacheService.putAll<Photo>('photos_album_${event.albumId}', photos);
      emit(
        currentState.copyWith(
          photosByAlbum: {
            ...currentState.photosByAlbum,
            ...{event.albumId: photos},
          },
        ),
      );
    } catch (e) {
      emit(GalleryError(e.toString()));
    }
  }

  FutureOr<void> _onRefreshData(
    RefreshData event,
    Emitter<GalleryState> emit,
  ) async {
    emit(GalleryLoading());
    try {
      await cacheService.clear();
      add(const LoadAlbums());
    } catch (e) {
      emit(GalleryError(e.toString()));
    }
  }

  FutureOr<void> _onAddAlbumsToTop(
    AddAlbumsToTop event,
    Emitter<GalleryState> emit,
  ) async {
    final currentState = state;
    if (currentState is! AlbumsLoaded) {
      return;
    }

    // Add a copy of original albums to the top
    // allAlbums contains the original unique albums, so we add them to the top
    final updatedAlbums = [...currentState.allAlbums, ...currentState.albums];
    emit(currentState.copyWith(albums: updatedAlbums, hasAlbumsAtTop: true));
  }

  FutureOr<void> _onAddAlbumsToBottom(
    AddAlbumsToBottom event,
    Emitter<GalleryState> emit,
  ) async {
    final currentState = state;
    if (currentState is! AlbumsLoaded) {
      return;
    }

    // Add a copy of all albums to the bottom
    final updatedAlbums = [...currentState.albums, ...currentState.allAlbums];
    emit(currentState.copyWith(albums: updatedAlbums));
  }
}
