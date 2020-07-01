import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import 'my_admob.dart';
import 'app_localizations.dart';
import 'scan_result_page.dart';
import 'my_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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

    return MaterialApp(
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context).title,
      localizationsDelegates: [
        const AppLocalizationsDelegate(),
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

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).title),
        actions: [
          IconButton(
              icon: Icon(_flashOn ? Icons.flash_off : Icons.flash_on),
              tooltip: _flashOn ? 'Flash Off' : 'Flash On',
              onPressed: _onFlashOnOff),
          Padding(padding: EdgeInsets.all(10.0)),
        ],
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
        final google = AppLocalizations.of(context).google_url;
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
    final route = ModalRoute.of(context);
    print('route name=${route?.settings?.name}');

    if (_alreadyPushed) return;

    _alreadyPushed = true;
    await Navigator.push(
        this.context,
        MaterialPageRoute(
            builder: (context) => ScanResultPage(
                  text: text,
                  format: format,
                  onButtonPress: _runCommand,
                )));

    _alreadyPushed = false;
    _controller?.resumeCamera();
  }

  void _onQRViewCreated(QRViewController controller) {
    this._controller = controller;

    controller.scannedDataStream.listen((scanData) {
      var json = jsonDecode(scanData);
      if (json != null) {
        controller.pauseCamera();
        _showScanData(json['format'], json['text']);
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
