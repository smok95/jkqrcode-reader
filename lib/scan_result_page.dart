import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'my_local.dart';
import 'my_admob.dart';
import 'my_icon_button.dart' as my;

/// 버튼 터치 이벤트
/// 버튼 터치시 해당 이벤트가 발생하며, [buttonName]과 스캔값인 [text]가 인자로 전달된다.
typedef ButtonPressCallback = void Function(String buttonName, String text);

class ScanResultPage extends StatefulWidget {
  /// 스캔결과 값
  final String text;
  // 스캔코드 형식
  final String format;
  final ButtonPressCallback onButtonPress;

  ScanResultPage({Key key, this.text, this.format, this.onButtonPress})
      : super(key: key);

  @override
  _ScanResultPageState createState() => _ScanResultPageState();
}

class _ScanResultPageState extends State<ScanResultPage> {
  bool _canLaunch = false;

  @override
  void initState() {
    super.initState();

    // url_launcher로 오픈가능한 문자열인지 확인
    canLaunch(widget.text).then((value) {
      setState(() {
        _canLaunch = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final String title = MyLocal.of(context).scanResult;

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
                child: _resultCard(widget.text, widget.format),
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

    return ListView(
      children: [
        ListTile(
          leading: Icon(Icons.content_copy),
          title: Text(MyLocal.of(context).copy),
        ),
        ListTile(
          leading: Icon(Icons.share),
          title: Text(MyLocal.of(context).share),
        ),
        ListTile(
          leading: Icon(Icons.search),
          title: Text(MyLocal.of(context).search),
        ),
        ListTile(
          leading: my.MyIconButton(Icons.open_in_browser, "Open"),
          title: Text("Open"),
        )
      ],
    );
  }

  Card _resultCard(String text, String format) {
    return Card(
        child: Column(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            child: Text(
              widget.format,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            margin: EdgeInsets.all(20.0),
          ),
        ),
        Expanded(
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
      ],
    ));
  }
}
