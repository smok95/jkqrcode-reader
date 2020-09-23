import 'dart:convert';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:screen/screen.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';

import 'barcode_detail/barcode_detail.dart';
import 'my_private_data.dart';
import 'settings_page.dart';
import 'my_admob.dart';
import 'my_local.dart';
import 'scan_result_page.dart';
import 'my_theme.dart';

/// 전면카메라 존재 유무
Future<bool> checkFrontCamera() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

  final features = androidInfo?.systemFeatures ?? null;
  if (features == null) return false;
  return features.indexOf('android.hardware.camera.front') != -1;
}

bool hasFrontCamera = false;
Box box;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  box = await Hive.openBox('settings');

  hasFrontCamera = await checkFrontCamera();

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

    return GetMaterialApp(
      onGenerateTitle: (BuildContext context) => MyLocal.of(context).title,
      localizationsDelegates: [
        const MyLocalDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [const Locale('en', ''), const Locale('ko', '')],
      theme: myTheme,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  QRViewController _controller;
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  bool _alreadyPushed = false;
  bool _flashOn = false;
  bool _vibrateOn = true;
  bool _keepScreenOn = true;

  @override
  void initState() {
    super.initState();

    if (box != null) {
      _vibrateOn = box.get('vibrate') ?? true;
      _keepScreenOn = box.get('keepTheScreenOn') ?? true;
    }

    Screen.keepOn(_keepScreenOn);
  }

  /// QRView 생성
  QRView _createQRView() {
    return QRView(
      key: _qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.amber,
        borderRadius: 15,
        borderLength: 50,
        borderWidth: 10,
        cutOutSize: 250,
      ),
    );
  }

  void _onFlashOnOff() {
    if (_controller == null) return;

    setState(() {
      _flashOn = !_flashOn;
    });
    _controller.toggleFlash();
  }

  void _flipCamera() {
    if (_controller == null) return;
    _controller.flipCamera();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = List<Widget>();
    if (hasFrontCamera) {
      actions.add(
          IconButton(icon: Icon(Icons.switch_camera), onPressed: _flipCamera));
    }
    actions.add(IconButton(
        icon: Icon(_flashOn ? Icons.flash_off : Icons.flash_on),
        tooltip: _flashOn ? 'Flash Off' : 'Flash On',
        onPressed: _onFlashOnOff));

    actions.add(Padding(padding: EdgeInsets.all(10.0)));

    return Scaffold(
      appBar: AppBar(
        title: Text(MyLocal.of(context).title),
        actions: actions,
        leading: IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              Get.to(SettingsPage(
                useVibrate: _vibrateOn,
                keepTheScreenOn: _keepScreenOn,
                onSettingChange: (name, value) {
                  String cmd;
                  String text;
                  if (name == 'share app') {
                    cmd = 'share';
                    text = MyPrivateData.playStoreUrl;
                  } else if (name == 'rate review') {
                    cmd = 'open';
                    text = MyPrivateData.playStoreUrl;
                  } else if (name == 'more apps') {
                    cmd = 'open';
                    text = MyPrivateData.googlePlayDeveloperPageUrl;
                  } else if (name == 'vibrate') {
                    _vibrateOn = value as bool;
                    if (box != null) {
                      box.put('vibrate', _vibrateOn);
                    }
                    return;
                  } else if (name == 'keep the screen on') {
                    _keepScreenOn = value as bool;
                    Screen.keepOn(_keepScreenOn);
                    if (box != null) {
                      box.put('keepTheScreenOn', _keepScreenOn);
                    }
                  } else {
                    return;
                  }

                  _runCommand(cmd, text);
                },
              ));
            }),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _createQRView()),
            MyAdmob.createAdmobBanner(),
          ],
        ),
      ),
    );
  }

  void _runCommand(String cmd, String text) async {
    switch (cmd) {
      case 'copy':
        Clipboard.setData(ClipboardData(text: text));
        break;
      case 'share':
        Share.share(text);
        break;
      case 'open':
        if (await canLaunch(text)) {
          await launch(text);
        }
        break;
      case 'search':
        final google = MyLocal.of(context).google_url;
        final encoded = Uri.encodeFull('https://${google}/search?q=${text}');
        if (await canLaunch(encoded)) {
          await launch(encoded);
        }
        break;
      default:
    }
  }

  /// 코드 스캔결과 화면에 표시
  void _showScanData(String format, String text) async {
    if (_alreadyPushed) return;

    _alreadyPushed = true;

    // 바코드 상세정보 생성
    BarcodeDetail info;
    try {
      info = await BarcodeDetail.create(format, text);
    } catch (e) {
      print(e.toString());
    }

    _vibrate();
    await Get.to(ScanResultPage(
        text: text, format: format, detail: info, onButtonPress: _runCommand));

    _alreadyPushed = false;
    _controller?.resumeCamera();
  }

  void _onQRViewCreated(QRViewController controller) {
    this._controller = controller;

    controller.scannedDataStream.listen((scanData) {
      var json = jsonDecode(scanData);
      if (json != null) {
        var format = json['format'];
        final text = json['text'] as String;
        if (format == null) format = '';
        if (text != null && text.length > 0) {
          controller.pauseCamera();
          _showScanData(format, text);
        }
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _vibrate() async {
    if (!_vibrateOn) return;

    if (await Vibration.hasVibrator()) {
      Vibration.vibrate();
    }
  }
}
