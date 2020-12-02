import 'package:barcode_info/barcode_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BarcodeViewPage extends StatelessWidget {
  final BarcodeInfo data;
  final Widget bottomAdBanner;
  BarcodeViewPage(this.data, {this.bottomAdBanner});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('view code'.tr)),
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: BarcodeView(data),
          ),
          if (this.bottomAdBanner != null) this.bottomAdBanner
        ],
      )),
    );
  }
}
