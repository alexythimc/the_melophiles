import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:the_melophiles/controllers/audio_controller.dart';
import 'package:the_melophiles/models/song_model.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final audioCtrl = Get.put(AudioController());

    return Column(
      children: [
        // ✅ Minimal App Bar (Recently added + buttons)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              bottom: BorderSide(color: Colors.grey.withOpacity(0.15)),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(onPressed: () {}, icon: Icon(Iconsax.sort)),

                  // Title
                  Text(
                    "Recently added",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              // Buttons
              Row(
                children: [
                  _roundButton(
                    icon: Iconsax.shuffle,
                    onTap: () async {
                      await audioCtrl.setQueueFromHive();
                      await audioCtrl.shufflePlay();
                    },
                    context: context,
                  ),
                  const SizedBox(width: 8),
                  _roundButton(
                    icon: Iconsax.play,

                    onTap: () async {
                      await audioCtrl.setQueueFromHive();
                      await audioCtrl.playIndex(0);
                    },
                    context: context,
                  ),
                ],
              ),
            ],
          ),
        ),

        // ✅ Your original ListView remains unchanged
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: Hive.box('songs').listenable(),
            builder: (context, box, _) {
              final maps = box.values
                  .whereType<Map>()
                  .map((m) => Map<String, dynamic>.from(m))
                  .toList();

              maps.sort(
                (a, b) => ((a['title'] as String?) ?? '')
                    .toLowerCase()
                    .compareTo(((b['title'] as String?) ?? '').toLowerCase()),
              );

              if (maps.isEmpty) {
                return const Center(
                  child: Text('No songs found. Open onboarding to scan.'),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: maps.length,
                separatorBuilder: (_, __) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(
                    height: 0.5,
                    thickness: 0.3,
                    color: Colors.grey.withOpacity(0.2),
                  ),
                ),
                itemBuilder: (context, index) {
                  final map = maps[index];
                  final song = Song.fromMap(Map<String, dynamic>.from(map));

                  return InkWell(
                    onTap: () async {
                      await audioCtrl.setQueueFromHive();
                      await audioCtrl.playIndex(index);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: (song.art != null)
                                ? Image.memory(
                                    base64Decode(song.art!),
                                    width: 56,
                                    height: 56,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    width: 56,
                                    height: 56,
                                    color: Colors.grey.shade300,
                                    child: const Icon(
                                      Icons.music_note,
                                      size: 28,
                                    ),
                                  ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  song.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  song.artist,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                          // IconButton(
                          //   icon: const Icon(Iconsax.play, size: 22),
                          //   onPressed: () async {
                          //     await audioCtrl.setQueueFromHive();
                          //     await audioCtrl.playIndex(index);
                          //   },
                          // ),
                          IconButton(
                            icon: const Icon(Icons.more_vert_rounded, size: 22),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                builder: (_) =>
                                    _buildSongOptions(context, song),
                              );
                            },
                          ),
                        ],
                      ),
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

  // 🎛 Round button builder
  Widget _roundButton({
    required IconData icon,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }

  Widget _buildSongOptions(BuildContext context, Song song) {
    return SafeArea(
      child: Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.favorite_border),
            title: const Text('Add to Favorites'),
            onTap: () {
              final favBox = Hive.box('favorites');
              if (favBox.containsKey(song.path)) {
                favBox.delete(song.path);
              } else {
                favBox.put(song.path, song.path);
              }
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.playlist_add),
            title: const Text('Add to Playlist'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Song Info'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
