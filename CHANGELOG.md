# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
ScanResultPage 에 스캔시간 표시기능 추가가 필요함.

## 1.7.0 (8) - 2020-12-13
### Added
- add ScanHistory 

### Changed
- localization방식 LocalizationsDelegate에서 GetX 로 변경
- get 3.4.1 -> 3.17.1
- BarcodeDetail 별도 pakcage로 분리(BarcodeInfo)
- BarcodeViewPage에서 body부분 BarcodeView로 분리 후 BarcodeInfo로 이전
- package_info: ^0.4.1 -> ^0.4.3+2 
- url_launcher: ^5.5.0 -> ^5.7.10
- share: ^0.6.4+3 -> ^0.6.5+4

### Removed
- flutter_localizations 참조 삭제

## 1.6.0 (7) - 2020-10-11
### Added
- 자동으로 웹사이트 열기 기능 추가
- Splash Screen 추가

### Changed
- 배경색상값 일부수정

## 1.5.0 - 2020-09-23
### Changed
- compileSdkVersion/targetSdkVersion 28에서 29로 변경
- launch background color from white to black.

### Added
- Keep the screen on 기능 추가
- 코드 보기 기능 추가

[1.5.0]: https://github.com/smok95/jkqrcode-reader
