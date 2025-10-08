import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/song.dart';
import 'song_detail_page.dart';

class SongListByCategory extends StatefulWidget {
  final String category;
  const SongListByCategory({super.key, required this.category});

  @override
  _SongListByCategoryState createState() => _SongListByCategoryState();
}

class _SongListByCategoryState extends State<SongListByCategory> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    Box<Song> songBox = Hive.box<Song>('songs');

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: "Search in ${widget.category}...",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value.toLowerCase();
              });
            },
          ),
        ),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: songBox.listenable(),
            builder: (context, Box<Song> box, _) {
              var filteredSongs = box.values.where((s) => s.category == widget.category).toList();

              if (searchQuery.isNotEmpty) {
                filteredSongs = filteredSongs.where((s) {
                  return s.title.toLowerCase().contains(searchQuery) || s.lyrics.toLowerCase().contains(searchQuery);
                }).toList();
              }

              if (filteredSongs.isEmpty) {
                return const Center(child: Text("No songs found"));
              }

              return ListView.builder(
                itemCount: filteredSongs.length,
                itemBuilder: (context, index) {
                  Song song = filteredSongs[index];
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      leading: Icon(
                        Icons.music_note,
                        color: Theme.of(context).primaryColor,
                        size: 28,
                      ),
                      title: Text(
                        song.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        song.artist,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      trailing: Icon(
                        Icons.play_arrow,
                        color: Theme.of(context).primaryColor,
                        size: 28,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => SongDetailPage(song)),
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
    );
  }
}
