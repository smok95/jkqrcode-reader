import 'dart:convert';

import 'package:barcode_info/barcode_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jkqrcode/controller/app_controller.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:screen/screen.dart';

import '../my_admob.dart';
import '../my_private_data.dart';
import 'scan_result_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  QRViewController _controller;
  AppController _appController = AppController();
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  bool _alreadyPushed = false;
  bool _flashOn = false;

  @override
  void initState() {
    super.initState();

    // 화면 켜진상태 유지 설정
    Screen.keepOn(_appController.keepScreenOn);
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
    if (_appController.hasFrontCamera) {
      actions.add(
          IconButton(icon: Icon(Icons.switch_camera), onPressed: _flipCamera));
    }
    actions.add(IconButton(
        icon: Icon(_flashOn ? Icons.flash_off : Icons.flash_on),
        tooltip: _flashOn ? 'Flash Off' : 'Flash On',
        onPressed: _onFlashOnOff));

    actions.add(IconButton(
      icon: Icon(Icons.history_sharp),
      onPressed: () async {
        _controller?.pauseCamera();
        await _appController.showScanHistory();
        _controller?.resumeCamera();
      },
    ));
    actions.add(Padding(padding: EdgeInsets.all(10.0)));

    return Scaffold(
      appBar: AppBar(
        title: Text('title'.tr),
        actions: actions,
        leading: IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              Get.to(SettingsPage(
                useVibrate: _appController.isVibrateOn,
                keepTheScreenOn: _appController.keepScreenOn,
                autoOpenWeb: _appController.openUrlAutomatically,
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
                    _appController.vibrateOn = value as bool;
                    return;
                  } else if (name == 'keep the screen on') {
                    _appController.keepScreenOn = value as bool;
                  } else if (name == 'open website automatically') {
                    _appController.openUrlAutomatically = value as bool;
                  } else {
                    return;
                  }

                  _appController.execute(cmd, text);
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

  /// 코드 스캔결과 화면에 표시
  void _showScanData(String format, String text) async {
    if (_alreadyPushed) return;

    _appController.vibrate();

    // 바코드 상세정보 생성
    BarcodeInfo info;
    try {
      info = BarcodeInfo.create(format, text);
    } catch (e) {
      print(e.toString());
    }

    // Add to history
    _appController.historyController.add(info);

    if (_appController.openUrlAutomatically) {
      _appController.execute('open', text);
      return;
    }

    _alreadyPushed = true;

    await Get.toNamed('/scan-result',
        arguments: {'data': info, 'onButtonPress': _appController.execute});

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
}
