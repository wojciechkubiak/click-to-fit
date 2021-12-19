class Validator {
  String? nameValidation(String? name) {
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
  }

  String? ageValidation(String? age) {
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
  }

  String? heightValidation(String? height) {
    if (height != null) {
      if (height.isEmpty) {
        return "Enter your height";
      }
      if (int.parse(height) < 81 || int.parse(height) > 240) {
        return "Enter proper height";
      }

      return null;
    }
    return "Enter your height";
  }

  String? weightValidation(String? weight) {
    if (weight != null) {
      if (weight.isEmpty) {
        return "Enter your weight";
      }
      if (int.parse(weight) < 31 || int.parse(weight) > 400) {
        return "Enter proper weight";
      }

      return null;
    }

    return "Enter your weight";
  }
}
