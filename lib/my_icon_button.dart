import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyIconButton extends StatelessWidget {
  final IconData _iconData;
  final String _text;
  final double iconSize;
  final GestureTapCallback onTap;
  MyIconButton(this._iconData, this._text,
      {Key key, this.iconSize = 20.0, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: InkWell(
            onTap: this.onTap,
            child: Center(
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.all(5.0)),
                  Icon(_iconData, size: iconSize),
                  Text(_text),
                  Padding(padding: EdgeInsets.all(5.0)),
                ],
              ),
            )));
  }
}
