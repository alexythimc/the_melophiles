import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:the_melophiles/controllers/audio_controller.dart';
import 'package:the_melophiles/models/song_model.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final audioCtrl = Get.put(AudioController());
    final favBox = Hive.box('favorites');
    final songsBox = Hive.box('songs');

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: ValueListenableBuilder(
        valueListenable: favBox.listenable(),
        builder: (context, box, _) {
          final keys = box.keys.toList();
          if (keys.isEmpty)
            return const Center(child: Text('No favorites yet'));
          return ListView.separated(
            itemCount: keys.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final id = box.get(keys[index]) as String? ?? '';
              final map = songsBox.get(id) as Map?;
              if (map == null) return const SizedBox();
              final song = Song.fromMap(Map<String, dynamic>.from(map));
              return ListTile(
                title: Text(song.title),
                subtitle: Text(song.artist),
                trailing: IconButton(
                  icon: const Icon(Icons.playlist_play),
                  onPressed: () async {
                    await audioCtrl.setQueueFromHive();
                    final all = Hive.box('songs').keys.toList();
                    final idx = all.indexOf(song.path);
                    if (idx >= 0) await audioCtrl.playIndex(idx);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
