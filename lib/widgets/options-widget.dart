import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/cool_icons_icons.dart';
import '../config/dimensions.dart';
import '../config/styles.dart';

class OptionTile extends StatelessWidget {
  final String title;
  final Function()? onPressed;
  final Image image;
  const OptionTile({
    Key? key,
    required this.title,
    this.onPressed,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed!();
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical:
              screenSize.width < tabletBreakPoint ? 5 : screenSize.width * 0.01,
        ),
        padding: EdgeInsets.only(
          left: screenSize.width < tabletBreakPoint
              ? 14
              : screenSize.width * 0.022,
          right: screenSize.width < tabletBreakPoint
              ? 14
              : screenSize.width * 0.03,
        ),
        width: double.infinity,
        height:
            screenSize.width < tabletBreakPoint ? 60 : screenSize.width * 0.12,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: kPrimaryColor.withOpacity(.1),
              offset: Offset(0, 5),
              spreadRadius: 0,
              blurRadius: 20,
            ),
          ],
          borderRadius: BorderRadius.circular(
              screenSize.width < tabletBreakPoint ? 10 : 16),
          color: kGeneralWhite,
        ),
        child: Row(
          children: [
            Container(
              height: screenSize.width < tabletBreakPoint
                  ? 40
                  : screenSize.width * 0.08,
              width: screenSize.width < tabletBreakPoint
                  ? 40
                  : screenSize.width * 0.08,
              child: image,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    screenSize.width < tabletBreakPoint
                        ? 10
                        : screenSize.width * 0.015),
              ),
            ),
            SizedBox(
              width: screenSize.width < tabletBreakPoint
                  ? 20
                  : screenSize.width * 0.03,
            ),
            Expanded(
              child: Text(
                title.toString(),
                style: GoogleFonts.poppins(
                    fontSize: screenSize.width < tabletBreakPoint ? 16 : 26,
                    fontWeight: FontWeight.w500,
                    color: kPrimaryColor),
              ),
            ),
            SizedBox(
              width: screenSize.width < tabletBreakPoint ? 16 : 30,
            ),
            Icon(
              CoolIcons.chevron_big_right,
              color: kInactive,
            ),
          ],
        ),
      ),
    );
  }
}

class OptionTile2 extends StatelessWidget {
  final String title;
  final Function()? onPressed;
  final Image image;
  const OptionTile2({
    Key? key,
    required this.title,
    this.onPressed,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed!();
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical:
              screenSize.width < tabletBreakPoint ? 5 : screenSize.width * 0.01,
        ),
        padding: EdgeInsets.only(
          left: screenSize.width < tabletBreakPoint
              ? 14
              : screenSize.width * 0.022,
          right: screenSize.width < tabletBreakPoint
              ? 14
              : screenSize.width * 0.03,
        ),
        width: double.infinity,
        height:
            screenSize.width < tabletBreakPoint ? 60 : screenSize.width * 0.12,
        decoration: BoxDecoration(
          color: kDXLight,
          borderRadius: BorderRadius.circular(
              screenSize.width < tabletBreakPoint ? 10 : 16),
        ),
        child: Row(
          children: [
            Container(
              height: screenSize.width < tabletBreakPoint
                  ? 40
                  : screenSize.width * 0.08,
              width: screenSize.width < tabletBreakPoint
                  ? 40
                  : screenSize.width * 0.08,
              child: image,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    screenSize.width < tabletBreakPoint
                        ? 10
                        : screenSize.width * 0.015),
              ),
            ),
            SizedBox(
              width: screenSize.width < tabletBreakPoint
                  ? 20
                  : screenSize.width * 0.03,
            ),
            Expanded(
              child: Text(
                title.toString(),
                style: GoogleFonts.poppins(
                    fontSize: screenSize.width < tabletBreakPoint ? 16 : 26,
                    fontWeight: FontWeight.w500,
                    color: kPrimaryColor),
              ),
            ),
            SizedBox(
              width: screenSize.width < tabletBreakPoint ? 16 : 30,
            ),
            Icon(
              CoolIcons.chevron_big_right,
              color: kInactive,
            ),
          ],
        ),
      ),
    );
  }
}

class VeridoOptionTile2 extends StatelessWidget {
  final String title;
  final void Function()? onPressed;
  final IconData iconData;
  const VeridoOptionTile2({
    Key? key,
    required this.title,
    this.onPressed,
    required this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.only(left: 18, right: 16),
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: kGreenLight),
        child: Row(
          children: [
            Icon(
              iconData,
              color: kPrimaryColor,
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Text(
                "$title",
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: kTextSecondary),
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Icon(
              CoolIcons.chevron_big_right,
              color: kInactive,
            ),
          ],
        ),
      ),
    );
  }
}
