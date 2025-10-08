import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import '../models/song.dart';

class JsonLoader {
  static Future<void> loadSongs() async {
    Box<Song> box = Hive.box<Song>('songs');
    if (box.isNotEmpty) return;

    await _loadFromFile('assets/amharic.json', 'Amharic');
    await _loadFromFile('assets/oromo.json', 'Oromo');
    await _loadFromFile('assets/tigrigna.json', 'Tigrigna');
    await _loadFromFile('assets/wolayta.json', 'Wolayta');
    await _loadFromFile('assets/old.json', 'old');
    await _loadFromFile('assets/choir.json', 'choir');
  }

  static Future<void> _loadFromFile(String path, String category) async {
    String jsonString = await rootBundle.loadString(path);
    List<dynamic> data = json.decode(jsonString);

    for (var item in data) {
      final song = Song(
        title: item['title'] ?? '',
        lyrics: item['lyrics'] ?? '',
        artist: item['artist'] ?? '',
        category: category,
      );
      await Hive.box<Song>('songs').add(song);
    }
  }
}
