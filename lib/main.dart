import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:the_melophiles/core/routes/get_routes.dart';
import 'package:the_melophiles/helpers/audio_handler.dart';
import 'package:the_melophiles/theme/theme.dart';

late final MusicAudioHandler audioHandler;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('songs');
  await Hive.openBox('favorites');
  await Hive.openBox('playlists');
  //
  // await JustAudioBackground.init(
  //   androidNotificationChannelId: 'com.grokmusic.player.channel.audio',
  //   androidNotificationChannelName: 'Grok Music Playback',
  //   androidNotificationOngoing: true,
  //   androidNotificationClickStartsActivity: true,
  //   androidNotificationIcon: 'mipmap/ic_launcher',
  // );

  // This is the ONLY place initAudioHandler() is called
  audioHandler = await initAudioHandler();
  Get.put<MusicAudioHandler>(audioHandler, permanent: true);

  final initialRoute = Hive.box('songs').isNotEmpty ? '/' : '/onboarding';
  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grok Music',
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: initialRoute,
      getPages: GetRoutes.routes,
    );
  }
}
