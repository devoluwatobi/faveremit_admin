import 'package:faveremit_admin/config/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';

showSnackBar(
    {required BuildContext context,
    required String content,
    bool isGood = true}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: kGeneralWhite,
    padding: EdgeInsets.symmetric(horizontal: 30),
    elevation: 4,
    content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: kGeneralWhite,
            boxShadow: const [
              BoxShadow(
                color: Color(0x19000000),
                spreadRadius: 2.0,
                blurRadius: 8.0,
                offset: Offset(2, 4),
              )
            ],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                FlutterRemix.checkbox_circle_fill,
                color: isGood ? kPrimaryColor : kRed,
              ),
              const SizedBox(
                width: 16,
              ),
              Text(
                content,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    color: isGood ? kPrimaryColor : kRed,
                    fontWeight: FontWeight.w600,
                    fontSize: 16),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    ),
  ));
}
