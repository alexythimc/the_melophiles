import 'package:flutter/material.dart';
import 'package:flutter_animated_icons/icons8.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:the_melophiles/controllers/home_controller.dart';
import 'package:the_melophiles/device/deviceutils.dart';

import 'curvedEdges/curved_edges.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller if not already registered

    final controller = Get.find<HomeController>();

    final size = TDeviceUtils.screenHeight(context);
    final width = TDeviceUtils.screenWidth(context);

    // Define navigation options with icons and Lottie assets
    final options = [
      {'icon': Icons.music_note, 'label': 'Now Playing', 'asset': Icons8.music},
      {'icon': Icons.library_music, 'label': 'Library', 'asset': Icons8.book},
      {
        'icon': Icons.favorite,
        'label': 'Favorites',
        'asset': Icons8.heart_color,
      },
      {'icon': Icons.settings, 'label': 'Settings', 'asset': Icons8.adjust},
    ];

    return Scaffold(
      // appBar: MusicAppBar(
      //   title: 'TheMelophiles',
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.sync),
      //       onPressed: () {
      //         Get.toNamed('/onboarding');
      //       },
      //     ),
      //   ],
      // ),
      body: Stack(
        children: [
          // Background Image with Curved Bottom Edge
          ClipPath(
            clipper: TCurvedEdges(),
            child: Image.asset(
              'assets/images/curved_edge.jpg',
              height: size * 0.3,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Horizontal Scrollable Cards Overlapping the Curved Section
          Positioned(
            top: 10.0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 200.0,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                separatorBuilder: (context, index) =>
                    const SizedBox(width: 16.0),
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options[index];
                  return _buildOption(
                    context,
                    option['icon']! as IconData,
                    option['label']! as String,
                    option['asset']! as String,
                    index,
                    controller,
                  );
                },
              ),
            ),
          ),

          // Scrollable Content Body Below the Cards
          Positioned.fill(
            top: size * 0.52,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recommended for you',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Container(
                    height: 180.0,
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surface.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: const Center(
                      child: Text('Music Content Placeholder'),
                    ),
                  ),
                  // Add more dynamic content here as needed
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Reusable Widget for Option Cards with Animation Effects
  Widget _buildOption(
    BuildContext context,
    IconData icon,
    String label,
    String asset,
    int index,
    HomeController controller,
  ) {
    return Obx(() {
      final isAnimating = controller.isAnimating[index].value;
      return GestureDetector(
        onTap: () {
          // Trigger scale animation and Lottie play
          controller.triggerAnimation(index);

          // Navigate to the appropriate route based on the card index
          switch (index) {
            case 0:
              Get.toNamed('/now-playing');
              break;
            case 1:
              Get.toNamed('/library');
              break;
            case 2:
              Get.toNamed('/favorites');
              break;
            case 3:
              Get.toNamed('/settings');
              break;
            default:
              Get.snackbar('Navigation', 'Unknown destination');
          }

          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tapped $label')));
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          // Smooth easing for the scale effect
          transform: Matrix4.identity()..scale(isAnimating ? 1.05 : 1.0),
          width: 220.0,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
            borderRadius: BorderRadius.circular(25.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8.0,
                offset: const Offset(0, 4.0),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Lottie Icon with Theme-Adaptive Coloring
              SizedBox(
                height: 36.0,
                width: 36.0,
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.onSurface,
                    BlendMode.srcIn,
                  ),
                  child: Lottie.asset(asset, repeat: true, animate: true),
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
