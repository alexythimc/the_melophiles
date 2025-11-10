// get routes with get page
import 'package:get/get.dart';
import 'package:the_melophiles/bindings/home_binding.dart';
import 'package:the_melophiles/features/favorites/favorites_page.dart';
import 'package:the_melophiles/features/home/music_home.dart';
import 'package:the_melophiles/features/library/library_page.dart';
import 'package:the_melophiles/features/lyrics/lyrics_page.dart';
// Added imports for individual pages
import 'package:the_melophiles/features/now_playing/now_playing_page.dart';
import 'package:the_melophiles/features/onboarding/onboarding_page.dart';
import 'package:the_melophiles/features/settings/settings_page.dart';
import 'package:the_melophiles/features/sound_quality/sound_quality_page.dart';
import 'package:the_melophiles/features/tag_editor/tag_editor_page.dart';

class GetRoutes {
  static final routes = [
    GetPage(
      name: '/onboarding',
      page: () => OnboardingPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: '/',
      page: () => const MusicHome(),
      binding: HomeBinding(),
      transition: Transition.fadeIn, // Smooth entry
    ),
    // Now Playing route
    GetPage(
      name: '/now-playing',
      page: () => const NowPlayingPage(),
      binding: BindingsBuilder(() {
        // Init any specific controllers here
      }),
      transition: Transition.rightToLeft,
    ),
    // Library route
    GetPage(
      name: '/library',
      page: () => const LibraryPage(),
      transition: Transition.rightToLeft,
    ),
    // Favorites route
    GetPage(
      name: '/favorites',
      page: () => const FavoritesPage(),
      transition: Transition.rightToLeft,
    ),
    // Settings route
    GetPage(
      name: '/settings',
      page: () => const SettingsPage(),
      transition: Transition.rightToLeft,
    ),
    // Sound Quality route
    GetPage(
      name: '/sound-quality',
      page: () => const SoundQualityPage(),
      transition: Transition.rightToLeft,
    ),
    // Lyrics route
    GetPage(
      name: '/lyrics',
      page: () => const LyricsPage(),
      transition: Transition.rightToLeft,
    ),
    // Tag Editor route
    GetPage(
      name: '/tag-editor',
      page: () => const TagEditorPage(path: ''),
      transition: Transition.rightToLeft,
    ),
  ];
}
