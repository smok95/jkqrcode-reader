import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:get/get.dart';

typedef DarkModeCallback = void Function(bool darkMode);
typedef SettingChangeCallback = void Function(String name, dynamic value);

class SettingsPage extends StatefulWidget {
  final DarkModeCallback onToggleDarkMode;
  final SettingChangeCallback onSettingChange;

  /// 진동기능 사용여부
  bool useVibrate;

  /// 화면 켜진 상태로 유지
  bool keepTheScreenOn = false;

  /// 웹페이지 자동으로 열기
  bool autoOpenWeb = false;

  SettingsPage(
      {this.onToggleDarkMode,
      this.onSettingChange,
      this.useVibrate,
      this.autoOpenWeb,
      this.keepTheScreenOn});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _fireChange(final String name, dynamic value) {
    if (widget.onSettingChange != null) {
      widget.onSettingChange(name, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'settings'.tr,
        ),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            //title: 'Section',
            tiles: [
              SettingsTile.switchTile(
                  leading: Icon(Icons.vibration),
                  title: 'vibrate'.tr,
                  onToggle: (use) {
                    setState(() {
                      widget.useVibrate = use;
                      _fireChange('vibrate', use);
                    });
                  },
                  switchValue: widget.useVibrate),
              SettingsTile.switchTile(
                  leading: Icon(Icons.settings_brightness),
                  title: 'keep the screen on'.tr,
                  onToggle: (value) {
                    _fireChange('keep the screen on', value);
                    setState(() {
                      widget.keepTheScreenOn = value;
                    });
                  },
                  switchValue: widget.keepTheScreenOn),
              SettingsTile.switchTile(
                  leading: Icon(Icons.open_in_browser),
                  title: 'open website automatically'.tr,
                  onToggle: (value) {
                    _fireChange('open website automatically', value);
                    setState(() {
                      widget.autoOpenWeb = value;
                    });
                  },
                  switchValue: widget.autoOpenWeb)
            ],
          ),
          SettingsSection(
            //title: '',
            tiles: [
              SettingsTile(
                  leading: Icon(Icons.rate_review),
                  title: 'rate review'.tr,
                  onTap: () {
                    _fireChange('rate review', null);
                  }),
              SettingsTile(
                  leading: Icon(Icons.share),
                  title: 'share app'.tr,
                  onTap: () {
                    _fireChange('share app', null);
                  }),
              SettingsTile(
                  leading: Icon(Icons.apps),
                  title: 'more apps'.tr,
                  onTap: () {
                    _fireChange('more apps', null);
                  }),
              SettingsTile(
                leading: Icon(Icons.info_outline),
                title: 'app info'.tr,
                onTap: () async {
                  PackageInfo packageInfo = await PackageInfo.fromPlatform();

                  showAboutDialog(
                    context: context,
                    applicationName: packageInfo.appName,
                    applicationVersion: packageInfo.version,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
