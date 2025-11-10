// EQ controller: manages presets, custom bands, bass/virtualizer, dolby toggle
import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EQController extends GetxController {
  // 10-band EQ values in dB (-12 to +12)
  var bands = List<double>.filled(10, 0.0).obs;
  var bassBoost = 0.0.obs; // 0-100
  var virtualizer = 0.0.obs; // 0-100
  var dolby = false.obs;
  var preset = 'Normal'.obs;

  final presets = <String, List<double>>{
    'Normal': List<double>.filled(10, 0.0),
    'Classical': List<double>.filled(10, 0.0),
    'Dance': [4.0, 3.0, 2.0, 0.0, -2.0, -3.0, -2.0, 0.0, 2.0, 3.0],
    'Pop': [3.0, 2.0, 1.0, 0.0, -1.0, -1.0, 0.0, 1.0, 2.0, 3.0],
    'Rock': [5.0, 3.0, 0.0, -2.0, -1.0, 0.0, 2.0, 4.0, 5.0, 6.0],
    'Jazz': [0.0, 1.0, 2.0, 2.0, 1.0, 0.0, -1.0, -1.0, 0.0, 1.0],
    'Heavy': [6.0, 4.0, 1.0, -2.0, -3.0, -2.0, 1.0, 4.0, 6.0, 8.0],
    'Country': [2.0, 1.0, 0.0, -1.0, 0.0, 1.0, 2.0, 3.0, 2.0, 1.0],
  };

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    final sp = await SharedPreferences.getInstance();
    final bStr = sp.getString('eq_bands');
    if (bStr != null) {
      try {
        final list = List<dynamic>.from(jsonDecode(bStr));
        for (int i = 0; i < bands.length && i < list.length; i++) {
          bands[i] = (list[i] as num).toDouble();
        }
      } catch (e) {}
    }
    bassBoost.value = sp.getDouble('eq_bass') ?? 0.0;
    virtualizer.value = sp.getDouble('eq_virtualizer') ?? 0.0;
    dolby.value = sp.getBool('eq_dolby') ?? false;
    preset.value = sp.getString('eq_preset') ?? 'Normal';
  }

  Future<void> save() async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString('eq_bands', jsonEncode(bands.toList()));
    await sp.setDouble('eq_bass', bassBoost.value);
    await sp.setDouble('eq_virtualizer', virtualizer.value);
    await sp.setBool('eq_dolby', dolby.value);
    await sp.setString('eq_preset', preset.value);
  }

  void applyPreset(String name) {
    final vals = presets[name];
    if (vals != null) {
      for (int i = 0; i < bands.length && i < vals.length; i++) {
        bands[i] = vals[i].toDouble();
      }
      preset.value = name;
      save();
    }
  }

  void setCustomBand(int idx, double value) {
    bands[idx] = value;
    preset.value = 'Custom';
    save();
  }

  void setBass(double v) {
    bassBoost.value = v;
    save();
  }

  void setVirtualizer(double v) {
    virtualizer.value = v;
    save();
  }

  void setDolby(bool v) {
    dolby.value = v;
    save();
  }
}
