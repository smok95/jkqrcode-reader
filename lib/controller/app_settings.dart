import 'package:hive/hive.dart';

class AppSettings {
  static AppSettings _instance = AppSettings._internal();
  Box _box;
  factory AppSettings() {
    return _instance;
  }

  Future<bool> init() async {
    _box = await Hive.openBox('settings');
    return _box != null;
  }

  AppSettings._internal();

  /// 진동 사용
  bool get vibrateOn {
    if (_box == null) return true;
    return _box.get('vibrate') ?? true;
  }

  set vibrateOn(bool value) {
    if (_box == null) return;
    _box.put('vibrate', value);
  }

  /// 화면 켜진 상태 유지
  bool get keepScreenOn {
    if (_box == null) return true;
    return _box.get('keepTheScreenOn') ?? true;
  }

  set keepScreenOn(bool value) {
    if (_box == null) return;
    _box.put('keepTheScreenOn', value);
  }

  /// 웹페이지 자동으로 열기
  bool get openUrlAutomatically {
    if (_box == null) return false;
    return _box.get('urlAutoOpen') ?? false;
  }

  set openUrlAutomatically(bool value) {
    if (_box == null) return;
    _box.put('urlAutoOpen', value);
  }
}
