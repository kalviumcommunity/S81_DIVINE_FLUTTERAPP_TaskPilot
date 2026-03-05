///
/// Input validation utilities for secure data entry
///
class InputValidator {
  /// Validate email format
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Validate phone number (basic)
  static bool isValidPhone(String phone) {
    // Remove all non-digit characters
    final digitsOnly = phone.replaceAll(RegExp(r'\D'), '');
    // Check if has at least 10 digits
    return digitsOnly.length >= 10;
  }

  /// Check if string is not empty after trimming
  static bool isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  /// Check if string has minimum length
  static bool hasMinLength(String? value, int minLength) {
    return value != null && value.trim().length >= minLength;
  }

  /// Check if string has maximum length
  static bool hasMaxLength(String? value, int maxLength) {
    return value != null && value.trim().length <= maxLength;
  }

  /// Validate task title (not empty, 5-200 chars)
  static String? validateTaskTitle(String? value) {
    if (!isNotEmpty(value)) {
      return 'Please enter a task title';
    }
    if (!hasMinLength(value, 5)) {
      return 'Title must be at least 5 characters';
    }
    if (!hasMaxLength(value, 200)) {
      return 'Title must not exceed 200 characters';
    }
    return null;
  }

  /// Validate task description (optional, max 2000 chars)
  static String? validateTaskDescription(String? value) {
    if (value != null && !hasMaxLength(value, 2000)) {
      return 'Description must not exceed 2000 characters';
    }
    return null;
  }

  /// Validate project name (not empty, 3-100 chars)
  static String? validateProjectName(String? value) {
    if (!isNotEmpty(value)) {
      return 'Please enter a project name';
    }
    if (!hasMinLength(value, 3)) {
      return 'Project name must be at least 3 characters';
    }
    if (!hasMaxLength(value, 100)) {
      return 'Project name must not exceed 100 characters';
    }
    return null;
  }

  /// Validate client name (not empty, 3-100 chars)
  static String? validateClientName(String? value) {
    if (!isNotEmpty(value)) {
      return 'Please enter a client name';
    }
    if (!hasMinLength(value, 3)) {
      return 'Client name must be at least 3 characters';
    }
    if (!hasMaxLength(value, 100)) {
      return 'Client name must not exceed 100 characters';
    }
    return null;
  }

  /// Validate email field (can be empty, but if provided must be valid)
  static String? validateEmail(String? value) {
    if (isNotEmpty(value) && !isValidEmail(value!)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validate phone field (can be empty, but if provided must be valid)
  static String? validatePhone(String? value) {
    if (isNotEmpty(value) && !isValidPhone(value!)) {
      return 'Please enter a valid phone number (minimum 10 digits)';
    }
    return null;
  }

  /// Validate budget (positive number)
  static String? validateBudget(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    final parsed = double.tryParse(value);
    if (parsed == null) {
      return 'Please enter a valid number';
    }
    if (parsed < 0) {
      return 'Budget must be a positive number';
    }
    return null;
  }

  /// Validate estimated hours (positive integer)
  static String? validateHours(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    final parsed = int.tryParse(value);
    if (parsed == null) {
      return 'Please enter a valid number';
    }
    if (parsed < 0) {
      return 'Hours must be a positive number';
    }
    return null;
  }
}
