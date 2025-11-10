import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:the_melophiles/controllers/scanner_controller.dart';

class OnboardingPage extends StatelessWidget {
  OnboardingPage({super.key});

  final ScannerController scanner = Get.put(ScannerController());

  Future<void> _showPermissionStatus(BuildContext context) async {
    final map = await scanner.getPermissionStatusSummary();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Permission Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: map.entries
              .map((e) => Text('${e.key}: ${e.value}'))
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () async {
              await openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome to Grok Music')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'To get started, Grok Music needs permission to access your music files. We will scan your device for supported audio formats and build your library. This app is 100% offline.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Obx(() {
              if (scanner.status.value == 'idle') {
                return Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final granted = await scanner
                            .requestStoragePermission();
                        debugPrint('Permission granted: $granted');
                        final summary = await scanner
                            .getPermissionStatusSummary();
                        // Show detailed permission statuses so user can see what's missing
                        await showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Permission Result'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: summary.entries
                                  .map((e) => Text('${e.key}: ${e.value}'))
                                  .toList(),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(),
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                        );
                        if (granted) {
                          scanner.scan();
                        } else {
                          Get.snackbar(
                            'Permission',
                            'Storage permission denied',
                          );
                        }
                      },
                      child: const Text('Grant Storage & Scan'),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => _showPermissionStatus(context),
                      child: const Text('Check Permissions'),
                    ),
                  ],
                );
              }

              if (scanner.status.value == 'scanning') {
                return Column(
                  children: [
                    const Text('Scanning your device...'),
                    const SizedBox(height: 12),
                    Obx(
                      () => LinearProgressIndicator(
                        value: scanner.progress.value,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 120,
                      child: Lottie.asset(
                        'assets/images/snoopy_icon.jpg',
                        repeat: true,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        // cancel not implemented yet
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                );
              }

              if (scanner.status.value == 'done') {
                return Column(
                  children: [
                    const Text('Scan complete!'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        Get.offAllNamed('/');
                      },
                      child: const Text('Continue to Grok Music'),
                    ),
                  ],
                );
              }

              return const SizedBox();
            }),
          ],
        ),
      ),
    );
  }
}
