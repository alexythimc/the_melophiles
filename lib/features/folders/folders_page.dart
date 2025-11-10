import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:the_melophiles/models/song_model.dart';

class FoldersPage extends StatelessWidget {
  const FoldersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final songsBox = Hive.box('songs');
    final songs = songsBox.values
        .whereType<Map>()
        .map((m) => Song.fromMap(Map<String, dynamic>.from(m)))
        .toList();

    final Map<String, List<Song>> folders = {};
    for (final s in songs) {
      final dir = File(s.path).parent.path;
      folders.putIfAbsent(dir, () => []).add(s);
    }

    final entries = folders.entries.toList();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      body: ListView.separated(
        itemCount: entries.length,
        separatorBuilder: (_, __) => const SizedBox(height: 6),
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, index) {
          final dir = entries[index].key;
          final list = entries[index].value;

          return Container(
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surfaceVariant.withOpacity(0.4),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).dividerColor.withOpacity(0.2),
              ),
            ),
            child: Theme(
              data: Theme.of(
                context,
              ).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                title: Text(
                  _getFolderName(dir),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  '${list.length} tracks',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
                trailing: const Icon(Icons.keyboard_arrow_down_rounded),
                childrenPadding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 10,
                ),
                children: list.map((s) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primaryContainer.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      title: Text(
                        s.title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        s.artist,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      leading: const Icon(Icons.music_note_rounded, size: 26),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onTap: () {
                        // TODO: Handle song tap (play / open detail)
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getFolderName(String path) {
    return path.split(Platform.pathSeparator).last;
  }
}
