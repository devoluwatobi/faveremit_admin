import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/dimensions.dart';
import '../config/styles.dart';
import '../services-classes/functions.dart';

enum AppInputType {
  text,
  email,
  password,
  phone,
  emailXPhone,
  number,
  textarea
}

bool isNumeric(String s) {
  return double.tryParse(s) != null;
}

TextInputType getKeyboardType({
  required AppInputType inputType,
}) {
  switch (inputType) {
    case AppInputType.emailXPhone:
      return TextInputType.streetAddress;

    case AppInputType.phone:
      return TextInputType.phone;

    case AppInputType.email:
      return TextInputType.emailAddress;

    case AppInputType.text:
      return TextInputType.text;

    case AppInputType.number:
      return TextInputType.numberWithOptions();

    case AppInputType.password:
      return TextInputType.visiblePassword;

    case AppInputType.textarea:
      return TextInputType.multiline;

    default:
      return TextInputType.text;
  }
}

InputDecoration appInputDecoration(
    {required AppInputType inputType, String? hint}) {
  return InputDecoration(
    hintMaxLines: inputType == AppInputType.textarea ? 6 : 1,
    // suffix: inputType == VeridoInputType.phone
    //     ? SvgPicture.asset(
    //         "assets/svg/ngn-flag.svg",
    //         height: screenSize.width < tabletBreakPoint ? 16 : 24,
    //       )
    //     : null,
    fillColor: kFormBG,
    filled: true,
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: kRed, width: 1, style: BorderStyle.solid),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: kRed, width: 1, style: BorderStyle.solid),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
    contentPadding: EdgeInsets.symmetric(
        horizontal: screenSize.width < tabletBreakPoint ? 16 : 24,
        vertical: screenSize.width < tabletBreakPoint ? 16 : 24),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
    hintText: hint,
    hintStyle: GoogleFonts.poppins(
      fontSize: screenSize.width < tabletBreakPoint ? 16 : 18,
      fontWeight: FontWeight.w500,
      color: kInactive,
    ),
  );
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

String? urlValidator(value) {
  var urlPattern =
      r"(https?|http)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
  var match = new RegExp(urlPattern, caseSensitive: false)
      .firstMatch('https://www.google.com');
  if (RegExp(urlPattern, caseSensitive: false).hasMatch(value)) {
    return null;
  } else {
    return 'please provide a valid url';
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

amountValidator({double minimum = 1, double maximum = double.infinity}) {
  return (value) {
    if (value == null || value.isEmpty) {
      return 'this field is required';
    } else if (!isNumeric(value)) {
      return 'this field must only contain digits';
    } else if (double.parse(value.toString()) < minimum) {
      return 'the minimum valid amount is ${addCommas(minimum.toStringAsFixed(0))}';
    } else if (double.parse(value.toString()) > maximum) {
      return 'the maximum valid amount is ${addCommas(maximum.toStringAsFixed(0))}';
    } else {
      return null;
    }
  };
}
