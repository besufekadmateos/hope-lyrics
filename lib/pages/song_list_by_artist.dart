import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/song.dart';
import 'song_detail_page.dart';

class SongListByArtist extends StatefulWidget {
  final String artist;
  final String category;

  const SongListByArtist({super.key, required this.artist, required this.category});

  @override
  _SongListByArtistState createState() => _SongListByArtistState();
}

class _SongListByArtistState extends State<SongListByArtist> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    Box<Song> songBox = Hive.box<Song>('songs');

    return Scaffold(
      appBar: AppBar(title: Text(widget.artist)),
      body: Column(
        children: [
          // 🔍 Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Search songs...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),

          // 🎵 Song list
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: songBox.listenable(),
              builder: (context, Box<Song> box, _) {
                var songs =
                    box.values.where((s) => s.category == widget.category && s.artist == widget.artist).toList();

                // ✅ Apply search filter
                if (searchQuery.isNotEmpty) {
                  songs = songs
                      .where((s) =>
                          s.title.toLowerCase().contains(searchQuery) || s.lyrics.toLowerCase().contains(searchQuery))
                      .toList();
                }

                if (songs.isEmpty) {
                  return const Center(child: Text("No songs found"));
                }

                return ListView.builder(
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    Song song = songs[index];
                    return Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        title: Text(
                          song.title,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          song.artist,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        trailing: Icon(Icons.play_arrow, color: Theme.of(context).primaryColor),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SongDetailPage(song),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
