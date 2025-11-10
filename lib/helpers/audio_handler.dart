// lib/helpers/audio_handler.dart
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

MusicAudioHandler? _audioHandler;

/// Initialise **once only** – safe on hot reload
Future<MusicAudioHandler> initAudioHandler() async {
  if (_audioHandler != null) {
    return _audioHandler!;
  }

  final handler = await AudioService.init(
    builder: () => MusicAudioHandler._internal(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.grokmusic.player.channel.audio',
      androidNotificationChannelName: 'Grok Music Playback',
      androidNotificationOngoing: true,
      androidNotificationClickStartsActivity: true,
      androidNotificationIcon: 'mipmap/ic_launcher',
    ),
  );

  final player = (handler as MusicAudioHandler)._player;

  player.playbackEventStream
      .map((e) => handler._toPlaybackState(e))
      .listen((state) => handler.playbackState.add(state));

  _audioHandler = handler;
  return _audioHandler!;
}

class MusicAudioHandler extends BaseAudioHandler
    with QueueHandler, SeekHandler {
  final AudioPlayer _player = AudioPlayer();

  MusicAudioHandler._internal();

  @override
  Future<void> play() => _player.play();
  @override
  Future<void> pause() => _player.pause();
  @override
  Future<void> stop() => _player.stop();
  @override
  Future<void> seek(Duration position) => _player.seek(position);
  @override
  Future<void> skipToNext() => _player.seekToNext();
  @override
  Future<void> skipToPrevious() => _player.seekToPrevious();

  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {
    final cur = queue.value;
    queue.add([...cur, mediaItem]);
    if (cur.isEmpty) await play();
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    final cur = queue.value;
    queue.add([...cur, ...mediaItems]);
  }

  @override
  Future<void> removeQueueItem(MediaItem mediaItem) async {
    final cur = queue.value;
    queue.add(cur.where((i) => i.id != mediaItem.id).toList());
  }

  @override
  Future<void> updateQueue(List<MediaItem> queue) async {
    this.queue.add(List<MediaItem>.from(queue));
  }

  PlaybackState _toPlaybackState(PlaybackEvent event) {
    return PlaybackState(
      processingState: _mapToAudioProcessingState(_player.processingState),
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    );
  }

  AudioProcessingState _mapToAudioProcessingState(ProcessingState state) {
    return switch (state) {
      ProcessingState.idle => AudioProcessingState.idle,
      ProcessingState.loading => AudioProcessingState.loading,
      ProcessingState.buffering => AudioProcessingState.buffering,
      ProcessingState.ready => AudioProcessingState.ready,
      ProcessingState.completed => AudioProcessingState.completed,
    };
  }

  AudioPlayer get player => _player;
}
