import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barcode_info/barcode_info.dart';
import 'package:jkqrcode/controller/app_controller.dart';
import 'package:jkqrcode/model/scan_history.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ScanHistoryPage extends StatefulWidget {
  ScanHistoryPage();

  @override
  _ScanHistoryPageState createState() => _ScanHistoryPageState();
}

class _ScanHistoryPageState extends State<ScanHistoryPage> {
  Future<List<ScanRecord>> _data;

  @override
  void initState() {
    super.initState();
    _data = AppController().historyController.history();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ScanRecord>>(
      future: _data,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _buildScaffold(context, snapshot.data);
        } else {
          return _buildScaffold(context, null);
        }
      },
    );
  }

  Widget _buildScaffold(BuildContext context, List<ScanRecord> data) {
    final len = data == null ? 0 : data.length;
    print('ScanHistory data length=$len');
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan History'.tr),
        actions: [
          if (len > 0)
            IconButton(
                icon: Icon(Icons.delete_outline),
                onPressed: () {
                  AppController()
                      .clearHistory(context: context, showConfirmDialog: true)
                      .then((deleted) {
                    if (deleted > 0) {
                      setState(() {
                        data.clear();
                      });
                    }
                  });
                })
        ],
      ),
      body: data != null
          ? _buildListView(context, data)
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget _buildListView(BuildContext context, List<ScanRecord> data) {
    return Scrollbar(
      child: ListView(
        children: data
            .map(
              (e) => ListTile(
                leading: _buildFormatIcon(e.data.format),
                title: Text(
                  e.data.code,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  maxLines: 1,
                ),
                subtitle: Text(e.timestamp.toString().substring(0, 19)),
                trailing: InkWell(
                  child: Icon(
                    Icons.cancel,
                    size: 20,
                  ),
                  onTap: () async {
                    if (await AppController().historyController.remove(e)) {
                      setState(() {
                        data.remove(e);
                      });
                    }
                  },
                ),
                onTap: () {
                  Get.toNamed('/scan-result', arguments: {
                    'data': e.data,
                    'onButtonPress': AppController().execute
                  });
                },
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildFormatIcon(BarcodeFormat format) {
    IconData data;
    switch (format) {
      case BarcodeFormat.dataMatrix:
        data = MdiIcons.dataMatrix;
        break;
      case BarcodeFormat.qrCode:
        data = MdiIcons.qrcode;
        break;
      case BarcodeFormat.aztec:
      case BarcodeFormat.codabar:
      case BarcodeFormat.code128:
      case BarcodeFormat.code39:
      case BarcodeFormat.code93:
      case BarcodeFormat.ean8:
      case BarcodeFormat.ean13:
      case BarcodeFormat.itf:
      case BarcodeFormat.maxicode:
      case BarcodeFormat.pdf417:
      case BarcodeFormat.rss14:
      case BarcodeFormat.upcA:
      case BarcodeFormat.upcE:
        data = MdiIcons.barcode;
        break;

      default:
        data = MdiIcons.barcode;
    }

    return Icon(data);
  }
}
