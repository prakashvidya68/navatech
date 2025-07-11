import 'package:hive/hive.dart';

part 'photo.g.dart';

@HiveType(typeId: 1)
class Photo extends HiveObject {
  @HiveField(0)
  final int albumId;

  @HiveField(1)
  final int id;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String url;

  @HiveField(4)
  final String thumbnailUrl;

  Photo({
    required this.albumId,
    required this.id,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    // Since the provided API is not working, we'll generate URLs using picsum.photos
    // Seed format: {album_id}_{index} where index is the photo id
    final albumId = json['albumId'] as int;
    final photoId = json['id'] as int;
    final seed = '${albumId}_$photoId';

    return Photo(
      albumId: albumId,
      id: photoId,
      title: json['title'] as String,
      url:
          'https://picsum.photos/seed/$seed/600/400.jpg', // Full size image since the API is not working
      thumbnailUrl:
          'https://picsum.photos/seed/$seed/300/200.jpg', // Thumbnail since the API is not working
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'albumId': albumId,
      'id': id,
      'title': title,
      'url': url,
      'thumbnailUrl': thumbnailUrl,
    };
  }

  @override
  String toString() {
    return 'Photo(albumId: $albumId, id: $id, title: $title, url: $url, thumbnailUrl: $thumbnailUrl)';
  }
}
