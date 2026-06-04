class Validators {
  Validators._();

  static String? notEmpty(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field cannot be empty';
    }
    return null;
  }

  static String? minLength(String? value, int min) {
    if (value == null || value.length < min) {
      return 'Minimum $min characters required';
    }
    return null;
  }
}
