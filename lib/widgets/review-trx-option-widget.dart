import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/styles.dart';

class ReviewTrxOption extends StatelessWidget {
  final Function()? onPressed;
  final String title;
  final String description;
  final int id;
  final Color color;
  const ReviewTrxOption({
    Key? key,
    this.onPressed,
    required this.title,
    required this.description,
    required this.id,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () {},
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                  fontSize: 14, fontWeight: FontWeight.w600, color: color),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              description,
              style: GoogleFonts.poppins(
                  fontSize: 12, color: kTextPrimary.withOpacity(0.7)),
            ),
          ],
        ),
      ),
    );
  }
}
