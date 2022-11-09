import 'package:faveremit_admin/extensions/time_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../config/styles.dart';
import '../models/giftcard-country-model.dart';
import '../pages/edit_category_page.dart';
import '../services-classes/functions.dart';

class SingleGiftCardCategory extends StatelessWidget {
  final ReceiptCategory category;
  const SingleGiftCardCategory({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(
        onTap: () async {
          await showCupertinoModalBottomSheet(
            context: context,
            expand: false,
            barrierColor: const Color(0xFF000000).withOpacity(0.6),
            builder: (context) {
              return EditCategoryPage(category: category);
            },
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: kYellow,
                  width: 1,
                  style: category.status == 1
                      ? BorderStyle.none
                      : BorderStyle.solid),
              color: kGeneralWhite,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: Offset(0, 5),
                  spreadRadius: 0,
                  blurRadius: 20,
                )
              ]),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: kPrimaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(5)),
                child: Icon(
                  FlutterRemix.exchange_fill,
                  color: kPrimaryColor,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.title,
                      style: GoogleFonts.poppins(
                          color: kTextPrimary,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      "updated ${category.updatedAt.toDateTimeString()}"
                          .inTitleCase,
                      style:
                          GoogleFonts.poppins(color: kTextGray, fontSize: 11),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                NumberFormat.simpleCurrency(name: "NGN").format(double.parse(
                    category.amount.toString().replaceAll(",", ""))),
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: kPrimaryColor),
              )
            ],
          ),
        ),
      ),
    );
  }
}
