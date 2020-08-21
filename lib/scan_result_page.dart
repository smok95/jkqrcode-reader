import 'package:flag/flag.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jkqrcode/barcode_detail/country_info.dart';
import 'package:url_launcher/url_launcher.dart';

import 'my_local.dart';
import 'my_admob.dart';
import 'my_icon_button.dart' as my;
import 'barcode_detail/barcode_detail.dart';

/// 버튼 터치 이벤트
/// 버튼 터치시 해당 이벤트가 발생하며, [buttonName]과 스캔값인 [text]가 인자로 전달된다.
typedef ButtonPressCallback = void Function(String buttonName, String text);

class ScanResultPage extends StatefulWidget {
  /// 스캔결과 값
  final String text;
  // 스캔코드 형식
  final String format;
  final BarcodeDetail detail;
  final ButtonPressCallback onButtonPress;

  ScanResultPage(
      {Key key, this.text, this.format, this.onButtonPress, this.detail})
      : super(key: key);

  @override
  _ScanResultPageState createState() => _ScanResultPageState();
}

class _ScanResultPageState extends State<ScanResultPage> {
  bool _canLaunch = false;
  Widget _countries;

  @override
  void initState() {
    super.initState();

    // url_launcher로 오픈가능한 문자열인지 확인
    canLaunch(widget.text).then((value) {
      setState(() {
        _canLaunch = value;
      });
    });

    if (widget.detail != null) {
      List<CountryInfo> countryInfos;
      if (widget.detail.format == BarcodeFormat.ean13) {
        final info = widget.detail?.detail as EAN13Detail;
        countryInfos = info?.countries;
      } else if (widget.detail.format == BarcodeFormat.upc_a) {
        final info = widget.detail?.detail as UPCADetail;
        countryInfos = info?.countries;
      }

      if (countryInfos != null) {
        _countries = Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: countryInfos
              .map((country) => _buildFlagWithName(country.code, country.name))
              .toList(),
        );
      }
    }
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
    final lo = MyLocal.of(context).text;
    final String title = lo('scan result');
    Widget suffix;
    if (_countries != null) {
      suffix = GestureDetector(
        child: _countries,
        onTap: () {
          Get.defaultDialog(
              title: "Infomation",
              content: Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(lo('ean13 country flag notice'))));
          /*
          Get.snackbar(
              'EAN13 GS1 Company Prefix', lo('ean13 country flag notice'),
              duration: Duration(seconds: 20),
              icon: Icon(Icons.info_outline),
              shouldIconPulse: false,
              mainButton: FlatButton(
                  onPressed: () => Get.back(), child: Icon(Icons.close)));
                  */
        },
      );
    }

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
                child: _resultCard(widget.text, widget.format, suffix: suffix),
              ),
              MyAdmob.createAdmobBanner2(),
              _controlPanel(widget.text),
            ])),
      ),
    );
  }

  void _fireButtonPress(String buttonName) {
    if (widget.onButtonPress != null) {
      widget.onButtonPress(buttonName, widget.text);
    }
  }

  Widget _controlPanel(String text) {
    final copy = MyLocal.of(context).copy;
    final share = MyLocal.of(context).share;
    final search = MyLocal.of(context).search;
    final open = MyLocal.of(context).open;
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

  Widget _resultCard(String text, String format, {Widget suffix}) {
    return Column(
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
                        widget.format,
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      if (suffix != null) suffix,
                    ]),
                margin: EdgeInsets.all(10),
              ),
            )),
        Expanded(
          child: Card(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none),
                      readOnly: true,
                      maxLines: null,
                      controller: TextEditingController(text: widget.text),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
