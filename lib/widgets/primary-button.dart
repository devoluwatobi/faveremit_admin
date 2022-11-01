import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../config/dimensions.dart';
import '../config/styles.dart';

class PrimaryGradientButton extends StatefulWidget {
  const PrimaryGradientButton(
      {Key? key, required this.onPressed, required this.title, this.isActive})
      : super(key: key);
  final void Function()? onPressed;
  final Widget title;
  final bool? isActive;

  @override
  _PrimaryGradientButtonState createState() => _PrimaryGradientButtonState();
}

class _PrimaryGradientButtonState extends State<PrimaryGradientButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: kPrimaryColor,
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment
                .bottomCenter, // 10% of the width, so there are ten blinds.
            colors: <Color>[
              Color(0xFF3E4095),
              Color(0xFF551AEB),
            ],
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(
            horizontal: screenSize.width < tabletBreakPoint ? 16 : 24,
            vertical: screenSize.width < tabletBreakPoint ? 16 : 24),
        child: widget.title,
      ),
    );
  }
}

// VeridoBiometrics veridoBiometrics = VeridoBiometrics();

class PrimaryButton extends StatefulWidget {
  const PrimaryButton(
      {Key? key, required this.onPressed, required this.title, this.isActive})
      : super(key: key);
  final void Function()? onPressed;
  final Widget title;
  final bool? isActive;

  @override
  _PrimaryButtonState createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
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
            horizontal: screenSize.width < tabletBreakPoint ? 16 : 24,
            vertical: screenSize.width < tabletBreakPoint ? 16 : 24),
        child: widget.title,
      ),
    );
  }
}

class PrimaryTextButton extends StatefulWidget {
  const PrimaryTextButton(
      {Key? key, required this.onPressed, required this.title, this.isActive})
      : super(key: key);
  final void Function()? onPressed;
  final String title;
  final bool? isActive;

  @override
  _PrimaryTextButtonState createState() => _PrimaryTextButtonState();
}

class _PrimaryTextButtonState extends State<PrimaryTextButton> {
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
        child: Text(
          widget.title,
          style: kPrimaryButtonTextStyle,
        ),
      ),
    );
  }
}

class PrimaryGradientTextButton extends StatefulWidget {
  const PrimaryGradientTextButton(
      {Key? key, required this.onPressed, required this.title, this.isActive})
      : super(key: key);
  final void Function()? onPressed;
  final String title;
  final bool? isActive;

  @override
  _PrimaryGradientTextButtonState createState() =>
      _PrimaryGradientTextButtonState();
}

class _PrimaryGradientTextButtonState extends State<PrimaryGradientTextButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: kPrimaryColor,
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment
                .bottomCenter, // 10% of the width, so there are ten blinds.
            colors: <Color>[
              Color(0xFF3E4095),
              Color(0xFF551AEB),
            ],
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(
            horizontal: screenSize.width < tabletBreakPoint ? 16 : 24,
            vertical: screenSize.width < tabletBreakPoint ? 16 : 24),
        child: Text(
          widget.title,
          style: kPrimaryButtonTextStyle,
        ),
      ),
    );
  }
}
