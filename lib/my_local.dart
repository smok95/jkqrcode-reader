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
      'title': 'JK QRCode Reader',
      'scan result': 'Scan Result',
      'copy': 'Copy',
      'share': 'Share',
      'search': 'Search',
      'open': 'Open',
      'google url': 'www.google.com',
      'settings': 'Settings',
      'open settings': 'OPEN SETTINGS',
      'dark mode': 'Dark Mode',
      'share app': 'Share App',
      'rate review': 'Rate 5 stars',
      'more apps': 'More apps',
      'app info': 'About this app',
      'vibrate': 'Vibrate',
      'ean13 country flag notice':
          'The first three digits of the EAN-13 (GS1 Prefix) usually identify the GS1 Member Organization which the manufacturer has joined\n(not necessarily where the product is actually made).',
    },
    'ko': {
      'title': 'JK QR코드 리더',
      'scan result': '스캔 결과',
      'copy': '복사',
      'share': '공유',
      'search': '검색',
      'open': '열기',
      'google url': 'www.google.co.kr',
      'settings': '설정',
      'open settings': '설정 열기',
      'dark mode': '다크 모드',
      'share app': '앱 공유하기',
      'rate review': '별점주기',
      'more apps': '다른 앱 보기',
      'app info': '앱 정보',
      'vibrate': '진동 알림',
      'ean13 country flag notice':
          '현재 인식된 바코드를 발급한 국가(또는 지역)의 정보이며, 제품의 원산지 정보는 아닙니다.',
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
