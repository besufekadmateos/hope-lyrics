import 'package:hive/hive.dart';

part 'song.g.dart';

@HiveType(typeId: 0)
class Song extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String lyrics;

  @HiveField(2)
  String artist;

  @HiveField(3)
  String category;

  Song({
    required this.title,
    required this.lyrics,
    this.artist = "",
    required this.category,
  });
}
