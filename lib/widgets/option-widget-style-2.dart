import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/cool_icons_icons.dart';
import '../config/styles.dart';

class IconOptionTile extends StatelessWidget {
  final String title;
  final void Function()? onPressed;
  final IconData iconData;
  const IconOptionTile({
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
            borderRadius: BorderRadius.circular(10), color: kPrimaryLight),
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

class AppOptionTile extends StatelessWidget {
  final String title;
  final Function()? onPressed;
  final IconData iconData;
  const AppOptionTile({
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
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.only(left: 18, right: 16),
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withOpacity(.1),
            offset: Offset(0, 5),
            spreadRadius: 0,
            blurRadius: 20,
          ),
        ], borderRadius: BorderRadius.circular(10), color: kGeneralWhite),
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
                  color: kTextPrimary,
                ),
              ),
            ),
            SizedBox(
              width: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class SvgAppOptionTile extends StatelessWidget {
  final String title;
  final double radius;
  final Function()? onPressed;
  final Widget svgIcon;
  const SvgAppOptionTile({
    Key? key,
    required this.title,
    this.onPressed,
    this.radius = 8,
    required this.svgIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.only(left: 10, right: 16),
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
            border: Border.all(
                color: Color(0xFFE8EBF3), width: 1, style: BorderStyle.solid),
            boxShadow: [],
            borderRadius: BorderRadius.circular(radius),
            color: kGeneralWhite),
        child: Row(
          children: [
            svgIcon,
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Text(
                "$title",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: kTextPrimary,
                ),
              ),
            ),
            SizedBox(
              width: 16,
            ),
          ],
        ),
      ),
    );
  }
}
