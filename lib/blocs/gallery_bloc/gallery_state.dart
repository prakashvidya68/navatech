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
  final List<Album> allAlbums; // Original albums for infinite scrolling
  final Map<int, List<Photo>> photosByAlbum;
  final Map<int, List<Photo>>
  allPhotosByAlbum; // All photos for infinite scrolling
  final bool hasAlbumsAtTop; // Track if albums have been added to top

  const AlbumsLoaded({
    required this.albums,
    required this.allAlbums,
    required this.photosByAlbum,
    required this.allPhotosByAlbum,
    this.hasAlbumsAtTop = false,
  });

  @override
  List<Object?> get props => [
    albums,
    allAlbums,
    photosByAlbum,
    allPhotosByAlbum,
    hasAlbumsAtTop,
  ];

  AlbumsLoaded copyWith({
    List<Album>? albums,
    List<Album>? allAlbums,
    Map<int, List<Photo>>? photosByAlbum,
    Map<int, List<Photo>>? allPhotosByAlbum,
    bool? hasAlbumsAtTop,
  }) {
    return AlbumsLoaded(
      albums: albums ?? this.albums,
      allAlbums: allAlbums ?? this.allAlbums,
      photosByAlbum: photosByAlbum ?? this.photosByAlbum,
      allPhotosByAlbum: allPhotosByAlbum ?? this.allPhotosByAlbum,
      hasAlbumsAtTop: hasAlbumsAtTop ?? this.hasAlbumsAtTop,
    );
  }
}

class GalleryError extends GalleryState {
  final String message;

  const GalleryError(this.message);

  @override
  List<Object?> get props => [message];
}
