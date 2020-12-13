import 'package:barcode_info/barcode_info.dart';

class ScanController {
  /// 국가코드 국가명으로 변경
  static Future<List<CountryInfo>> fetchCountryInfos(
      Set<String> countryCodes) async {
    final infos = List<CountryInfo>();
    for (var code in countryCodes) {
      infos.add(await CountryInfo.create(code));
    }

    return infos;
  }
}
