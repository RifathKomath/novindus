class AppValidators {
  static String? required(String? value, {String message = "Field is required"}) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  static String? requiredObject<T>(
  T? value, {
  String message = "Field is required",
}) {
  if (value == null) {
    return message;
  }
  return null;
}

}
