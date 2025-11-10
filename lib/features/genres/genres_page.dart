import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:the_melophiles/models/song_model.dart';

class GenresPage extends StatelessWidget {
  const GenresPage({super.key});

  @override
  Widget build(BuildContext context) {
    final songsBox = Hive.box('songs');
    final songs = songsBox.values
        .whereType<Map>()
        .map((m) => Song.fromMap(Map<String, dynamic>.from(m)))
        .toList();
    final Map<String, List<Song>> genres = {};
    for (final s in songs) {
      final key = (s.album.isEmpty)
          ? 'Unknown'
          : s.album; // metadata may not have genre; using album as placeholder
      genres.putIfAbsent(key, () => []).add(s);
    }
    final entries = genres.entries.toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Genres')),
      body: ListView.separated(
        itemCount: entries.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final name = entries[index].key;
          final list = entries[index].value;
          return ListTile(
            title: Text(name),
            subtitle: Text('${list.length} tracks'),
            onTap: () {},
          );
        },
      ),
    );
  }
}
