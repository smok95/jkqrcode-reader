import 'package:barcode_widget/barcode_widget.dart';

import 'ean13_detail.dart';
import 'upca_detail.dart';

export 'ean13_detail.dart';
export 'upca_detail.dart';

enum BarcodeFormat {
  unknown,
  aztec,
  codabar,
  code128,
  code39,
  code93,
  dataMatrix,
  ean8,
  ean13,
  itf,
  maxicode,
  pdf417,
  qrCode,
  rss14,
  upcA,
  upcE,
}

abstract class BarcodeDetail {
  BarcodeDetail(this.format, this.code);

  static Future<BarcodeDetail> create(String format, String code) async {
    if (format == 'EAN_13') {
      return await EAN13Detail.create(code);
    } else if (format == 'UPC_A') {
      return await UPCADetail.create(code);
    } else if (format == 'QR_CODE') {
      return QrCodeDetail(code);
    } else if (format == 'DATA_MATRIX') {
      return DataMatrixDetail(code);
    } else if (format == 'AZTEC') {
      return AztecDetail(code);
    } else if (format == 'CODABAR') {
      return CodabarDetail(code);
    } else if (format == 'CODE_128') {
      return Code128Detail(code);
    } else if (format == 'CODE_39') {
      return Code39Detail(code);
    } else if (format == 'CODE_93') {
      return Code93Detail(code);
    } else if (format == 'EAN_8') {
      return Ean8Detail(code);
    } else if (format == 'ITF') {
      return ItfDetail(code);
    } else if (format == 'MAXICODE') {
      return MaxicodeDetail(code);
    } else if (format == 'PDF_417') {
      return Pdf417Detail(code);
    } else if (format == 'RSS_14') {
      return Rss14Detail(code);
    } else if (format == 'UPC_E') {
      return UPCEDetail(code);
    } else {
      return BarcodeUnknown(code, format);
    }

    /// [https://zxing.github.io/zxing/apidocs/com/google/zxing/BarcodeFormat.html]
    /// EAN_13, UPC_A, QR_CODE, DATA_MATRIX, AZTEC, CODABAR, CODE_128, CODE_39
    /// CODE_93, EAN_8, ITF, MAXICODE, PDF_417, RSS_14, UPC_E
    ///
    ///  RSS_EXPANDED, UPC_EAN_EXTENSION
  }

  /// BarcodeFormat
  final BarcodeFormat format;

  /// Barcode value
  final String code;
}

class BarcodeUnknown extends BarcodeDetail {
  BarcodeUnknown(String code, this.formatText)
      : super(BarcodeFormat.unknown, code);

  final String formatText;
}

class QrCodeDetail extends BarcodeDetail {
  QrCodeDetail(String code) : super(BarcodeFormat.qrCode, code);
}

class DataMatrixDetail extends BarcodeDetail {
  DataMatrixDetail(String code) : super(BarcodeFormat.dataMatrix, code);
}

class AztecDetail extends BarcodeDetail {
  AztecDetail(String code) : super(BarcodeFormat.aztec, code);
}

class CodabarDetail extends BarcodeDetail {
  CodabarDetail(String code) : super(BarcodeFormat.codabar, code);
}

class Code128Detail extends BarcodeDetail {
  Code128Detail(String code) : super(BarcodeFormat.code128, code);
}

class Code39Detail extends BarcodeDetail {
  Code39Detail(String code) : super(BarcodeFormat.code39, code);
}

class Code93Detail extends BarcodeDetail {
  Code93Detail(String code) : super(BarcodeFormat.code93, code);
}

class Ean8Detail extends BarcodeDetail {
  Ean8Detail(String code) : super(BarcodeFormat.ean8, code);
}

class ItfDetail extends BarcodeDetail {
  ItfDetail(String code) : super(BarcodeFormat.itf, code);
}

class MaxicodeDetail extends BarcodeDetail {
  MaxicodeDetail(String code) : super(BarcodeFormat.maxicode, code);
}

class Pdf417Detail extends BarcodeDetail {
  Pdf417Detail(String code) : super(BarcodeFormat.pdf417, code);
}

class Rss14Detail extends BarcodeDetail {
  Rss14Detail(String code) : super(BarcodeFormat.rss14, code);
}

class UPCEDetail extends BarcodeDetail {
  UPCEDetail(String code) : super(BarcodeFormat.upcE, code);
}
