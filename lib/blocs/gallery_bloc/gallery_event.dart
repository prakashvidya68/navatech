part of 'gallery_bloc.dart';

abstract class GalleryEvent extends Equatable {
  const GalleryEvent();

  @override
  List<Object?> get props => [];
}

class LoadAlbums extends GalleryEvent {
  const LoadAlbums();
}

class LoadPhotosForAlbum extends GalleryEvent {
  final int albumId;

  const LoadPhotosForAlbum(this.albumId);

  @override
  List<Object?> get props => [albumId];
}

class RefreshData extends GalleryEvent {
  const RefreshData();
}

class AddAlbumsToTop extends GalleryEvent {
  const AddAlbumsToTop();
}

class AddAlbumsToBottom extends GalleryEvent {
  const AddAlbumsToBottom();
}

class AddPhotosToAlbum extends GalleryEvent {
  final int albumId;

  const AddPhotosToAlbum(this.albumId);

  @override
  List<Object?> get props => [albumId];
}

class AddPhotosToAlbumStart extends GalleryEvent {
  final int albumId;

  const AddPhotosToAlbumStart(this.albumId);

  @override
  List<Object?> get props => [albumId];
}
