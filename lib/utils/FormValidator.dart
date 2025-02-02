class FormValidator {

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a name';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name should contain only letters';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (!RegExp(r'^(?=.*[0-9]).{6,}$').hasMatch(value)) {
      return 'Password must contain at least one number and be at least 6 characters long';
    }
    return null;
  }

  static String? validateNic(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter NIC';
    }
    if (value.length != 14) {
      return 'NIC should be exactly 14 characters';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Phone number should contain only digits';
    }
    return null;
  }

  static String? validateTestNo(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a value';
    }
    final numValue = int.tryParse(value);
    if (numValue == null) {
      return "The test number must be a valid numeric value.";
    }
    return null;
  }

}