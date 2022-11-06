import 'package:cached_network_image/cached_network_image.dart';
import 'package:drop_shadow/drop_shadow.dart' as ds;
import 'package:faveremit_admin/extensions/time_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/styles.dart';
import '../models/user_transaction-list.dart';
import '../pages/user_transaction_page.dart';
import '../services-classes/functions.dart';

class FavUserTransactionCard extends StatelessWidget {
  final UserFavTransaction transaction;
  const FavUserTransactionCard({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // if (transaction.type.toLowerCase().contains("giftcard")) {
        //   Navigator.push(
        //       context,
        //       CupertinoPageRoute(
        //           builder: (context) => GTrxReceiptPage(
        //                 transaction: transaction,
        //               )));
        // } else if (transaction.type.toLowerCase().contains("crypto")) {
        //   Navigator.push(
        //       context,
        //       CupertinoPageRoute(
        //           builder: (context) => CryptoReceiptPage(
        //                 transaction: transaction,
        //               )));
        // } else if (transaction.type.toLowerCase().contains("bill")) {
        //   Navigator.push(
        //       context,
        //       CupertinoPageRoute(
        //           builder: (context) => UtilityReceiptPage(
        //                 transaction: transaction,
        //               )));
        // } else if (transaction.type.toLowerCase().contains("wallet")) {
        //   Navigator.push(
        //       context,
        //       CupertinoPageRoute(
        //           builder: (context) => WithdrawalReceiptPage(
        //                 transaction: transaction,
        //               )));
        // }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: kFormBG,
          // boxShadow: [
          //   BoxShadow(
          //     color: const Color(0xFF606470).withOpacity(.1),
          //     offset: const Offset(0, 5),
          //     spreadRadius: 0,
          //     blurRadius: 20,
          //   )
          // ],
        ),
        width: double.infinity,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            ds.DropShadow(
              offset: const Offset(0, 3),
              blurRadius: 2,
              spread: 0,
              opacity: .3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: transaction.icon,
                  fit: BoxFit.cover,
                  height: 40,
                  width: 40,
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
                    transaction.title,
                    style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: kTextPrimary),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    transaction.createdAt.toDateTimeString(),
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: kTextGray),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "₦${addCommas(transaction.amount)}",
                  style: GoogleFonts.poppins(
                      color: kTextPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  transaction.status.inTitleCase,
                  style: GoogleFonts.poppins(
                      color: getStatusColor(transaction.status),
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
