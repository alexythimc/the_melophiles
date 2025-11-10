import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:the_melophiles/controllers/audio_controller.dart';
import 'package:the_melophiles/resources/app_helper.dart';

class NowPlayingPage extends StatelessWidget {
  const NowPlayingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final audioCtrl = Get.find<AudioController>();
    final size = MediaQuery.of(context).size;
    final isDark = AppHelper.isDarkMode(context);

    return Scaffold(
      //backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_down_1),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(Iconsax.more, color: Colors.grey.shade500),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          children: [
            const Spacer(),

            /// 🎵 Album Art
            Hero(
              tag: audioCtrl.currentIndex.value ?? 'art',
              child: Container(
                height: size.width * 0.9,
                width: size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: const Image(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                    "https://www.tallengestore.com/cdn/shop/products/Movie_Poster_-_The_Good_The_Bad_And_The_Ugly_-_Hollywood_Collection_6ee7c519-1efa-4ca0-9dd6-150ab000a51d.jpg?v=1481897753",
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// ❤️ Favorite Button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //lyrics button
                // IconButton(
                //   icon: Icon(Iconsax.music, color: Colors.grey.shade500),
                //   onPressed: () {},
                // ),
                Obx(
                  () => IconButton(
                    icon: Icon(
                      audioCtrl.isFavorite.value
                          ? Iconsax.heart5
                          : Iconsax.heart,
                      color: audioCtrl.isFavorite.value
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.shade500,
                    ),
                    onPressed: () => audioCtrl.toggleFavorite(),
                  ),
                ),
                // const Spacer(),
                // add to playlist button
                IconButton(
                  icon: Icon(
                    Iconsax.add_square,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {},
                ),

                // options button
              ],
            ),

            const SizedBox(height: 20),

            /// 🎧 Song Info
            Obx(() {
              final title = audioCtrl.title.value;
              final artist = audioCtrl.artist.value;
              final album = audioCtrl.album.value;
              return Transform.translate(
                offset: const Offset(
                  0,
                  0,
                ), // 👈 moves container slightly downward
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    // gradient: LinearGradient(
                    //   begin: Alignment.centerLeft,
                    //   end: Alignment.centerRight,
                    //   colors: [
                    //     Theme.of(context).colorScheme.primary.withOpacity(0.10),
                    //     Theme.of(context).colorScheme.surface.withOpacity(0.4),
                    //   ],
                    // ),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.25),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Accent strip
                      Container(
                        width: 5,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.secondary,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14), // Song info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // 🎵 Title
                            Text(
                              title.isNotEmpty ? title : 'The Ecstasy of Gold',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    fontSize: 22,
                                    letterSpacing: 0.3,
                                  ),
                            ),
                            const SizedBox(height: 8), // 👤 Artist
                            Text(
                              artist.isNotEmpty ? artist : 'Ennio Morricone',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondary.withOpacity(0.9),
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.2,
                                  ),
                            ),
                            const SizedBox(height: 6), // 💿 Album
                            // Text(
                            //   album.isNotEmpty
                            //       ? album
                            //       : 'The Good, The Bad and The Ugly (Soundtrack)',
                            //   maxLines: 2,
                            //   overflow: TextOverflow.ellipsis,
                            //   style: Theme.of(context).textTheme.bodyMedium
                            //       ?.copyWith(
                            //         color: Colors.grey.withOpacity(0.85),
                            //         fontWeight: FontWeight.w400,
                            //         letterSpacing: 0.1,
                            //         height: 1.3,
                            //       ),
                            // ),
                            // const SizedBox(height: 6), // 📅 Year
                            // Text(
                            //   '1966',
                            //   style: Theme.of(context).textTheme.bodySmall
                            //       ?.copyWith(
                            //         color: Colors.grey.withOpacity(0.6),
                            //         fontSize: 13,
                            //       ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            Spacer(),

            /// 🎚️ Progress Bar
            Obx(() {
              final pos = audioCtrl.positionMillis.value;
              final dur = audioCtrl.durationMillis.value;
              return Column(
                children: [
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: isDark ? Colors.white : Colors.black,
                      inactiveTrackColor: isDark
                          ? Colors.white24
                          : Colors.black12,
                      thumbColor: isDark
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                      trackHeight: 3,
                      overlayShape: SliderComponentShape.noOverlay,
                    ),
                    child: Slider(
                      value: dur == 0
                          ? 0
                          : pos.toDouble().clamp(0, dur.toDouble()),
                      min: 0,
                      max: dur == 0 ? 1 : dur.toDouble(),
                      onChanged: (v) => audioCtrl.seek(v.toInt()),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatMillis(pos),
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          _formatMillis(dur),
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),

            const SizedBox(height: 20),

            /// ▶️ Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Iconsax.shuffle),
                  color: Colors.grey.shade500,
                  onPressed: () => audioCtrl.shufflePlay(),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Iconsax.previous),
                  color: Colors.grey.shade700,
                  iconSize: 32,
                  onPressed: () => audioCtrl.previous(),
                ),
                const SizedBox(width: 8),
                Obx(
                  () => IconButton(
                    icon: Icon(
                      audioCtrl.isPlaying.value
                          ? Iconsax.pause_circle
                          : Iconsax.play_circle,
                    ),
                    color: Theme.of(context).colorScheme.primary,
                    iconSize: 70,
                    onPressed: () async {
                      HapticFeedback.selectionClick();
                      if (audioCtrl.isPlaying.value) {
                        await audioCtrl.pause();
                      } else {
                        await audioCtrl.play();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Iconsax.next),
                  color: Colors.grey.shade700,
                  iconSize: 32,
                  onPressed: () => audioCtrl.next(),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Iconsax.repeat),
                  color: Colors.grey.shade500,
                  onPressed: () {},
                ),
              ],
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }

  String _formatMillis(int ms) {
    final s = (ms ~/ 1000) % 60;
    final m = (ms ~/ 60000) % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}
