import 'package:admob_flutter/admob_flutter.dart';
import 'package:barcode_info/barcode_info.dart';
import 'package:flag/flag.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jkqrcode/controller/scan_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../my_admob.dart';
import '../my_icon_button.dart' as my;
import 'barcode_view_page.dart';

/// 버튼 터치 이벤트
/// 버튼 터치시 해당 이벤트가 발생하며, [buttonName]과 스캔값인 [text]가 인자로 전달된다.
typedef ButtonPressCallback = void Function(String buttonName, String text);

class ScanResultPage extends StatefulWidget {
  // 스캔코드 형식
  final String format;
  final BarcodeInfo data;
  final ButtonPressCallback onButtonPress;

  ScanResultPage(
      {Key key, @required this.data, this.format, this.onButtonPress})
      : super(key: key);

  factory ScanResultPage.route() {
    final args = Get.arguments;
    final data = args == null ? null : args['data'];
    final callback = args == null ? null : args['onButtonPress'];

    return ScanResultPage(data: data, onButtonPress: callback);
  }

  @override
  _ScanResultPageState createState() => _ScanResultPageState();
}

class _ScanResultPageState extends State<ScanResultPage> {
  /// url_launcher로 오픈가능한 문자열 여부
  bool _canLaunch = false;
  Widget _countries;
  AdmobBanner _admobBanner;

  @override
  void initState() {
    super.initState();

    // url_launcher로 오픈가능한 문자열인지 확인
    canLaunch(widget.data.code).then((value) {
      setState(() {
        _canLaunch = value;
      });
    });

    if (widget.data != null) {
      Set<String> countryCodes;
      if (widget.data.format == BarcodeFormat.ean13) {
        final info = widget.data as EAN13Info;
        countryCodes = info?.countryCodes;
      } else if (widget.data.format == BarcodeFormat.upcA) {
        final info = widget.data as UPCAInfo;
        countryCodes = info?.countryCodes;
      }

      if (countryCodes != null && countryCodes.length > 0) {
        ScanController.fetchCountryInfos(countryCodes).then((countryInfos) {
          setState(() {
            _countries = Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: countryInfos
                  .map((country) =>
                      _buildFlagWithName(country.code, country.name))
                  .toList(),
            );
          });
        });
      }
    }

    _admobBanner = MyAdmob.createAdmobBanner2();
  }

  Widget _buildFlagWithName(final String code, final String name) {
    try {
      return Container(
          padding: EdgeInsets.only(left: 5),
          child: Row(
            children: [
              SizedBox(
                  width: 42,
                  height: 25,
                  child: Flag(code, height: 25, width: 42)),
              Text(
                ' ' + name,
                style: TextStyle(fontSize: 15),
              )
            ],
          ));
    } catch (e) {
      print(e.toString());
      return SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final String title = 'scan result'.tr;
    Widget suffix;
    if (_countries != null) {
      suffix = GestureDetector(
        child: _countries,
        onTap: () {
          Get.defaultDialog(
              title: 'Information'.tr,
              content: Padding(
                  padding: EdgeInsets.all(5),
                  child: Text('ean13 country flag notice'.tr)));
        },
      );
    }

    final code = widget.data.code;
    final format = widget.format == null
        ? widget.data.formatToString().toUpperCase()
        : widget.format;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(
        child: Container(
            margin: EdgeInsets.all(10.0),
            child: Column(children: [
              Expanded(
                child: _resultCard(code, format, suffix: suffix),
              ),
              _admobBanner,
              _controlPanel(),
            ])),
      ),
    );
  }

  void _fireButtonPress(String buttonName) {
    if (widget.onButtonPress != null) {
      widget.onButtonPress(buttonName, widget.data.code);
    }
  }

  Widget _controlPanel() {
    final copy = 'copy'.tr;
    final share = 'share'.tr;
    final search = 'search'.tr;
    final open = 'open'.tr;
    final iconSize = 40.0;

    List<Widget> children = List<Widget>();

    // 복사 버튼 추가
    children.add(my.MyIconButton(Icons.content_copy, copy,
        iconSize: iconSize, onTap: () => _fireButtonPress('copy')));

    // 공유 버튼 추가
    children.add(my.MyIconButton(
      Icons.share,
      share,
      iconSize: iconSize,
      onTap: () => _fireButtonPress('share'),
    ));

    // 검색 버튼 추가
    children.add(my.MyIconButton(
      Icons.search,
      search,
      iconSize: iconSize,
      onTap: () => _fireButtonPress('search'),
    ));

    // 열기 버튼 추가
    if (_canLaunch) {
      children.add(my.MyIconButton(
        Icons.open_in_browser,
        open,
        iconSize: iconSize,
        onTap: () => _fireButtonPress('open'),
      ));
    }

    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: children,
      ),
    );
  }

  Widget _resultCard(String code, String format, {Widget suffix}) {
    final style = TextStyle(
        color: _canLaunch ? Colors.blue : Colors.black,
        fontSize: 17,
        decoration:
            _canLaunch ? TextDecoration.underline : TextDecoration.none);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
            color: Colors.grey[100],
            child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            format,
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          if (suffix != null) suffix
                        ]),
                    margin: EdgeInsets.all(10)))),
        Expanded(
          child: Card(
            child: Scrollbar(
                child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SelectableText(
                      widget.data.code,
                      style: style,
                      onTap: () {
                        if (_canLaunch) {
                          _fireButtonPress('open');
                        }
                      },
                    ),
                  ],
                ),
              ),
            )),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 5, right: 5, bottom: 5),
          child: FlatButton.icon(
              icon: Icon(Icons.find_in_page),
              label: Text('view code'.tr, style: TextStyle(fontSize: 17)),
              onPressed: () {
                Get.to(
                    BarcodeViewPage(widget.data, bottomAdBanner: _admobBanner));
              }),
        )
      ],
    );
  }
}
