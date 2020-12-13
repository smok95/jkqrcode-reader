import 'package:get/get.dart';
import 'package:jkqrcode/page/scan_history_page.dart';

import 'page/home_page.dart';
import 'page/scan_result_page.dart';

final appPages = [
  /// '/' : homepage
  GetPage(name: '/', page: () => HomePage()),

  /// '/scan-history' : 스캔 기록 조회
  GetPage(name: '/scan-history', page: () => ScanHistoryPage()),

  /// '/scan-result' : 스캔 결과 조회
  GetPage(name: '/scan-result', page: () => ScanResultPage.route()),
];
