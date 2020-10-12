import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyLocal {
  MyLocal(this.locale);
  final Locale locale;

  static MyLocal of(BuildContext context) {
    return Localizations.of<MyLocal>(context, MyLocal);
  }

  static Map<String, Map<String, String>> _values = {
    'en': {
      'app info': 'About this app',
      'copy': 'Copy',
      'dark mode': 'Dark Mode',
      'ean13 country flag notice':
          'The first three digits of the EAN-13 (GS1 Prefix) usually identify the GS1 Member Organization which the manufacturer has joined\n(not necessarily where the product is actually made).',
      'google url': 'www.google.com',
      'installed date': 'Installed',
      'keep the screen on': 'Keep the screen on',
      'more apps': 'More apps',
      'open': 'Open',
      'open settings': 'OPEN SETTINGS',
      'open website automatically': 'Open website automatically',
      'rate review': 'Rate 5 stars',
      'scan result': 'Scan Result',
      'search': 'Search',
      'settings': 'Settings',
      'share': 'Share',
      'share app': 'Share App',
      'title': 'JK QRCode Reader',
      'updated date': 'Updated',
      'vibrate': 'Vibrate',
      'view code': 'View code',
    },
    'ko': {
      'app info': '앱 정보',
      'copy': '복사',
      'dark mode': '다크 모드',
      'ean13 country flag notice':
          '현재 표시된 국기는 바코드를 발급한 국가(또는 지역)의 정보이며, 제품의 원산지 정보는 아닙니다.',
      'google url': 'www.google.co.kr',
      'installed date': '설치 일자',
      'keep the screen on': '화면을 켜진 상태로 유지',
      'more apps': '다른 앱 보기',
      'open': '열기',
      'open settings': '설정 열기',
      'open website automatically': '웹사이트 자동으로 열기',
      'rate review': '별점주기',
      'scan result': '스캔 결과',
      'search': '검색',
      'settings': '설정',
      'share': '공유',
      'share app': '앱 공유하기',
      'title': 'JK QR코드 리더',
      'updated date': '업데이트 일자',
      'vibrate': '진동 알림',
      'view code': '코드 보기',
    },
  };

  /// 앱 타이틀
  String get title {
    return _values[locale.languageCode]['title'];
  }

  /// 스캔결과
  String get scanResult {
    return _values[locale.languageCode]['scan result'];
  }

  String get copy {
    return _values[locale.languageCode]['copy'];
  }

  String get share {
    return _values[locale.languageCode]['share'];
  }

  String get search {
    return _values[locale.languageCode]['search'];
  }

  String get open {
    return _values[locale.languageCode]['open'];
  }

  String get google_url {
    return _values[locale.languageCode]['google url'];
  }

  String text(String name) {
    return _values[locale.languageCode][name];
  }
}

class MyLocalDelegate extends LocalizationsDelegate<MyLocal> {
  const MyLocalDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ko'].contains(locale.languageCode);

  @override
  Future<MyLocal> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of AppLocalizations.
    return SynchronousFuture<MyLocal>(MyLocal(locale));
  }

  @override
  bool shouldReload(MyLocalDelegate old) => false;
}
