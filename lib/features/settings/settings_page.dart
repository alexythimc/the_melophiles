import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool gapless = true;
  int crossfade = 3;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final sp = await SharedPreferences.getInstance();
    setState(() {
      gapless = sp.getBool('gapless') ?? true;
      crossfade = sp.getInt('crossfade') ?? 3;
    });
  }

  Future<void> _save() async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool('gapless', gapless);
    await sp.setInt('crossfade', crossfade);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(title: const Text('Playback'), dense: true),
          ListTile(
            title: const Text('Sound Quality (EQ)'),
            onTap: () => Get.toNamed('/sound-quality'),
          ),
          SwitchListTile(
            title: const Text('Gapless Playback'),
            value: gapless,
            onChanged: (v) => setState(() {
              gapless = v;
              _save();
            }),
          ),
          ListTile(
            title: const Text('Crossfade (seconds)'),
            subtitle: Text('$crossfade s'),
            trailing: SizedBox(
              width: 180,
              child: Slider(
                value: crossfade.toDouble(),
                min: 0,
                max: 12,
                divisions: 12,
                onChanged: (v) => setState(() {
                  crossfade = v.toInt();
                  _save();
                }),
              ),
            ),
          ),
          ListTile(title: const Text('Library'), dense: true),
          ListTile(
            title: const Text('Rescan Library'),
            onTap: () => Navigator.of(context).pushNamed('/onboarding'),
          ),
          ListTile(
            title: const Text('About'),
            subtitle: const Text('Grok Music — local music player'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
