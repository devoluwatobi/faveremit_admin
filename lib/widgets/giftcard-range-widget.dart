import 'package:faveremit_admin/extensions/time_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../config/styles.dart';
import '../models/country-model.dart';
import '../models/giftcard-country-model.dart';
import '../pages/edit-range-page.dart';
import '../services-classes/functions.dart';

class SingleGiftCardRange extends StatelessWidget {
  final GiftCardRange range;
  final String iso;
  final String cardTitle;
  final String cardCountry;
  const SingleGiftCardRange({
    Key? key,
    required this.range,
    required this.iso,
    required this.cardTitle,
    required this.cardCountry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(
        onTap: () async {
          await showCupertinoModalBottomSheet(
            context: context,
            expand: false,
            barrierColor: const Color(0xFF000000).withOpacity(0.6),
            builder: (context) {
              return RangeRateDetailsPage(
                range: range,
                iso: iso,
                cardCountry: cardCountry,
                cardTitle: cardTitle,
              );
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
                  style: range.status == 1.toString()
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
                      "${range.min} - ${range.max} ${countryList.countries.country.firstWhere((element) => element.countryCode.toLowerCase() == iso.toLowerCase()).currencyCode}",
                      style: GoogleFonts.poppins(
                          color: kTextPrimary,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      "updated ${range.updatedAt.toDateTimeString()}"
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
                "${range.receiptCategories.length} Types",
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
