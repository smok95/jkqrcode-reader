import 'package:flutter_localized_country_name/flutter_localized_country_name.dart';

import 'country_info.dart';

class UPCADetail {
  UPCADetail(this.countries);

  final List<CountryInfo> countries;

  static Future<UPCADetail> create(String code) async {
    final prefix = code.substring(0, 3);
    final countryCodes = ['US', 'CA'];

    List<CountryInfo> countries;
    if (countryCodes != null) {
      countries = await Future.wait(countryCodes.map((countryCode) async {
        final name = await FlutterLocalizedCountryName.getLocalizedCountryName(
            countryCode: countryCode);
        return CountryInfo(countryCode, name);
      }).toList());
    }

    return UPCADetail(countries);
  }
}
