import 'package:faveremit_admin/main.dart';
import 'package:faveremit_admin/models/crypto_wallet_address.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../config/dimensions.dart';
import '../config/styles.dart';
import '../services-classes/app-worker.dart';
import '../widgets/show-option-modal.dart';
import 'edit-wallet-page.dart';

bool dxg = true;

class WalletsPage extends StatefulWidget {
  const WalletsPage({Key? key}) : super(key: key);

  @override
  _WalletsPageState createState() => _WalletsPageState();
}

late RefreshController _refreshController;

class _WalletsPageState extends State<WalletsPage> {
  _fetchWallets() async {
    ProcessError error = await adminWorker.getCryptoWallets(context: context);
    ;
    if (error.any) {
      dynamic rez = await showSingleOptionPopup(
          context: context,
          title: "Oops!",
          body:
              "Couldn't fetch page resources. Please check your internet connection and try again.",
          actionTitle: "retry",
          isDestructive: false,
          onPressed: () {
            Navigator.pop(context, true);
            _fetchWallets();
          });
      // if (rez == null || rez == false) {
      //   Navigator.pop(context);
      // }
    } else {
      setState(() {});
    }
  }

  void _onRefresh() async {
    // monitor network fetch
    ProcessError _response =
        await adminWorker.getCryptoWallets(context: context);
    setState(() {});
    if (_response.any) {
      _refreshController.refreshFailed();
    } else {
      setState(() {});
      _refreshController.refreshCompleted();
    }
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    _refreshController = RefreshController(initialRefresh: false);
    _fetchWallets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: kAppHorizontalPadding,
      child: SmartRefresher(
        header: const WaterDropHeader(),
        enablePullDown: true,
        controller: _refreshController,
        onRefresh: _onRefresh,
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
                  .cryptoWallets!
                  .map((e) => CryptoWalletCard(
                        wallet: e,
                      ))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}

class CryptoWalletCard extends StatelessWidget {
  final CryptoWalletAddress wallet;
  const CryptoWalletCard({
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: kGeneralWhite,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 5),
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
                FlutterRemix.coin_fill,
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
                  Row(
                    children: [
                      Text(
                        wallet.crypto.name,
                        style: GoogleFonts.poppins(
                            color: kPrimaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        height: 10,
                        child: VerticalDivider(
                          width: 5,
                          color: kTextGray.withOpacity(.5),
                          thickness: 1,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        wallet.status == 0 ? "Disabled" : "Active",
                        style: GoogleFonts.poppins(
                            color: wallet.status == 0 ? kYellow : kGreen,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
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
