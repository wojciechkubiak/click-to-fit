import 'package:flutter/services.dart';

class Validator {
  String? nameValidation(String? name) {
    try {
      if (name != null) {
        if (name.isEmpty) {
          return "Enter your age";
        }

        if (name.length > 20) {
          return "Name too long (max. 20)";
        }

        if (name.length < 2) {
          return "Name too short (min. 2)";
        }
        return null;
      }

      return "Enter your name";
    } catch (e) {
      print(e);
      return "Enter your name";
    }
  }

  String? ageValidation(String? age) {
    try {
      if (age != null) {
        if (age.isEmpty) {
          return "Enter your age";
        }
        if (int.parse(age) < 18) {
          return "You must be at least 18 years old";
        }

        if (int.parse(age) > 120) {
          return "Are you sure you're that old?";
        }

        return null;
      }

      return "Enter your age";
    } catch (e) {
      print(e);
      return "Enter your age";
    }
  }

  String? heightValidation(String? height) {
    try {
      if (height != null) {
        if (height.isEmpty) {
          return "Enter your height";
        }
        if (double.parse(height) < 81 || double.parse(height) > 240) {
          return "Enter proper height";
        }

        return null;
      }
      return "Enter your height";
    } catch (e) {
      print(e);
      return "Enter your height";
    }
  }

  String? weightValidation(String? weight) {
    try {
      if (weight != null) {
        if (weight.isEmpty) {
          return "Enter your weight";
        }
        print('WEIGHT $weight');
        if (double.parse(weight) < 31 || double.parse(weight) > 400) {
          return "Enter proper weight";
        }

        return null;
      }

      return "Enter your weight";
    } catch (e) {
      print(e);
      return "Enter your weight";
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
      // else {
      // return const TextEditingValue(text: '0');
      // }
    } catch (e) {
      print(e);
      return oldValue;
    }
  });
}
