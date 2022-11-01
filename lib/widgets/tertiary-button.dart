import 'package:flutter/cupertino.dart';

import '../config/dimensions.dart';
import '../config/styles.dart';

class TertiaryTextButton extends StatefulWidget {
  const TertiaryTextButton(
      {Key? key, required this.onPressed, required this.title, this.isActive})
      : super(key: key);
  final void Function()? onPressed;
  final String title;
  final bool? isActive;

  @override
  _TertiaryTextButtonState createState() => _TertiaryTextButtonState();
}

class _TertiaryTextButtonState extends State<TertiaryTextButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: kGeneralWhite,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
                color: Color(0XFFE8EBF3), width: 1, style: BorderStyle.solid)),
        padding: EdgeInsets.symmetric(
            horizontal: screenSize.width < tabletBreakPoint ? 14 : 20,
            vertical: screenSize.width < tabletBreakPoint ? 14 : 20),
        child: Text(
          widget.title,
          style: kTertiaryButtonTextStyle,
        ),
      ),
    );
  }
}

class TertiaryTextButton2 extends StatefulWidget {
  const TertiaryTextButton2(
      {Key? key, required this.onPressed, required this.title, this.isActive})
      : super(key: key);
  final void Function()? onPressed;
  final String title;
  final bool? isActive;

  @override
  _TertiaryTextButton2State createState() => _TertiaryTextButton2State();
}

class _TertiaryTextButton2State extends State<TertiaryTextButton2> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: kGeneralWhite,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
                color: Color(0XFFE8EBF3), width: 1, style: BorderStyle.solid)),
        padding: EdgeInsets.symmetric(
            horizontal: screenSize.width < tabletBreakPoint ? 14 : 20,
            vertical: screenSize.width < tabletBreakPoint ? 14 : 20),
        child: Text(
          widget.title,
          style: kTertiaryButtonTextStyle,
        ),
      ),
    );
  }
}

class TertiaryButton extends StatefulWidget {
  const TertiaryButton(
      {Key? key, required this.onPressed, required this.title, this.isActive})
      : super(key: key);
  final void Function()? onPressed;
  final Widget title;
  final bool? isActive;

  @override
  _TertiaryButtonState createState() => _TertiaryButtonState();
}

class _TertiaryButtonState extends State<TertiaryButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.symmetric(
            horizontal: screenSize.width < tabletBreakPoint ? 17 : 24,
            vertical: screenSize.width < tabletBreakPoint ? 17 : 24),
        child: widget.title,
      ),
    );
  }
}
