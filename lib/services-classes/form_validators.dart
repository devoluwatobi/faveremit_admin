import 'functions.dart';

bool isNumeric(String s) {
  return double.tryParse(s) != null;
}

String? fullNameValidator(value) {
  if (value == null || value.isEmpty) {
    return 'full name cannot be empty';
  }
  if (value.trim().length < 3) {
    return 'please type in your full name';
  } else if (!value.trim().toString().contains(" ")) {
    return 'first name and last names are required';
  } else {
    return null;
  }
}

String? singleNameValidator(value) {
  if (value == null || value.isEmpty) {
    return 'name cannot be empty';
  }
  if (value.trim().length < 3) {
    return 'name is invalid';
  } else if (value.trim().toString().contains(" ")) {
    return 'please enter a valid single name';
  } else {
    return null;
  }
}

String? textValidator(value) {
  if (value == null || value.isEmpty) {
    return 'this field cannot be empty';
  }
  if (value.trim().length < 3) {
    return 'this field is required';
  } else {
    return null;
  }
}

String? optionalTextValidator(value) {
  if (value == null || value.isEmpty) {
    return null;
  }
  if (value.trim().length < 3) {
    return 'this field is required';
  } else {
    return null;
  }
}

String? emailValidator(value) {
  if (value == null || value.isEmpty) {
    return 'email address is required';
  }
  if (!RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(value)) {
    return 'email address is not valid';
  } else {
    return null;
  }
}

String? usernameValidator(username) {
  if (username == null || username.isEmpty) {
    return 'username is required';
  }
  if (username.toString().trim().length < 3) {
    return 'min length for username is 3';
  }
  if (!(RegExp(r"^[a-z._]+$", caseSensitive: false).hasMatch(username) &&
      !username.startsWith(".") &&
      !username.startsWith("_") &&
      !username.endsWith(".") &&
      !username.endsWith("_") &&
      !username.contains(" ") &&
      !username.contains("..") &&
      !username.contains("__") &&
      !username.contains("._") &&
      !username.contains("_."))) {
    return 'username address is not valid';
  } else {
    return null;
  }
}

String? optionalUsernameValidator(username) {
  if (username == null || username.isEmpty) {
    return null;
  }
  if (username.toString().trim().length < 3) {
    return 'min length for username is 3';
  }

  if (!(RegExp(r"^[a-z._]+$", caseSensitive: false).hasMatch(username) &&
      !username.startsWith(".") &&
      !username.startsWith("_") &&
      !username.endsWith(".") &&
      !username.endsWith("_") &&
      !username.contains(" ") &&
      !username.contains("..") &&
      !username.contains("__") &&
      !username.contains("._") &&
      !username.contains("_."))) {
    return 'username address is not valid';
  } else {
    return null;
  }
}

String? optionalEmailValidator(value) {
  if (value == null || value.isEmpty) {
    return null;
  }
  if (!RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(value)) {
    return 'email address is not valid';
  } else {
    return null;
  }
}

String? passwordValidator(value) {
  if (value == null || value.isEmpty) {
    return 'your password is required';
  }
  if (value.trim().length < 8) {
    return 'your password must contain at least 8 characters';
  } else {
    return null;
  }
}

String? passwordValidator2(value) {
  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  RegExp regExp = new RegExp(pattern);
  if (value.trim().length < 8) {
    return 'your password must contain at least 8 characters';
  } else if (RegExp(
          "^(?=.{8,32}\$)(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#\$%^&*(),.?:{}|<>-]).*")
      .hasMatch(value.toString().trim())) {
    return null;
  } else {
    return "Password should contain uppercase, lowercase, digit and special character";
  }
}

String? numberValidator(value) {
  if (value == null || value.isEmpty) {
    return 'this field is required';
  }
  if (!isNumeric(value)) {
    return 'this field must only contain digits';
  } else {
    return null;
  }
}

String? percentValidator(value) {
  if (value == null || value.isEmpty) {
    return 'this field is required';
  }
  if (!isNumeric(value)) {
    return 'this field must only contain digits';
  }
  if (double.parse(value) > 100 || double.parse(value) < 0) {
    return 'this must be a valid percentage';
  } else {
    return null;
  }
}

String? phoneValidator(value) {
  if (value == null || value.isEmpty) {
    return 'phone number cannot be empty';
  }
  if (!RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(value)) {
    return 'invalid phone number';
  } else {
    return null;
  }
}

String? percentageValidator(value) {
  if (value == null || value.isEmpty) {
    return 'this field is required';
  }
  if (!isNumeric(value)) {
    return 'this field must only contain digits';
  }
  if (double.parse(value) > 100 || double.parse(value) < 0) {
    return 'percentage must be  greater than 0 and less than 100';
  } else {
    return null;
  }
}

digitsValidator(
    {int minLength = 1, int? maxLength, bool canTakeDouble = true}) {
  double max = maxLength == null ? double.infinity : maxLength.toDouble();
  return (value) {
    if (value == null || value.isEmpty) {
      return 'this field is required';
    }
    if (!isNumeric(value)) {
      return 'this field must only contain digits';
    } else if (value.toString().length < minLength) {
      return 'the minimum length for this field is $minLength';
    } else if (maxLength != null && value.toString().length > maxLength) {
      return 'the maximum length for this field is $maxLength';
    } else if (!canTakeDouble && int.tryParse(value.toString()) == null) {
      return 'this field must only contain integers (whole numbers)';
    } else {
      return null;
    }
  };
}

amountValidator(
    {double minimum = 1,
    double maximum = double.infinity,
    bool canTakeDouble = true}) {
  return (value) {
    if (value == null || value.isEmpty) {
      return 'this field is required';
    } else if (!isNumeric(value)) {
      return 'this field must only contain digits';
    } else if (double.parse(value.toString()) < minimum) {
      return 'the minimum valid amount is ${addCommas(minimum.toStringAsFixed(0))}';
    } else if (double.parse(value.toString()) > maximum) {
      return 'the maximum valid amount is ${addCommas(maximum.toStringAsFixed(0))}';
    } else if (!canTakeDouble && int.tryParse(value.toString()) == null) {
      return 'this field must only contain integers (whole numbers)';
    } else {
      return null;
    }
  };
}

digitValidator({int min = 1, required int max}) {
  return (value) {
    if (value == null || value.isEmpty) {
      return 'this field is required';
    }
    if (!isNumeric(value)) {
      return 'this field must only contain digits';
    }
    if (value.toString().length > max || value.toString().length < min) {
      return 'min character is $min and max character is $max';
    } else {
      return null;
    }
  };
}
