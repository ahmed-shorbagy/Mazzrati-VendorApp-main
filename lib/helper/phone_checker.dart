class PhoneNumberChecker {
  static bool isNotValid(String phoneNumber) {
    // This regex is for validating international phone numbers. Adjust as needed.
    return !RegExp(r"^\+?[1-9]\d{1,14}$").hasMatch(phoneNumber);
  }
}
