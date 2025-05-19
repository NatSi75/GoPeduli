class GoPeduliValidator {
  // Empty Text Validation
  static String? validateEmptyText(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // Username Validation
  static String? validateUsername(String? username) {
    if (username == null || username.isEmpty) {
      return 'Username is required';
    }

    // Define a regular expression pattern for the username
    const pattern = r"^[a-zA-Z0-9_-]{3,20}$";

    // Create a RegExp instance from the pattern
    final regex = RegExp(pattern);

    // Use the hasMatch method to check if the username matches the pattern
    bool isValid = regex.hasMatch(username);

    // Check if the username doesn't start or end with an underscore or hyphen
    if (isValid) {
      isValid = !username.startsWith('_') &&
          !username.endsWith('_') &&
          !username.startsWith('-') &&
          !username.endsWith('-');
    }

    if (!isValid) {
      return 'Username is not valid.';
    }

    return null;
  }

  // Email Validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    // Define a regular expression pattern for the email
    const pattern = r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";

    // Create a RegExp instance from the pattern
    final regex = RegExp(pattern);

    // Use the hasMatch method to check if the email matches the pattern
    if (!regex.hasMatch(value)) {
      return 'Email is not valid.';
    }

    return null;
  }

  // Phone Number Validation
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Define a regular expression pattern for the phone number
    const pattern = r"^\+?[0-9]{11,12}$";

    // Create a RegExp instance from the pattern
    final regex = RegExp(pattern);

    // Use the hasMatch method to check if the phone number matches the pattern
    if (!regex.hasMatch(value)) {
      return 'Phone number is not valid.';
    }

    return null;
  }

  // Password Validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    // Define a regular expression pattern for the password
    const pattern = r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$";

    // Create a RegExp instance from the pattern
    final regex = RegExp(pattern);

    // Use the hasMatch method to check if the password matches the pattern
    if (!regex.hasMatch(value)) {
      return 'Password must be at least 8 characters long, contain at least one uppercase letter, one lowercase letter, and one number.';
    }

    return null;
  }
}
