import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TagEditorPage extends StatefulWidget {
  final String path;
  const TagEditorPage({super.key, required this.path});

  @override
  State<TagEditorPage> createState() => _TagEditorPageState();
}

class _TagEditorPageState extends State<TagEditorPage> {
  late Box songsBox;
  late Map<String, dynamic> map;
  late TextEditingController titleController;
  late TextEditingController artistController;
  late TextEditingController albumController;

  @override
  void initState() {
    super.initState();
    songsBox = Hive.box('songs');
    map = Map<String, dynamic>.from(songsBox.get(widget.path) as Map? ?? {});
    titleController = TextEditingController(text: map['title'] ?? '');
    artistController = TextEditingController(text: map['artist'] ?? '');
    albumController = TextEditingController(text: map['album'] ?? '');
  }

  @override
  void dispose() {
    titleController.dispose();
    artistController.dispose();
    albumController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    map['title'] = titleController.text;
    map['artist'] = artistController.text;
    map['album'] = albumController.text;
    await songsBox.put(widget.path, map);
    // Note: Writing ID3 tags to the file is not implemented here. This updates the local DB index.
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Tags')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: artistController,
              decoration: const InputDecoration(labelText: 'Artist'),
            ),
            TextField(
              controller: albumController,
              decoration: const InputDecoration(labelText: 'Album'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _save,
              child: const Text('Save (local index)'),
            ),
          ],
        ),
      ),
    );
  }
}
