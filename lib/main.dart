import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jk/flutter_jk.dart';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jkqrcode/controller/app_controller.dart';
import 'package:jkqrcode/controller/scan_history_controller.dart';

import 'my_admob.dart';
import 'my_theme.dart';
import 'pages.dart';
import 'page/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await AppController().init();

  ScanHistoryController.instance.open();

  // AdMob 초기화
  MyAdmob.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Prevent device orientation changes.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    final messages = GetxMessages();
    messages.add('en_US', 'title', 'JK QRCode Reader');
    messages.add('ko_KR', 'title', 'JK QR코드 리더');
    messages.add('pl_PL', 'title', 'JK QRCode Reader');

    messages.add('en_US', 'ean13 country flag notice',
        'The first three digits of the EAN-13 (GS1 Prefix) usually identify the GS1 Member Organization which the manufacturer has joined\n(not necessarily where the product is actually made).');
    messages.add('ko_KR', 'ean13 country flag notice',
        '현재 표시된 국기는 바코드를 발급한 국가(또는 지역)의 정보이며, 제품의 원산지 정보는 아닙니다.');
    messages.add('pl_PL', 'ean13 country flag notice',
        'The first three digits of the EAN-13 (GS1 Prefix) usually identify the GS1 Member Organization which the manufacturer has joined\n(not necessarily where the product is actually made).');

    return GetMaterialApp(
      translations: messages,
      onGenerateTitle: (BuildContext context) => 'title'.tr,
      locale: ui.window.locale,
      fallbackLocale: Locale('en', 'US'),
      theme: myTheme,
      home: HomePage(),
      getPages: appPages,
    );
  }
}
