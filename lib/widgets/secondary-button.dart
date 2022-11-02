import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/dimensions.dart';
import '../config/styles.dart';

class SecondaryTextButton extends StatefulWidget {
  const SecondaryTextButton(
      {Key? key,
      required this.onPressed,
      required this.title,
      this.isActive = true})
      : super(key: key);
  final void Function()? onPressed;
  final String title;
  final bool isActive;

  @override
  _SecondaryTextButtonState createState() => _SecondaryTextButtonState();
}

class _SecondaryTextButtonState extends State<SecondaryTextButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.isActive ? kPrimaryColor.withOpacity(0.1) : kFormBG,
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.symmetric(
            horizontal: screenSize.width < tabletBreakPoint ? 17 : 24,
            vertical: screenSize.width < tabletBreakPoint ? 17 : 24),
        child: Text(
          widget.title,
          style: GoogleFonts.roboto(
              color: widget.isActive ? kPrimaryColor : kTextGray,
              fontWeight: FontWeight.w600,
              fontSize: screenSize.width < tabletBreakPoint ? 16 : 20),
        ),
      ),
    );
  }
}

class SecondaryIconButton extends StatefulWidget {
  const SecondaryIconButton(
      {Key? key, required this.onPressed, required this.title, this.isActive})
      : super(key: key);
  final void Function()? onPressed;
  final Widget title;
  final bool? isActive;

  @override
  _SecondaryIconButtonState createState() => _SecondaryIconButtonState();
}

class _SecondaryIconButtonState extends State<SecondaryIconButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFCCE9FF),
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.symmetric(
            horizontal: screenSize.width < tabletBreakPoint ? 15 : 24,
            vertical: screenSize.width < tabletBreakPoint ? 15 : 24),
        child: widget.title,
      ),
    );
  }
}

class OutlineTextButton extends StatefulWidget {
  const OutlineTextButton(
      {Key? key,
      required this.onPressed,
      required this.title,
      this.isActive = true})
      : super(key: key);
  final void Function()? onPressed;
  final String title;
  final bool isActive;

  @override
  _OutlineTextButtonState createState() => _OutlineTextButtonState();
}

class _OutlineTextButtonState extends State<OutlineTextButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: kGeneralWhite,
          border: Border.all(
              color: kPrimaryColor, width: 1.5, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.symmetric(
            horizontal: screenSize.width < tabletBreakPoint ? 17 : 24,
            vertical: screenSize.width < tabletBreakPoint ? 17 : 24),
        child: Text(
          widget.title,
          style: GoogleFonts.roboto(
              color: widget.isActive ? kPrimaryColor : kInactive,
              fontWeight: FontWeight.w600,
              fontSize: screenSize.width < tabletBreakPoint ? 16 : 20),
        ),
      ),
    );
  }
}
