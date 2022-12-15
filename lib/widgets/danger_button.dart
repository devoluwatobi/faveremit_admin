import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/dimensions.dart';
import '../config/styles.dart';

class DangerTextButton extends StatefulWidget {
  const DangerTextButton(
      {Key? key,
      required this.onPressed,
      required this.title,
      this.isActive = true})
      : super(key: key);
  final void Function()? onPressed;
  final String title;
  final bool isActive;

  @override
  _DangerTextButtonState createState() => _DangerTextButtonState();
}

class _DangerTextButtonState extends State<DangerTextButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: kRed.withOpacity(0.1),
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.symmetric(
            horizontal: screenSize.width < tabletBreakPoint ? 17 : 24,
            vertical: screenSize.width < tabletBreakPoint ? 17 : 24),
        child: Text(
          widget.title,
          style: GoogleFonts.spaceGrotesk(
              color: kRed,
              fontWeight: FontWeight.w600,
              fontSize: screenSize.width < tabletBreakPoint ? 16 : 20),
        ),
      ),
    );
  }
}
