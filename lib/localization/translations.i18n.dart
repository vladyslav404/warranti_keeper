import 'package:i18n_extension/i18n_extension.dart';
import 'package:keep_it_g/localization/translations/en.dart';
import 'package:keep_it_g/localization/translations/tr.dart';

extension Localization on String {
  static final _t = Translations.byLocale("en_us") +
      {
        "en": en,
        "tr": tr,
      };

  String get i18n => localize(this, _t);

  String fill(List<Object> params) => localizeFill(this, params);

  String plural(value) => localizePlural(value, this, _t);
}
