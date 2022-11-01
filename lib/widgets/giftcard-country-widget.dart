import 'package:cached_network_image/cached_network_image.dart';
import 'package:faveremit_admin/pages/single-giftcountry-page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/styles.dart';
import '../models/single-giftcard-model.dart';

class GiftCountryWidget extends StatelessWidget {
  final GiftCountry giftCountry;
  final int giftCardID;
  const GiftCountryWidget({
    Key? key,
    required this.giftCountry,
    required this.giftCardID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => SingleCountryPage(
                      giftCountry: giftCountry,
                      giftcardID: giftCardID,
                    )));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: kGeneralWhite,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: Offset(0, 5),
                spreadRadius: 0,
                blurRadius: 20,
              )
            ],
            border: Border.all(
                color: kYellow,
                width: 1,
                style: giftCountry.status == 1
                    ? BorderStyle.none
                    : BorderStyle.solid)),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                width: 90,
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: CachedNetworkImage(
                  imageUrl: giftCountry.image,
                  errorWidget: (context, x, y) {
                    return Image.asset(
                        "assets/flags/${giftCountry.iso.toLowerCase()}.png");
                  },
                ),
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
                    giftCountry.name,
                    style: GoogleFonts.poppins(
                        color: kPrimaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "${giftCountry.ranges} Card Range${giftCountry.ranges > 1 ? "s" : ""}",
                    style: GoogleFonts.poppins(
                      color: kTextGray,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
