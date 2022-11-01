import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/styles.dart';

Future<dynamic> showOptionPopup({
  required BuildContext context,
  required String title,
  required String body,
  required String actionTitle,
  required bool isDestructive,
}) {
  return showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            title,
            style: GoogleFonts.poppins(),
          ),
          content: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              body,
              style: GoogleFonts.poppins(),
            ),
          ),
          actions: [
            CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                isDestructiveAction: isDestructive,
                child: Text(
                  actionTitle,
                  style: isDestructive
                      ? GoogleFonts.poppins()
                      : GoogleFonts.poppins(color: kPrimaryColor),
                )),
            CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                isDefaultAction: isDestructive,
                child: Text(
                  "cancel",
                  style: isDestructive
                      ? GoogleFonts.poppins(color: kPrimaryColor)
                      : GoogleFonts.poppins(color: kTextGray),
                )),
          ],
        );
      });
}

Future<dynamic> showOptionPopup2({
  required BuildContext context,
  required String title,
  required String body,
  required String actionTitle,
  required bool isDestructive,
}) {
  return showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            title,
            style: GoogleFonts.poppins(),
          ),
          content: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              body,
              style: GoogleFonts.poppins(),
            ),
          ),
          actions: [
            CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                isDestructiveAction: isDestructive,
                child: Text(
                  actionTitle,
                  style: isDestructive
                      ? GoogleFonts.poppins()
                      : GoogleFonts.poppins(color: kPrimaryColor),
                )),
            CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                isDefaultAction: isDestructive,
                child: Text(
                  "No, Go back",
                  style: isDestructive
                      ? GoogleFonts.poppins(color: kPrimaryColor)
                      : GoogleFonts.poppins(color: kTextGray),
                )),
          ],
        );
      });
}

Future<dynamic> showSingleOptionPopup({
  required BuildContext context,
  required String title,
  required String body,
  required String actionTitle,
  required bool isDestructive,
  required Function() onPressed,
}) {
  return showCupertinoModalPopup(
      // barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            title,
            style: GoogleFonts.poppins(),
          ),
          content: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              body,
              style: GoogleFonts.poppins(),
            ),
          ),
          actions: [
            CupertinoActionSheetAction(
                onPressed: onPressed,
                isDestructiveAction: isDestructive,
                child: Text(
                  actionTitle,
                  style: isDestructive
                      ? GoogleFonts.poppins()
                      : GoogleFonts.poppins(color: kPrimaryColor),
                )),
          ],
        );
      });
}
