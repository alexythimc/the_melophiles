import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_melophiles/controllers/eq_controller.dart';

class SoundQualityPage extends StatelessWidget {
  const SoundQualityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final eq = Get.put(EQController());
    return Scaffold(
      appBar: AppBar(title: const Text('Sound Quality')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => SwitchListTile(
                title: const Text('Dolby Atmos'),
                subtitle: const Text('Simulate spatial audio (reverb)'),
                value: eq.dolby.value,
                onChanged: (v) => eq.setDolby(v),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Equalizer Presets',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: eq.presets.keys
                  .map(
                    (p) => Obx(
                      () => ChoiceChip(
                        label: Text(p),
                        selected: eq.preset.value == p,
                        onSelected: (_) => eq.applyPreset(p),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
            const Text(
              'Custom EQ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Column(
              children: List.generate(
                10,
                (i) => Obx(() => _bandSlider(eq, i)),
              ).toList(),
            ),
            const SizedBox(height: 12),
            const Text(
              'Bass & Virtualizer',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Obx(
              () => Column(
                children: [
                  ListTile(
                    title: const Text('Bass Boost'),
                    subtitle: Slider(
                      value: eq.bassBoost.value,
                      min: 0,
                      max: 100,
                      onChanged: (v) => eq.setBass(v),
                    ),
                  ),
                  ListTile(
                    title: const Text('Virtualizer'),
                    subtitle: Slider(
                      value: eq.virtualizer.value,
                      min: 0,
                      max: 100,
                      onChanged: (v) => eq.setVirtualizer(v),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Adapt Sound',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _startAdapt(context),
              child: const Text('Start Ear Test'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bandSlider(EQController eq, int idx) {
    final freqs = [
      '60Hz',
      '170Hz',
      '310Hz',
      '600Hz',
      '1kHz',
      '3kHz',
      '6kHz',
      '12kHz',
      '14kHz',
      '16kHz',
    ];
    return ListTile(
      title: Text(freqs[idx]),
      subtitle: Slider(
        value: eq.bands[idx],
        min: -12,
        max: 12,
        divisions: 24,
        label: '${eq.bands[idx].toStringAsFixed(1)} dB',
        onChanged: (v) => eq.setCustomBand(idx, v),
      ),
      trailing: Text('${eq.bands[idx].toStringAsFixed(1)} dB'),
    );
  }

  void _startAdapt(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Adapt Sound'),
        content: const Text('Ear test placeholder (6 questions)'),
        actions: [TextButton(onPressed: Get.back, child: Text('Close'))],
      ),
    );
  }
}
