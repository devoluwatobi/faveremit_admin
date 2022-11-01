import 'package:faveremit_admin/services-classes/app-worker.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

Future showInfoModal(
    {required BuildContext context,
    required String title,
    required String content}) async {
  showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoAlertDialog(
            title: Text(
              title,
              style: GoogleFonts.poppins(),
            ),
            content: Text(content),
          ));
}

Future showErrorResponse(
    {required BuildContext context, required ProcessError error}) async {
  showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoAlertDialog(
            title: Text(
              error.network ? "Oops!" : "Failed",
              style: GoogleFonts.poppins(),
            ),
            content: Text(error.network
                ? "Faveremit could not connect to the internet. Please check your connection and try again."
                : "Faveremit  could not complete that request successfully. Please try again"),
          ));
}
