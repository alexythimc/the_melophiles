import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:the_melophiles/models/song_model.dart';

class AudioController extends GetxController {
  final player = AudioPlayer();
  final ConcatenatingAudioSource _playlist = ConcatenatingAudioSource(
    children: [],
  );

  var isPlaying = false.obs;
  var currentIndex = Rxn<int>();
  var positionMillis = 0.obs;
  var durationMillis = 0.obs;

  var title = ''.obs;
  var artist = ''.obs;
  var album = ''.obs;
  var art = ''.obs;

  StreamSubscription<Duration>? _posSub;
  StreamSubscription<PlayerState>? _stateSub;
  StreamSubscription<SequenceState?>? _seqSub;

  var isFavorite = true.obs;

  @override
  void onInit() {
    super.onInit();
    _initPlayer();

    _posSub = player.positionStream.listen((pos) {
      positionMillis.value = pos.inMilliseconds;
    });

    _stateSub = player.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
    });

    _seqSub = player.sequenceStateStream.listen((seq) {
      final idx = seq?.currentIndex;
      currentIndex.value = idx;

      if (idx != null && seq != null) {
        final tag = seq.currentSource?.tag;
        if (tag is MediaItem) {
          title.value = tag.title;
          artist.value = tag.artist ?? '';
          album.value = tag.album ?? '';

          // GET ALBUM COVER HERE
          final artUri = tag.artUri;
          if (artUri != null) {
            if (artUri.isScheme('file')) {
              // Local file path
              art.value = artUri.toFilePath();
            } else if (artUri.isScheme('content') ||
                artUri.isScheme('android.resource')) {
              // Android content URI (e.g., from MediaStore)
              art.value = artUri.toString();
            } else {
              // Network or fallback
              art.value = artUri.toString();
            }
          } else {
            art.value = '';
          }
        }

        final dur = seq.currentSource?.duration;
        durationMillis.value = dur?.inMilliseconds ?? 0;
      }
    });
  }

  Future<void> _initPlayer() async {
    try {
      await player.setAudioSource(_playlist);
    } catch (e) {
      debugPrint('AudioController: setAudioSource failed: $e');
    }
  }

  // ✅ Full library queue (alphabetical)
  Future<void> setQueueFromHive() async {
    final box = Hive.box('songs');
    final maps = box.values
        .whereType<Map>()
        .map((m) => Map<String, dynamic>.from(m))
        .toList();
    maps.sort((a, b) {
      final ta = (a['title'] as String?) ?? '';
      final tb = (b['title'] as String?) ?? '';
      return ta.toLowerCase().compareTo(tb.toLowerCase());
    });

    final sources = maps.map(_mapToAudioSource).toList();
    await _playlist.clear();
    await _playlist.addAll(sources);
    await player.setAudioSource(_playlist, initialIndex: 0);
  }

  // ✅ Build queue only from a given list (album tracks)
  Future<void> setQueueFromList(List<Song> songs) async {
    final sources = songs.map((s) => _songToAudioSource(s)).toList();
    await _playlist.clear();
    await _playlist.addAll(sources);
    await player.setAudioSource(_playlist, initialIndex: 0);
  }

  AudioSource _mapToAudioSource(Map<String, dynamic> m) {
    final path = m['path'] as String? ?? '';
    final title = m['title'] as String? ?? path.split('/').last;
    final artist = m['artist'] as String? ?? 'Unknown';
    final album = m['album'] as String? ?? '';
    return AudioSource.file(
      path,
      tag: MediaItem(id: path, title: title, artist: artist, album: album),
    );
  }

  AudioSource _songToAudioSource(Song s) {
    return AudioSource.file(
      s.path,
      tag: MediaItem(
        id: s.path,
        title: s.title,
        artist: s.artist,
        album: s.album,
      ),
    );
  }

  Future<void> playIndex(int index) async {
    if (_playlist.length == 0) return;
    await player.seek(Duration.zero, index: index);
    await player.play();
  }

  Future<void> play() => player.play();

  Future<void> pause() => player.pause();

  Future<void> seek(int millis) => player.seek(Duration(milliseconds: millis));

  Future<void> next() => player.seekToNext();

  Future<void> previous() => player.seekToPrevious();

  @override
  void onClose() {
    _posSub?.cancel();
    _stateSub?.cancel();
    _seqSub?.cancel();
    player.dispose();
    super.onClose();
  }

  // ✅ Shuffle play
  Future<void> shufflePlay() async {
    await player.setShuffleModeEnabled(true);
    await player.shuffle();
    await player.play();
  }

  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;
  }

  // ──────────────────────  Helper (put it in your UI file)  ──────────────────────
  ImageProvider? coverProvider(String path) {
    if (path.isEmpty) return null;

    final uri = Uri.tryParse(path);
    if (uri == null) return null;

    // 1. Local file (file:///storage/…/cover.jpg)
    if (uri.isScheme('file')) {
      final file = File(uri.toFilePath());
      return file.existsSync() ? FileImage(file) : null;
    }

    // 2. Android MediaStore (content://media/…)
    if (uri.isScheme('content')) {
      return ContentImageProvider(uri); // see class below
    }

    // 3. Network URL[](https://…)
    if (uri.isScheme('http') || uri.isScheme('https')) {
      return NetworkImage(path);
    }

    // Fallback – treat as asset (rare)
    return AssetImage(path);
  }
}

class ContentImageProvider extends ImageProvider<Object> {
  final Uri uri;

  const ContentImageProvider(this.uri);

  @override
  Future<Object> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<ContentImageProvider>(this);
  }

  @override
  ImageStreamCompleter loadImage(Object key, ImageDecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(decode),
      scale: 1.0,
    );
  }

  Future<Codec> _loadAsync(ImageDecoderCallback decode) async {
    try {
      final file = File.fromUri(uri);
      final bytes = await file.readAsBytes();
      final buffer = await ImmutableBuffer.fromUint8List(bytes);
      return decode(buffer);
    } catch (e) {
      debugPrint('ContentImageProvider: Failed to load $uri → $e');
      throw e;
    }
  }

  @override
  bool operator ==(Object other) =>
      other is ContentImageProvider && other.uri == uri;

  @override
  int get hashCode => uri.hashCode;
}
