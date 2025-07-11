import 'package:navatech_assignment/models/models/album.dart';
import 'package:navatech_assignment/models/models/photo.dart';
import 'package:navatech_assignment/services/network_service/network_service.dart';
import 'package:navatech_assignment/services/network_service/network_service_impl.dart';

class GalleryRepo {
  final NetworkService _networkService = NetworkServiceImpl();

  Future<List<Album>> getAlbums() async {
    try {
      final response = await _networkService.get('/albums');
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch albums: ${response.statusCode}');
      }

      final List<dynamic> albumsData = response.data as List<dynamic>;

      // Mocking the response to get only 10 albums since there's no limit param in API
      // This improves performance and reduces unnecessary data loading
      final limitedAlbumsData = albumsData.take(10).toList();

      return limitedAlbumsData.map((json) => Album.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch albums: $e');
    }
  }

  Future<List<Photo>> getPhotosByAlbumId(int albumId) async {
    try {
      final response = await _networkService.get('/photos?albumId=$albumId');
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch photos: ${response.statusCode}');
      }
      final List<dynamic> photosData = response.data as List<dynamic>;

      // Mocking the response to get only 10 photos per album since there's no limit param in API
      // This improves performance and reduces unnecessary data loading
      final limitedPhotosData = photosData.take(10).toList();

      return limitedPhotosData.map((json) => Photo.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch photos for album $albumId: $e');
    }
  }
}
