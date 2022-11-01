import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

Future<dynamic> showLoadingModal(
    {required BuildContext context, String title = "Loading"}) {
  return showCupertinoModalPopup(
    barrierDismissible: false,
    semanticsDismissible: true,
    context: context,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: CupertinoAlertDialog(
          title: Text(
            "$title...",
            style: GoogleFonts.poppins(),
          ),
          content: Container(
            child: CupertinoActivityIndicator(
              radius: 14,
            ),
            padding: EdgeInsets.all(20),
          ),
        ),
      );

      // Navigator.pushNamed(context, "home");
    },
  );
}
