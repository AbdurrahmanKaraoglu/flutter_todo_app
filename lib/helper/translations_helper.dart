// ignore_for_file: implementation_imports

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class TranslationsHelper {
  TranslationsHelper._();

  static getDeviceLanguage(BuildContext context) {
    var deviceLanguage = context.deviceLocale.countryCode!.toLowerCase();
    debugPrint(deviceLanguage.toString());

    switch (deviceLanguage) {
      case 'tr':
        return LocaleType.tr;
      case 'en':
        return LocaleType.en;
    }
  }
}
