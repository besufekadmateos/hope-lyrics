import 'package:flutter/material.dart';
import '../models/song.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/* class SongDetailPage extends StatelessWidget {
  final Song song;
  const SongDetailPage(this.song, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(song.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(song.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              if (song.artist.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(song.artist,
                      style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.grey[700])),
                ),
              const SizedBox(height: 16),
              Text(song.lyrics, style: const TextStyle(fontSize: 16, height: 1.5)),
            ],
          ),
        ),
      ),
    );
  }
}
 */

class SongDetailPage extends StatefulWidget {
  final Song song;
  const SongDetailPage(this.song, {Key? key}) : super(key: key);

  @override
  _SongDetailPageState createState() => _SongDetailPageState();
}

class _SongDetailPageState extends State<SongDetailPage> {
  double _fontSize = 18.0;
  String _fontFamily = 'Roboto';
  final List<String> _fontOptions = ['Roboto', 'Open Sans', 'Lato', 'Montserrat', 'Raleway'];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _fontSize = prefs.getDouble('lyrics_font_size') ?? 18.0;
      _fontFamily = prefs.getString('lyrics_font_family') ?? 'Roboto';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('lyrics_font_size', _fontSize);
    await prefs.setString('lyrics_font_family', _fontFamily);
  }

  void _copyLyrics() {
    // Assuming your Song model has a lyrics property
    Clipboard.setData(ClipboardData(text: widget.song.lyrics));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Lyrics copied to clipboard!'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Lyrics Settings'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Font Size: ${_fontSize.toStringAsFixed(1)}'),
              Slider(
                value: _fontSize,
                min: 12.0,
                max: 32.0,
                divisions: 10,
                onChanged: (value) {
                  setState(() {
                    _fontSize = value;
                  });
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _fontFamily,
                decoration: InputDecoration(
                  labelText: 'Font Family',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: _fontOptions.map((String font) {
                  return DropdownMenuItem<String>(
                    value: font,
                    child: Text(font),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _fontFamily = value!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                this.setState(() {
                  _fontSize = _fontSize;
                  _fontFamily = _fontFamily;
                });
                _saveSettings();
                Navigator.pop(context);
              },
              child: Text('Save'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.song.title),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: _showSettingsDialog,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade50,
              Colors.deepPurple.shade100,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(maxWidth: 800),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Song information section
                    Row(
                      children: [
                        Icon(Icons.music_note, color: Colors.deepPurple, size: 28),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.song.title,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                widget.song.artist,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 24),

                    // Lyrics section

                    SizedBox(height: 16),

                    // Selectable lyrics text
                    SelectableText(
                      // Assuming your Song model has a lyrics property
                      widget.song.lyrics,
                      style: TextStyle(
                        fontSize: _fontSize,
                        fontFamily: _fontFamily,
                        height: 1.6,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.left,
                      toolbarOptions: ToolbarOptions(
                        copy: true,
                        selectAll: true,
                      ),
                      showCursor: true,
                      cursorColor: Colors.deepPurple,
                      cursorRadius: Radius.circular(2),
                      cursorWidth: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _copyLyrics,
        child: Icon(Icons.copy),
        backgroundColor: Colors.deepPurple,
        tooltip: 'Copy Lyrics',
      ),
    );
  }
}
