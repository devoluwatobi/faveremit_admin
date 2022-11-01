import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/dimensions.dart';
import '../config/styles.dart';
import '../widgets/primary-button.dart';
import '../widgets/withdrawal-item-card.dart';

class BankListPage extends StatefulWidget {
  const BankListPage({Key? key}) : super(key: key);

  @override
  _BankListPageState createState() => _BankListPageState();
}

class _BankListPageState extends State<BankListPage> {
  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGeneralWhite,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Bank Accounts",
          style: GoogleFonts.poppins(color: kTextPrimary),
          overflow: TextOverflow.ellipsis,
        ),
        iconTheme: IconThemeData(color: kTextPrimary),
        backgroundColor: kGeneralWhite,
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: kAppHorizontalPadding,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 40,
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(screenSize.width < tabletBreakPoint
                    ? 20
                    : screenSize.width * 0.04),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      screenSize.width < tabletBreakPoint
                          ? 20
                          : screenSize.width * 0.04),
                  color: kFormBG,
                ),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            screenSize.width < tabletBreakPoint
                                ? 10
                                : screenSize.width * 0.02),
                        color: Color(0xFF0C2253),
                      ),
                      padding: EdgeInsets.all(
                          screenSize.width < tabletBreakPoint
                              ? 20
                              : screenSize.width * 0.04),
                      child: Column(
                        children: [
                          Text(
                            "Wallet Balance",
                            style: kWhiteSubTitleTextStyle,
                          ),
                          SizedBox(
                            height: screenSize.width < tabletBreakPoint
                                ? 10
                                : screenSize.width * 0.02,
                          ),
                          Text(
                            "₦400",
                            style: kWalletBalTextStyle,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: screenSize.width < tabletBreakPoint
                          ? 20
                          : screenSize.width * 0.04,
                    ),
                    PrimaryButton(
                      title: Text(
                        "Withdraw",
                        style: kPrimaryButtonTextStyle,
                      ),
                      onPressed: () async {
                        Navigator.pushNamed(context, "withdraw");
                      },
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  "Withdrawal History",
                  style: kSubTitleTextStyle,
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                WithdrawalItem(),
                WithdrawalItem(),
                WithdrawalItem(),
                WithdrawalItem(),
                WithdrawalItem(),
              ]),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 40,
              ),
            )
          ],
        ),
      ),
    );
  }
}
