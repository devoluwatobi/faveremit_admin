import 'package:faveremit_admin/config/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';

String addCommas(String number) {
  RegExp _regExp = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  // Function _mathFunc = (Match match) => '${match[1]},';
  String _result =
      number.replaceAllMapped(_regExp, (Match match) => '${match[1]},');
  return _result;
}

String getFirstName({required String fullName}) {
  var names = fullName.replaceAll(RegExp(r"\s+"), " ").trim().split(' ');
  // int namesCount = names.length;
  String firstName = names[0];
  // String lastName = names[namesCount - 1];
  return firstName;
}

String getLastName({required String fullName}) {
  var names = fullName.replaceAll(RegExp(r"\s+"), " ").trim().split(' ');
  int namesCount = names.length;
  // String firstName = names[0];
  String lastName = names[namesCount - 1];
  return lastName;
}

String getFirstNameAndLastInitial({required String fullName}) {
  var names = fullName.replaceAll(RegExp(r"\s+"), " ").trim().split(' ');
  int namesCount = names.length;
  String firstName = names[0];
  String lastName = names[namesCount - 1];
  return "$firstName ${lastName[0]}.".inTitleCase;
}

String getInitials(String string, [int limitTo = 2]) {
  if (string.isEmpty) {
    return '';
  }

  var buffer = StringBuffer();
  var split = string.replaceAll(RegExp(r"\s+"), " ").trim().split(' ');

  //For one word
  if (split.length == 1) {
    return string.substring(0, 1).toUpperCase();
  }

  for (var i = 0; i < (limitTo); i++) {
    buffer.write(split[i][0]);
  }

  return buffer.toString().toUpperCase();
}

extension CapExtension on String {
  String get inCaps => '${this[0].toUpperCase()}${this.substring(1)}';
  String get allInCaps => this.toUpperCase();
  String get inTitleCase => this
      .replaceAll(RegExp(r"\s+"), " ")
      .trim()
      .split(" ")
      .map((str) => str.inCaps)
      .join(" ");
}

extension Ex on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}

final helloWorld = 'hello world'.inCaps; // 'Hello world'
final helloWorld1 = 'hello world'.allInCaps; // 'HELLO WORLD'
final helloWorld2 = 'hello world'.inTitleCase; // 'Hello World'

String getPhoneNumber(String number) {
  String temp;
  if (number.trim().length > 10 && number.startsWith('0')) {
    temp = '+234' + number.trim().substring(1);
    print(temp);
    return temp;
  } else if (number.trim().length > 10 && number.startsWith('+')) {
    temp = number.trim();
    print(temp);
    return temp;
  } else if (number.trim().length > 10 &&
      !number.startsWith('+') &&
      !number.startsWith('0')) {
    temp = '+' + number.trim();
    print(temp);
    return temp;
  } else
    return number.trim();
}

Future<void> copyToClipboard(
    {required String copyText, required BuildContext context}) async {
  await Clipboard.setData(ClipboardData(text: copyText));
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: kGeneralWhite,
    padding: EdgeInsets.symmetric(horizontal: 30),
    elevation: 4,
    content: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: kGeneralWhite,
        boxShadow: const [
          BoxShadow(
            color: Color(0x19000000),
            spreadRadius: 2.0,
            blurRadius: 8.0,
            offset: Offset(2, 4),
          )
        ],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            FlutterRemix.checkbox_circle_fill,
            color: kPrimaryColor,
          ),
          SizedBox(
            width: 16,
          ),
          Text(
            'Copied to clipboard',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                color: kPrimaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 16),
          ),
        ],
      ),
    ),
  ));
}

String getMonth(int monthIndex) {
  switch (monthIndex) {
    case 1:
      return "January";
    case 2:
      return "February";
    case 3:
      return "March";
    case 4:
      return "April";
    case 5:
      return "May";
    case 6:
      return "June";
    case 7:
      return "July";
    case 8:
      return "August";
    case 9:
      return "September";
    case 10:
      return "October";
    case 11:
      return "November";
    case 12:
      return "December";
    default:
      return "${monthIndex}th Month";
  }
}

extension DateTimeExtension on DateTime {
  DateTime next(int day) {
    if (day == this.weekday)
      return this.add(Duration(days: 7));
    else {
      return this.add(
        Duration(
          days: (day - this.weekday) % DateTime.daysPerWeek,
        ),
      );
    }
  }

  DateTime previous(int day) {
    if (day == this.weekday)
      return this.subtract(Duration(days: 7));
    else {
      return this.subtract(
        Duration(
          days: (this.weekday - day) % DateTime.daysPerWeek,
        ),
      );
    }
  }
}

Duration _timeOffset = Duration(hours: 1);

// String getHumanDate(DateTime dateTime) {
//   return "${DateFormat.jm().format(dateTime.add(_timeOffset))}, ${humanDate(dateTime.add(_timeOffset))}";
// }
//
// String humanDate(DateTime tm) {
//   DateTime today = new DateTime.now();
//   Duration oneDay = new Duration(days: 1);
//   Duration twoDay = new Duration(days: 2);
//   Duration oneWeek = new Duration(days: 7);
//   String? month;
//   switch (tm.month) {
//     case 1:
//       month = "january";
//       break;
//     case 2:
//       month = "february";
//       break;
//     case 3:
//       month = "march";
//       break;
//     case 4:
//       month = "april";
//       break;
//     case 5:
//       month = "may";
//       break;
//     case 6:
//       month = "june";
//       break;
//     case 7:
//       month = "july";
//       break;
//     case 8:
//       month = "august";
//       break;
//     case 9:
//       month = "september";
//       break;
//     case 10:
//       month = "october";
//       break;
//     case 11:
//       month = "november";
//       break;
//     case 12:
//       month = "december";
//       break;
//   }
//
//   Duration difference = today.difference(tm);
//
//   if (difference.compareTo(oneDay) < 1) {
//     return "today";
//   } else if (difference.compareTo(twoDay) < 1) {
//     return "yesterday";
//   } else if (difference.compareTo(oneWeek) < 1) {
//     switch (tm.weekday) {
//       case 1:
//         return "monday";
//       case 2:
//         return "tuesday";
//       case 3:
//         return "wednesday";
//       case 4:
//         return "thursday";
//       case 5:
//         return "friday";
//       case 6:
//         return "saturday";
//       case 7:
//         return "sunday";
//       default:
//         return "day";
//     }
//   } else if (tm.year == today.year) {
//     return '${tm.day} $month';
//   } else {
//     return '${tm.day} $month ${tm.year}';
//   }
// }
