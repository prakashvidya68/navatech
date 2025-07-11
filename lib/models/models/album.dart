import 'package:hive/hive.dart';

part 'album.g.dart';

@HiveType(typeId: 0)
class Album extends HiveObject {
  @HiveField(0)
  final int userId;

  @HiveField(1)
  final int id;

  @HiveField(2)
  final String title;

  Album({required this.userId, required this.id, required this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'userId': userId, 'id': id, 'title': title};
  }

  @override
  String toString() {
    return 'Album(userId: $userId, id: $id, title: $title)';
  }
}
