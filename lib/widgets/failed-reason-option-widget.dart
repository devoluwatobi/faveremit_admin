import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/styles.dart';

class FailedReasonOption extends StatelessWidget {
  final String title;
  final String description;
  final bool isActive;
  final Function()? onPressed;
  const FailedReasonOption({
    Key? key,
    required this.title,
    required this.description,
    required this.isActive,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: Color(0xFFF5F6FA),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              width: 1,
              color: kPrimaryColor,
              style: isActive ? BorderStyle.solid : BorderStyle.none),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isActive ? kPrimaryColor : kTextPrimary),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              description,
              style: GoogleFonts.poppins(
                  fontSize: 11, color: kTextPrimary.withOpacity(0.7)),
            ),
          ],
        ),
      ),
    );
  }
}
