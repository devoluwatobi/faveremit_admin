import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/dimensions.dart';
import '../config/styles.dart';

class ColorTextButton extends StatefulWidget {
  const ColorTextButton(
      {Key? key,
      required this.onPressed,
      required this.title,
      this.isActive,
      required this.color})
      : super(key: key);
  final void Function()? onPressed;
  final String title;
  final bool? isActive;
  final Color color;

  @override
  _ColorTextButtonState createState() => _ColorTextButtonState();
}

class _ColorTextButtonState extends State<ColorTextButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.symmetric(
            horizontal: screenSize.width < tabletBreakPoint ? 17 : 24,
            vertical: screenSize.width < tabletBreakPoint ? 17 : 24),
        child: Text(
          widget.title,
          style: kPrimaryButtonTextStyle,
        ),
      ),
    );
  }
}

class ColorOutlineTextButton extends StatefulWidget {
  const ColorOutlineTextButton(
      {Key? key,
      required this.onPressed,
      required this.title,
      this.isActive,
      required this.color})
      : super(key: key);
  final void Function()? onPressed;
  final String title;
  final bool? isActive;
  final Color color;

  @override
  _ColorOutlineTextButtonState createState() => _ColorOutlineTextButtonState();
}

class _ColorOutlineTextButtonState extends State<ColorOutlineTextButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
                width: 1, color: widget.color, style: BorderStyle.solid)),
        padding: EdgeInsets.symmetric(
            horizontal: screenSize.width < tabletBreakPoint ? 17 : 24,
            vertical: screenSize.width < tabletBreakPoint ? 17 : 24),
        child: Text(
          widget.title,
          style: GoogleFonts.roboto(
              color: widget.color,
              fontWeight: FontWeight.w600,
              fontSize: screenSize.width < tabletBreakPoint ? 16 : 20),
        ),
      ),
    );
  }
}
