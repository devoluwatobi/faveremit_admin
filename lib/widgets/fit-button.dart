import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/dimensions.dart';
import '../config/styles.dart';

class AppFitButton extends StatefulWidget {
  const AppFitButton(
      {Key? key, required this.onPressed, required this.title, this.isActive})
      : super(key: key);
  final void Function()? onPressed;
  final Widget title;
  final bool? isActive;

  @override
  _VeridoPrimaryButtonState createState() => _VeridoPrimaryButtonState();
}

class _VeridoPrimaryButtonState extends State<AppFitButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(
            horizontal: screenSize.width < tabletBreakPoint ? 20 : 30,
            vertical: screenSize.width < tabletBreakPoint ? 16 : 24),
        child: widget.title,
      ),
    );
  }
}

class VeridoSecondaryFitTextButton extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  final bool? isActive;

  const VeridoSecondaryFitTextButton(
      {Key? key, required this.onPressed, required this.title, this.isActive})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: kGreenLight,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(
            horizontal: screenSize.width < tabletBreakPoint ? 20 : 30,
            vertical: screenSize.width < tabletBreakPoint ? 16 : 24),
        child: Text(
          "$title",
          style: GoogleFonts.poppins(
              color: kPrimaryColor,
              fontWeight: FontWeight.w600,
              fontSize: screenSize.width < tabletBreakPoint ? 16 : 20),
        ),
      ),
    );
  }
}
