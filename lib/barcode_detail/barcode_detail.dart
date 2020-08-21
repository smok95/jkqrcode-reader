import 'ean13_detail.dart';
import 'upca_detail.dart';

export 'ean13_detail.dart';
export 'upca_detail.dart';

enum BarcodeFormat {
  unknown,
  ean13,
  upc_a,
}

class BarcodeDetail {
  BarcodeDetail(this.format, this.code, {this.detail, String formatText}) {
    if (format == BarcodeFormat.unknown && formatText != null) {
      _formatText = formatText;
    }
  }

  static Future<BarcodeDetail> create(String format, String code) async {
    if (format == 'EAN_13') {
      final info = await EAN13Detail.create(code);
      return BarcodeDetail(BarcodeFormat.ean13, code, detail: info);
    } else if (format == 'UPC_A') {
      final info = await UPCADetail.create(code);
      return BarcodeDetail(BarcodeFormat.upc_a, code, detail: info);
    } else {
      return BarcodeDetail(BarcodeFormat.unknown, code, formatText: format);
    }
  }

  /// Barcode detail information
  final dynamic detail;

  /// BarcodeFormat
  final BarcodeFormat format;

  /// Barcode value
  final String code;

  /// 알 수 없는 format일 때 확인하기 위한 text 값
  String get formatText {
    String text;
    switch (format) {
      case BarcodeFormat.ean13:
        text = 'EAN_13';
        break;
      default:
        text = _formatText != null ? _formatText : '';
    }
    return text;
  }

  String _formatText;
}
