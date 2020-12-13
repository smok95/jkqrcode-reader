import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';
import 'package:get/get.dart';

import 'app_settings.dart';
import 'scan_history_controller.dart';

/// 전면카메라 존재 유무
Future<bool> checkFrontCamera() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

  final features = androidInfo?.systemFeatures ?? null;
  if (features == null) return false;
  return features.indexOf('android.hardware.camera.front') != -1;
}

class AppController {
  static final AppController _instance = AppController._internal();

  factory AppController() {
    return _instance;
  }

  AppController._internal();

  /// App 실행 준비
  Future<bool> init() async {
    // 전면카메라 존재유무 확인
    _hasFrontCamera = await checkFrontCamera();

    // 환경설정 초기화
    return await _settings.init();
  }

  /// 진동 실행
  vibrate() async {
    if (!_settings.vibrateOn) return;

    if (await Vibration.hasVibrator()) {
      Vibration.vibrate();
    }
  }

  /// 명령실행
  execute(String cmd, String message) async {
    switch (cmd) {
      case 'copy':
        Clipboard.setData(ClipboardData(text: message));
        break;
      case 'share':
        Share.share(message);
        break;
      case 'open':
        if (await canLaunch(message)) {
          await launch(message);
        }
        break;
      case 'search':
        final google = 'google url'.tr;
        final encoded = Uri.encodeFull('https://$google/search?q=$message');
        if (await canLaunch(encoded)) {
          await launch(encoded);
        }
        break;
      default:
    }
  }

  /// 스캔 기록 전체 삭제
  Future<int> clearHistory(
      {BuildContext context, bool showConfirmDialog = false}) async {
    if (showConfirmDialog && context != null) {
      final result = await showOkCancelAlertDialog(
          context: context,
          okLabel: 'ok'.tr,
          cancelLabel: 'cancel'.tr,
          message: 'Are you sure you want to clear history?'.tr);
      if (result != OkCancelResult.ok) return 0;
    }

    return await historyController.clear();
  }

  /// 스캔 기록 조회
  Future<void> showScanHistory() async {
    return Get.toNamed('/scan-history');
  }

  /// 화면 켜진상태로 유지 여부
  bool get keepScreenOn => _settings.keepScreenOn;
  set keepScreenOn(bool value) => _settings.keepScreenOn = value;

  /// 전면카메라 존재여부
  bool get hasFrontCamera => _hasFrontCamera;

  /// 스캔값이 URL일때 자동으로 열기 여부
  bool get openUrlAutomatically => _settings.openUrlAutomatically;
  set openUrlAutomatically(bool value) =>
      _settings.openUrlAutomatically = value;

  /// 진동사용 여부
  bool get isVibrateOn => _settings.vibrateOn;
  set vibrateOn(bool value) => _settings.vibrateOn = value;

  ScanHistoryController get historyController => ScanHistoryController.instance;

  final _settings = AppSettings();
  bool _hasFrontCamera = false;
}
