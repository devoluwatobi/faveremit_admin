import 'package:faveremit_admin/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../config/dimensions.dart';
import '../config/styles.dart';
import '../models/bitcoin-wallet-model.dart';
import 'edit-wallet-page.dart';

bool dxg = true;

class WalletsPage extends StatefulWidget {
  const WalletsPage({Key? key}) : super(key: key);

  @override
  _WalletsPageState createState() => _WalletsPageState();
}

class _WalletsPageState extends State<WalletsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: kAppHorizontalPadding,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          SizedBox(
            height: screenSize.width < tabletBreakPoint
                ? 60
                : screenSize.width * 0.10,
          ),
          Column(
            children: Provider.of<AppData>(context)
                .bitcoinWallets!
                .map((e) => BitCoinWalletCard(
                      wallet: e,
                    ))
                .toList(),
          )
        ],
      ),
    );
  }
}

class BitCoinWalletCard extends StatelessWidget {
  final BtcWalletModel wallet;
  const BitCoinWalletCard({
    Key? key,
    required this.wallet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        showCupertinoModalBottomSheet(
            barrierColor: Colors.black.withOpacity(0.8),
            context: context,
            builder: (context) => EditWalletPage(
                  wallet: wallet,
                ));
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
                FlutterRemix.bit_coin_fill,
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
                    wallet.address,
                    style: GoogleFonts.poppins(
                        color: kTextPrimary,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    wallet.status == 0 ? "Disabled" : "Active",
                    style: GoogleFonts.poppins(
                        color: wallet.status == 0 ? kYellow : kGreen,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
