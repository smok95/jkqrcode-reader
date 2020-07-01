import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  AppLocalizations(this.locale);
  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'title': 'JK QRCode Reader',
      'scan result': 'Scan Result',
      'copy': 'Copy',
      'share': 'Share',
      'search': 'Search',
      'open': 'Open',
      'google url': 'www.google.com',
    },
    'ko': {
      'title': 'JK QR코드 리더',
      'scan result': '스캔 결과',
      'copy': '복사',
      'share': '공유',
      'search': '검색',
      'open': '열기',
      'google url': 'www.google.co.kr',
    },
  };

  /// 앱 타이틀
  String get title {
    return _localizedValues[locale.languageCode]['title'];
  }

  /// 스캔결과
  String get scanResult {
    return _localizedValues[locale.languageCode]['scan result'];
  }

  String get copy {
    return _localizedValues[locale.languageCode]['copy'];
  }

  String get share {
    return _localizedValues[locale.languageCode]['share'];
  }

  String get search {
    return _localizedValues[locale.languageCode]['search'];
  }

  String get open {
    return _localizedValues[locale.languageCode]['open'];
  }

  String get google_url {
    return _localizedValues[locale.languageCode]['google url'];
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ko'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of AppLocalizations.
    print('load call');
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
