import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:the_melophiles/models/song_model.dart';

class ScannerController extends GetxController {
  final OnAudioQuery audioQuery = OnAudioQuery();
  var progress = 0.0.obs;
  var status = 'idle'.obs;

  /// Request necessary audio/storage permissions for Android and iOS.
  Future<bool> requestStoragePermission() async {
    status.value = 'requesting_permission';
    try {
      if (Platform.isAndroid) {
        final info = DeviceInfoPlugin();
        final android = await info.androidInfo;
        final sdk = android.version.sdkInt;
        debugPrint('ScannerController: Android SDK=$sdk');

        // Android 13+ (API 33): READ_MEDIA_AUDIO
        if (sdk >= 33) {
          var audioStatus = await Permission.audio.status;
          if (!audioStatus.isGranted) {
            audioStatus = await Permission.audio.request();
          }
          if (!audioStatus.isGranted) return false;
        } else {
          // Older Android: manageExternalStorage or storage
          var manageStatus = await Permission.manageExternalStorage.status;
          if (!manageStatus.isGranted) {
            manageStatus = await Permission.manageExternalStorage.request();
          }
          if (!manageStatus.isGranted) {
            var storageStatus = await Permission.storage.status;
            if (!storageStatus.isGranted) {
              storageStatus = await Permission.storage.request();
            }
            if (!storageStatus.isGranted) return false;
          }
        }

        // Request OnAudioQuery permissions as well
        bool queryPerm = await audioQuery.permissionsStatus();
        if (!queryPerm) {
          queryPerm = await audioQuery.permissionsRequest();
        }

        return queryPerm;
      } else {
        // iOS: limited access
        final perm = await Permission.mediaLibrary.request();
        return perm.isGranted;
      }
    } catch (e, st) {
      debugPrint('ScannerController.requestStoragePermission error: $e\n$st');
      return false;
    }
  }

  /// Get current permission summary for debugging.
  Future<Map<String, String>> getPermissionStatusSummary() async {
    final out = <String, String>{};
    try {
      if (Platform.isAndroid) {
        final info = DeviceInfoPlugin();
        final android = await info.androidInfo;
        out['sdk'] = android.version.sdkInt.toString();
        out['audio'] = (await Permission.audio.status).toString();
        out['manageExternalStorage'] =
            (await Permission.manageExternalStorage.status).toString();
        out['storage'] = (await Permission.storage.status).toString();
      } else {
        out['mediaLibrary'] = (await Permission.mediaLibrary.status).toString();
      }
    } catch (e) {
      out['error'] = e.toString();
    }
    return out;
  }

  /// Scan device audio using `on_audio_query`
  Future<void> scan() async {
    status.value = 'scanning';
    progress.value = 0.0;

    try {
      final songsBox = await Hive.openBox('songs');
      final songs = await audioQuery.querySongs(
        sortType: SongSortType.DATE_ADDED,
        orderType: OrderType.DESC_OR_GREATER,
        uriType: UriType.EXTERNAL,
      );

      int count = 0;
      for (final s in songs) {
        final artBytes = await audioQuery.queryArtwork(s.id, ArtworkType.AUDIO);

        final song = Song(
          id: s.id.toString(),
          title: s.title,
          artist: s.artist ?? 'Unknown Artist',
          album: s.album ?? 'Unknown Album',
          durationMillis: s.duration ?? 0,
          path: s.data ?? '',
          art: artBytes != null ? base64Encode(artBytes) : null,
        );

        await songsBox.put(song.id, song.toMap());

        count++;
        progress.value = count / (songs.isEmpty ? 1 : songs.length);
      }

      status.value = 'done';
      debugPrint('ScannerController: Scan completed - ${songs.length} songs.');
    } catch (e, st) {
      debugPrint('ScannerController.scan error: $e\n$st');
      status.value = 'error';
    }
  }
}
