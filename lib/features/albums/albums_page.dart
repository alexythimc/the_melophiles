import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:the_melophiles/controllers/audio_controller.dart';
import 'package:the_melophiles/models/song_model.dart';

class AlbumsPage extends StatelessWidget {
  const AlbumsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('songs');
    final songs = box.values
        .whereType<Map>()
        .map((m) => Song.fromMap(Map<String, dynamic>.from(m)))
        .toList();

    final Map<String, List<Song>> albums = {};
    for (final s in songs) {
      final key = (s.album.isEmpty) ? 'Unknown Album' : s.album;
      albums.putIfAbsent(key, () => []).add(s);
    }

    final entries = albums.entries.toList();
    final OnAudioQuery audioQuery = OnAudioQuery();

    return Scaffold(
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final albumName = entries[index].key;
          final tracks = entries[index].value;
          final firstTrack = tracks.first;

          return GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              Get.to(
                () => AlbumTracksPage(albumName: albumName, tracks: tracks),
              );
            },
            child: FutureBuilder<Uint8List?>(
              future: audioQuery.queryArtwork(
                int.tryParse(firstTrack.id?.toString() ?? '0') ?? 0,
                ArtworkType.AUDIO,
              ),

              builder: (context, snapshot) {
                final art = snapshot.data;
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: art != null
                        ? DecorationImage(
                            image: MemoryImage(art),
                            fit: BoxFit.cover,
                          )
                        : null,
                    gradient: art == null
                        ? const LinearGradient(
                            colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.black.withOpacity(0.4),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Iconsax.musicnote,
                            size: 48,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            albumName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${tracks.length} tracks',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class AlbumTracksPage extends StatelessWidget {
  final String albumName;
  final List<Song> tracks;
  const AlbumTracksPage({
    super.key,
    required this.albumName,
    required this.tracks,
  });

  @override
  Widget build(BuildContext context) {
    final audioCtrl = Get.find<AudioController>();
    return Scaffold(
      appBar: AppBar(title: Text(albumName)),
      body: ListView.separated(
        itemCount: tracks.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final s = tracks[index];
          return ListTile(
            leading: Text('${index + 1}'),
            title: Text(s.title),
            subtitle: Text(s.artist),
            onTap: () async {
              await audioCtrl.setQueueFromHive();
              final all = Hive.box('songs').keys.toList();
              final idx = all.indexOf(s.path);
              if (idx >= 0) await audioCtrl.playIndex(idx);
            },
          );
        },
      ),
    );
  }
}
