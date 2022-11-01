extension ConvertToLocal on DateTime {
  String toTimeString() =>
      "${toLocal().hour % 12 == 0 ? "12" : toLocal().hour % 12}:${toLocal().minute >= 10 ? "" : "0"}${toLocal().minute} ${toLocal().hour >= 12 ? "PM" : "AM"}";

  String toDateString() {
    DateTime today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    Duration oneDay = const Duration(days: 1);
    Duration twoDay = const Duration(days: 2);
    Duration oneWeek = const Duration(days: 7);
    String? month;
    switch (this.month) {
      case 1:
        month = "January";
        break;
      case 2:
        month = "February";
        break;
      case 3:
        month = "March";
        break;
      case 4:
        month = "April";
        break;
      case 5:
        month = "May";
        break;
      case 6:
        month = "June";
        break;
      case 7:
        month = "July";
        break;
      case 8:
        month = "August";
        break;
      case 9:
        month = "September";
        break;
      case 10:
        month = "October";
        break;
      case 11:
        month = "November";
        break;
      case 12:
        month = "December";
        break;
    }

    Duration difference = today.difference(DateTime(year, this.month, day));

    if (today.year == year && today.month == this.month && today.day == day) {
      return "Today";
    } else if (today.difference(DateTime(year, this.month, day)) ==
        const Duration(days: 1)) {
      return "Yesterday";
    } else if (difference.compareTo(oneWeek) < 1) {
      switch (weekday) {
        case 1:
          return "Monday";
        case 2:
          return "Tuesday";
        case 3:
          return "Wednesday";
        case 4:
          return "Thursday";
        case 5:
          return "Friday";
        case 6:
          return "Saturday";
        case 7:
          return "Sunday";
        default:
          return "Day";
      }
    } else if (year == today.year) {
      return '$day $month';
    } else {
      return '$day $month $year';
    }
  }

  String toDateTimeString() {
    return "${toLocal().toTimeString()} | ${toLocal().toDateString()}";
  }
}
