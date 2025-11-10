import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_icons/icons8.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:the_melophiles/controllers/audio_controller.dart';
import 'package:the_melophiles/features/albums/albums_page.dart';
import 'package:the_melophiles/features/artists/artists_page.dart';
import 'package:the_melophiles/features/favorites/favorites_page.dart';
import 'package:the_melophiles/features/folders/folders_page.dart';
import 'package:the_melophiles/features/library/library_page.dart';
import 'package:the_melophiles/features/playlists/playlists_page.dart';
import 'package:the_melophiles/widgets/common/custom_appbar.dart';

class MusicHome extends StatefulWidget {
  const MusicHome({super.key});

  @override
  State<MusicHome> createState() => _MusicHomeState();
}

class _MusicHomeState extends State<MusicHome> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  late final AnimationController _animationController;

  final _tabs = [
    {'icon': Icons8.music, 'label': 'Tracks'},
    {'icon': Icons8.bookmark, 'label': 'Albums'},
    {'icon': Icons8.cat_meow, 'label': 'Artists'},
    // {'icon': Icons8.adjust, 'label': 'Genres'},
    {'icon': Icons8.folder, 'label': 'Folders'},
    {'icon': Icons8.book, 'label': 'Playlists'},
    {'icon': Icons8.heart_color, 'label': 'Favorites'},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final audioCtrl = Get.put(AudioController());
    final title = _tabs[_currentIndex]['label'] as String; // ✅ Dynamic title

    final pages = [
      const LibraryPage(), // Tracks
      const AlbumsPage(),
      const ArtistPage(),
      //const GenresPage(),
      const FoldersPage(),
      const PlaylistsPage(),
      const FavoritesPage(),
    ];

    return Scaffold(
      appBar: CustomAppBar(title: title),

      body: PageView(
        controller: _pageController,
        onPageChanged: (i) {
          setState(() => _currentIndex = i);
          _animationController.forward(from: 0.0);
        },
        children: pages,
      ),

      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //  Mini-player
          GestureDetector(
            onTap: () => Get.toNamed('/now-playing'),
            child: Obx(() {
              if (audioCtrl.currentIndex.value == null) {
                return _buildMiniPlayerPlaceholder(context);
              } else {
                return MiniPlayer(
                  imageUrl: audioCtrl.art.value ?? '',
                  title: audioCtrl.title.value ?? '',
                  artist: audioCtrl.artist.value ?? '',
                  isPlaying: audioCtrl.isPlaying.value,
                  onPlayPause: () async {
                    if (audioCtrl.isPlaying.value) {
                      await audioCtrl.pause();
                    } else {
                      await audioCtrl.play();
                    }
                  },
                );
              }
            }),
          ),

          // ✅ Animated Bottom Navigation Bar
          BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            onTap: (i) {
              _pageController.jumpToPage(i);
              setState(() => _currentIndex = i);
              _animationController.forward(from: 0.0);
            },
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Colors.grey[600],
            items: _tabs.map((t) {
              final index = _tabs.indexOf(t);
              final isSelected = index == _currentIndex;

              return BottomNavigationBarItem(
                icon: SizedBox(
                  height: 30,
                  width: 30,
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey[600]!,
                      BlendMode.srcIn,
                    ),
                    child: Lottie.asset(
                      t['icon'] as String,
                      repeat: true,
                      animate: isSelected,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                activeIcon: SizedBox(
                  height: 30,
                  width: 30,
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.primary,
                      BlendMode.srcIn,
                    ),
                    child: Lottie.asset(
                      t['icon'] as String,
                      repeat: true,
                      animate: true,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                label: t['label'] as String,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ✅ Mini-player placeholder
  Widget _buildMiniPlayerPlaceholder(BuildContext context) {
    return Container(
      height: 72,
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const CircleAvatar(child: Icon(Icons.music_note)),
          const SizedBox(width: 12),
          const Expanded(child: Text('No track playing')),
          Icon(Iconsax.previous),
          SizedBox(width: 16),
          Icon(Iconsax.music_play),
          SizedBox(width: 16),
          Icon(Iconsax.next),
        ],
      ),
    );
  }

  // ✅ Active mini-player
  Widget _buildMiniPlayer(BuildContext context, AudioController audioCtrl) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Obx(
            () => Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: audioCtrl.art.value.isNotEmpty
                    ? DecorationImage(
                        image: audioCtrl.coverProvider(audioCtrl.art.value)!,
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: audioCtrl.art.value.isEmpty
                  ? const Icon(Icons.music_note, size: 28)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => SizedBox(
                    child: Text(
                      audioCtrl.title.value ?? '',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ),
                ),
                Obx(
                  () => SizedBox(
                    child: Text(
                      audioCtrl.artist.value ?? '',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Obx(
            () => IconButton(
              icon: Icon(
                audioCtrl.isPlaying.value ? Iconsax.music_play : Iconsax.pause,
                color: audioCtrl.isPlaying.value
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[600],
                size: 28,
              ),
              onPressed: () async {
                HapticFeedback.lightImpact();
                if (audioCtrl.isPlaying.value) {
                  await audioCtrl.pause();
                } else {
                  await audioCtrl.play();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MiniPlayer extends StatelessWidget {
  final String? imageUrl; // or AssetImage / File if needed
  final String? title;
  final String? artist;
  final bool isPlaying;
  final VoidCallback onPlayPause;

  const MiniPlayer({
    super.key,
    this.imageUrl,
    required this.title,
    required this.artist,
    required this.isPlaying,
    required this.onPlayPause,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: imageUrl != null
                ? NetworkImage(
                    imageUrl!,
                  ) // change to AssetImage/FileImage if needed
                : null,
            child: imageUrl == null ? const Icon(Icons.music_note) : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(
                  artist ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              isPlaying ? Iconsax.music_play : Iconsax.pause,
              color: isPlaying
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey[600],
              size: 28,
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
              onPlayPause();
            },
          ),
        ],
      ),
    );
  }
}
