import 'package:flutter/cupertino.dart';
import 'package:flutter_translate/flutter_translate.dart';

class LocalizationCode {
  BuildContext context;

  LocalizationCode({required this.context});

  static const Map<String, String> value = {
    "pl": "pl_PL",
    "en": "en_GB",
  };

  String? getLocale() {
    LocalizationDelegate delegate = LocalizedApp.of(context).delegate;
    String code = delegate.currentLocale.languageCode;
    return value[code];
  }
}
