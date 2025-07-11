part of 'gallery_bloc.dart';

abstract class GalleryState extends Equatable {
  const GalleryState();

  @override
  List<Object?> get props => [];
}

class GalleryInitial extends GalleryState {}

class GalleryLoading extends GalleryState {}

class AlbumsLoaded extends GalleryState {
  final List<Album> albums;
  final Map<int, List<Photo>> photosByAlbum;

  const AlbumsLoaded({required this.albums, required this.photosByAlbum});

  @override
  List<Object?> get props => [albums, photosByAlbum];

  AlbumsLoaded copyWith({
    List<Album>? albums,
    Map<int, List<Photo>>? photosByAlbum,
  }) {
    return AlbumsLoaded(
      albums: albums ?? this.albums,
      photosByAlbum: photosByAlbum ?? this.photosByAlbum,
    );
  }
}

class GalleryError extends GalleryState {
  final String message;

  const GalleryError(this.message);

  @override
  List<Object?> get props => [message];
}
