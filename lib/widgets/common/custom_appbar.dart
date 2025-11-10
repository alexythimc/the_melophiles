import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// 🔹 Lottie background animation
        Positioned.fill(
          child: RotatedBox(
            quarterTurns: 3,
            child: Lottie.asset(
              'assets/animations/Star_Skin.json',
              fit: BoxFit.cover,
              height: kToolbarHeight,
              width: double.infinity,
              animate: true,
              repeat: true,
            ),
          ),
        ),

        /// 🔹 AppBar content on top
        AppBar(
          backgroundColor: Colors.transparent, // Make background see-through
          elevation: 0,
          title: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) =>
                FadeTransition(opacity: animation, child: child),
            child: Text(
              title,
              key: ValueKey(title),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Iconsax.search_normal),
              onPressed: () {},
            ),
            PopupMenuButton<String>(
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'settings', child: Text('Settings')),
                PopupMenuItem(value: 'clear_cache', child: Text('Clear Cache')),
              ],
              onSelected: (v) {
                if (v == 'settings') Get.toNamed('/settings');
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
