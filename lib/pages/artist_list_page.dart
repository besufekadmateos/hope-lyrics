import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/song.dart';
import 'song_list_by_artist.dart';

class ArtistListPage extends StatefulWidget {
  final String category;
  const ArtistListPage({super.key, required this.category});

  @override
  _ArtistListPageState createState() => _ArtistListPageState();
}

class _ArtistListPageState extends State<ArtistListPage> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    Box<Song> songBox = Hive.box<Song>('songs');

    return Column(
      children: [
        // 🔍 Search bar
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: "Search artist...",
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

        // 🎵 Artist list
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: songBox.listenable(),
            builder: (context, Box<Song> box, _) {
              var songs = box.values.where((s) => s.category == widget.category && s.artist.isNotEmpty).toList();

              var artists = songs.map((s) => s.artist).toSet().toList();

              // ✅ Apply search filter
              if (searchQuery.isNotEmpty) {
                artists = artists.where((a) => a.toLowerCase().contains(searchQuery)).toList();
              }

              if (artists.isEmpty) {
                return const Center(child: Text("No artists found"));
              }

              return ListView.builder(
                itemCount: artists.length,
                itemBuilder: (context, index) {
                  final artist = artists[index];
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      leading: Icon(
                        Icons.person,
                        color: Theme.of(context).primaryColor,
                        size: 28,
                      ),
                      title: Text(
                        artist,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Theme.of(context).primaryColor,
                        size: 20,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SongListByArtist(
                              artist: artist,
                              category: widget.category,
                            ),
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
    );
  }
}
