// Converted to plain Dart model (adapter implemented manually in song_model_adapter.dart)
class Song {
  String id; // can be file path
  String title;
  String artist;
  String album;
  int durationMillis;
  String path;
  String? art; // base64-encoded image bytes if available

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.durationMillis,
    required this.path,
    this.art,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'album': album,
      'durationMillis': durationMillis,
      'path': path,
      'art': art,
    };
  }

  static Song fromMap(Map<dynamic, dynamic> map) {
    return Song(
      id: map['id'] as String,
      title: map['title'] as String,
      artist: map['artist'] as String,
      album: map['album'] as String,
      durationMillis: map['durationMillis'] as int,
      path: map['path'] as String,
      art: map['art'] as String?,
    );
  }
}
