import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:star_metter/lang/keys.dart';

class Validator {
  String? nameValidation(String? name) {
    try {
      if (name != null) {
        if (name.isEmpty) {
          return translate(Keys.validatorsName);
        }

        if (name.length > 20) {
          return translate(Keys.validatorsNameTooLong);
        }

        if (name.length < 2) {
          return translate(Keys.validatorsNameTooShort);
        }
        return null;
      }

      return translate(Keys.validatorsName);
    } catch (e) {
      print(e);
      return translate(Keys.validatorsName);
    }
  }

  String? ageValidation(String? age) {
    try {
      if (age != null) {
        if (age.isEmpty) {
          return translate(Keys.validatorsAge);
        }
        if (int.parse(age) < 18) {
          return translate(Keys.validatorsAgeTooYoung);
        }

        if (int.parse(age) > 120) {
          return translate(Keys.validatorsAgeTooOld);
        }

        return null;
      }

      return translate(Keys.validatorsAge);
    } catch (e) {
      print(e);
      return translate(Keys.validatorsAge);
    }
  }

  String? heightValidation(String? height) {
    try {
      if (height != null) {
        if (height.isEmpty) {
          return translate(Keys.validatorsHeight);
        }
        if (double.parse(height) < 81 || double.parse(height) > 240) {
          return translate(Keys.validatorsHeightProper);
        }

        return null;
      }
      return translate(Keys.validatorsHeight);
    } catch (e) {
      print(e);
      return translate(Keys.validatorsHeight);
    }
  }

  String? weightValidation(String? weight) {
    try {
      if (weight != null) {
        if (weight.isEmpty) {
          return translate(Keys.validatorsWeight);
        }

        if (double.parse(weight) < 31 || double.parse(weight) > 400) {
          return translate(Keys.validatorsWeightProper);
        }

        return null;
      }

      return translate(Keys.validatorsWeight);
    } catch (e) {
      print(e);
      return translate(Keys.validatorsWeight);
    }
  }

  TextInputFormatter digitFormatter =
      TextInputFormatter.withFunction((oldValue, newValue) {
    try {
      final text = newValue.text;

      if (text.isNotEmpty) {
        double parsed = double.parse(text);
        if (parsed > 999 || parsed < 0) {
          return oldValue;
        }
        List<String> splitted = text.split('.');
        if (splitted.length > 1) {
          String digits = splitted.last;

          if (digits.length > 1) {
            return oldValue;
          }

          return newValue;
        }
        return newValue;
      }

      return newValue;
    } catch (e) {
      print(e);
      return oldValue;
    }
  });
}
