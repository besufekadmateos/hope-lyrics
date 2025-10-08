import 'package:flutter/material.dart';
import 'artist_list_page.dart';
import 'song_list_by_category.dart';

class HomePage extends StatelessWidget {
  final List<String> categories = ["Amharic", "old", "choir", "Oromo", "Tigrigna", "Wolayta"];

  HomePage({super.key});

  @override
  Widget build(BuildContext contrext) {
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Lyrics App"),
          bottom: TabBar(
            isScrollable: true,
            tabs: categories.map((c) => Tab(text: c)).toList(),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          margin: EdgeInsets.all(16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: TabBarView(
              children: categories.map((c) {
                if (c == "Amharic") {
                  return ArtistListPage(category: c);
                }
                return SongListByCategory(category: c);
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
