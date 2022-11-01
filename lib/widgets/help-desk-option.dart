import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/dimensions.dart';
import '../config/styles.dart';

class HelpDeskOption extends StatelessWidget {
  final Image image;
  final String title;
  final String value;
  final void Function()? onPressed;
  final Color imageBG;

  const HelpDeskOption({
    Key? key,
    required this.image,
    required this.title,
    required this.value,
    required this.onPressed,
    required this.imageBG,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
                screenSize.width < tabletBreakPoint
                    ? 20
                    : screenSize.width * 0.04),
            color: kGeneralWhite,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF606470).withOpacity(.1),
                offset: const Offset(0, 5),
                spreadRadius: 0,
                blurRadius: 20,
              )
            ]),
        width: double.infinity,
        padding: EdgeInsets.all(
            screenSize.width < tabletBreakPoint ? 10 : screenSize.width * 0.02),
        margin: EdgeInsets.symmetric(
            vertical: screenSize.width < tabletBreakPoint
                ? 10
                : screenSize.width * 0.02),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(
                screenSize.width < tabletBreakPoint
                    ? 10
                    : screenSize.width * 0.02,
              ),
              height: screenSize.width < tabletBreakPoint
                  ? 60
                  : screenSize.width * 0.12,
              width: screenSize.width < tabletBreakPoint
                  ? 60
                  : screenSize.width * 0.12,
              child: image,
              decoration: BoxDecoration(
                color: imageBG,
                borderRadius: BorderRadius.circular(
                    screenSize.width < tabletBreakPoint
                        ? 10
                        : screenSize.width * 0.02),
              ),
            ),
            SizedBox(
              width: screenSize.width < tabletBreakPoint
                  ? 10
                  : screenSize.width * 0.02,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.toString(),
                    style: GoogleFonts.poppins(
                      color: kTextGray,
                      fontSize: screenSize.width < tabletBreakPoint ? 14 : 20,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    height: screenSize.width < tabletBreakPoint
                        ? 5
                        : screenSize.width * 0.01,
                  ),
                  Text(
                    value.toString(),
                    style: trxTitleTextStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
