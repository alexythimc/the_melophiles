import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart'
    show TyperAnimatedText, AnimatedTextKit;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_melophiles/models/song_model.dart';
import 'package:the_melophiles/resources/app_strings.dart';

class PlaylistsPage extends StatelessWidget {
  const PlaylistsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('playlists');
    return Scaffold(
      appBar: AppBar(actions: []),
      body: Column(
        children: [
          buildPlaylistTile(context, box),
          ValueListenableBuilder(
            valueListenable: box.listenable(),
            builder: (context, b, _) {
              final keys = box.keys.toList();

              // ✅ Define auto playlists with their string keys
              final autoPlaylists = [
                {'name': 'Recently Played', 'key': AppStrings.recentlyPlayed},
                {'name': 'Most Played', 'key': AppStrings.mostPlayed},
                {'name': 'Recently Added', 'key': AppStrings.recentlyAdded},
                {'name': 'Favorites', 'key': AppStrings.favorites},
              ];

              // ✅ Ensure auto playlists exist
              for (var playlist in autoPlaylists) {
                final name = playlist['name']!;
                if (!box.containsKey(name)) {
                  box.put(name, {'songs': [], 'image': null});
                }
              }

              // ✅ Merge auto + user playlists
              final allKeys = [
                ...autoPlaylists.map((p) => p['name']!),
                ...keys.where((k) => !autoPlaylists.any((p) => p['name'] == k)),
              ];

              return SizedBox(
                height: 220,
                child: ListView.separated(
                  padding: const EdgeInsets.all(12),
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemCount: allKeys.length,
                  itemBuilder: (context, index) {
                    final key = allKeys[index];
                    final data = box.get(key);

                    List<dynamic> list;
                    String? imagePath;

                    if (data is Map) {
                      list = List<dynamic>.from(data['songs'] ?? []);
                      imagePath = data['image'];
                    } else if (data is List) {
                      list = data;
                    } else {
                      list = [];
                    }

                    return GestureDetector(
                      onTap: () => Get.to(() => PlaylistEditPage(name: key)),
                      child: Container(
                        width: 160,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 10,
                              offset: const Offset(2, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(28),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              // 🔹 Background image (adaptive aesthetic)
                              if (imagePath != null &&
                                  File(imagePath).existsSync())
                                Image.file(
                                  File(imagePath),
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                )
                              else
                                // Default minimal background
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.6),
                                      width: 1.5,
                                    ),
                                    gradient: LinearGradient(
                                      colors: [
                                        Theme.of(context)
                                            .colorScheme
                                            .surfaceContainerHighest
                                            .withOpacity(0.6),
                                        Theme.of(context)
                                            .colorScheme
                                            .surfaceContainerHighest
                                            .withOpacity(0.9),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                ),

                              // 🔹 Blur overlay for readable text
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.25),
                                  ),
                                ),
                              ),

                              // 🔹 Playlist Info
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      key,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black38,
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${list.length} tracks',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // music note icon
                              Positioned(
                                top: 12,
                                right: 12,
                                child: Icon(
                                  Iconsax.music_circle,
                                  color: Colors.white.withOpacity(0.7),
                                  size: 28,
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
        ],
      ),
    );
  }

  Future<String?> _askName(BuildContext context) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Playlist name'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter playlist name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  Future<String?> _pickImage() async {
    final picker = ImagePicker();
    final img = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    return img?.path;
  }

  Widget buildPlaylistTile(BuildContext context, Box box) {
    return GestureDetector(
      onTap: () async {
        final name = await _askName(context);
        if (name != null && name.isNotEmpty) {
          final imgPath = await _pickImage();
          box.put(name, {'songs': [], 'image': imgPath});
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.add_circle_outline_rounded, size: 28),
            const SizedBox(width: 12),

            // 🔹 Typing Animation
            Expanded(
              child: AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText(
                    'Create new playlist',
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    speed: Duration(milliseconds: 70),
                  ),
                ],
                totalRepeatCount: 1,
                pause: const Duration(milliseconds: 500),
                displayFullTextOnTap: true,
                stopPauseOnTap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlaylistEditPage extends StatefulWidget {
  final String name;
  const PlaylistEditPage({super.key, required this.name});

  @override
  State<PlaylistEditPage> createState() => _PlaylistEditPageState();
}

class _PlaylistEditPageState extends State<PlaylistEditPage> {
  late Box playlistsBox;
  late Box songsBox;
  late List<String> list;
  String? imagePath;

  @override
  void initState() {
    super.initState();
    playlistsBox = Hive.box('playlists');
    songsBox = Hive.box('songs');

    final data = playlistsBox.get(widget.name);
    if (data is Map) {
      list = List<String>.from(data['songs'] ?? []);
      imagePath = data['image'];
    } else {
      list = List<String>.from(data ?? []);
    }
  }

  void _save() {
    playlistsBox.put(widget.name, {'songs': list, 'image': imagePath});
    setState(() {});
  }

  Future<void> _changeImage() async {
    final picker = ImagePicker();
    final img = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (img != null) {
      imagePath = img.path;
      _save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        actions: [
          IconButton(icon: const Icon(Icons.image), onPressed: _changeImage),
        ],
      ),
      body: Column(
        children: [
          if (imagePath != null && File(imagePath!).existsSync())
            Padding(
              padding: const EdgeInsets.all(12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.file(
                  File(imagePath!),
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          Expanded(
            child: ReorderableListView.builder(
              itemCount: list.length,
              onReorder: (oldIndex, newIndex) {
                if (newIndex > oldIndex) newIndex -= 1;
                final item = list.removeAt(oldIndex);
                list.insert(newIndex, item);
                _save();
              },
              itemBuilder: (context, index) {
                final path = list[index];
                final map = songsBox.get(path) as Map?;
                if (map == null) return const SizedBox(key: ValueKey('empty'));
                final song = Song.fromMap(Map<String, dynamic>.from(map));
                return ListTile(
                  key: ValueKey(path),
                  leading: const Icon(Icons.music_note),
                  title: Text(song.title),
                  subtitle: Text(song.artist),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      list.removeAt(index);
                      _save();
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add Track'),
              onPressed: () async {
                final path = await _pickSong(context);
                if (path != null && !list.contains(path)) {
                  list.add(path);
                  _save();
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> _pickSong(BuildContext context) async {
    final songs = Hive.box('songs');
    final keys = songs.keys.toList();
    return showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Pick a track'),
        children: keys.map((k) {
          final map = songs.get(k) as Map;
          return SimpleDialogOption(
            child: Text(map['title'] ?? k),
            onPressed: () => Navigator.of(context).pop(k as String),
          );
        }).toList(),
      ),
    );
  }
}
