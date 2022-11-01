import 'package:faveremit_admin/pages/buy-airtime.dart';
import 'package:faveremit_admin/services-classes/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../config/dimensions.dart';
import '../config/styles.dart';
import '../main.dart';
import '../widgets/option-widget-style-2.dart';

class PayBillsPage extends StatefulWidget {
  const PayBillsPage({Key? key}) : super(key: key);

  @override
  _PayBillsPageState createState() => _PayBillsPageState();
}

class _PayBillsPageState extends State<PayBillsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kGeneralWhite,
        foregroundColor: kGeneralWhite,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            FlutterRemix.arrow_left_line,
            color: kTextPrimary,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Pay Bills",
          style: GoogleFonts.poppins(
              color: kTextPrimary, fontWeight: FontWeight.w500),
        ),
      ),
      backgroundColor: kGeneralWhite,
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: kAppHorizontalPadding,
          children: [
            const SizedBox(
              height: 40,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "What Bill do you want to pay today ${getFirstName(fullName: Provider.of<UserData>(context).userModel!.user.name).inTitleCase} ?",
                  style: kSubTitleStyle,
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: screenSize.width < tabletBreakPoint
                      ? 10
                      : screenSize.width * 0.026,
                ),
                Text(
                  "Select an option among the list of bill payment services we offer below.",
                  style: kSubTextStyle,
                ),
                SizedBox(
                  height: screenSize.width < tabletBreakPoint
                      ? 40
                      : screenSize.width * 0.1,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconOptionTile(
                  title: "Airtime",
                  iconData: FlutterRemix.coupon_fill,
                  onPressed: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => BuyAirtimePage()));
                  },
                ),
                IconOptionTile(
                  title: "Internet",
                  iconData: FlutterRemix.base_station_fill,
                ),
                IconOptionTile(
                  title: "TV",
                  iconData: FlutterRemix.radar_fill,
                ),
                IconOptionTile(
                  title: "Electricity",
                  iconData: FlutterRemix.lightbulb_flash_fill,
                ),
                IconOptionTile(
                  title: "WiFi",
                  iconData: FlutterRemix.wifi_fill,
                ),
                IconOptionTile(
                  title: "Betting",
                  iconData: FlutterRemix.gamepad_line,
                ),
              ],
            ),
            const SizedBox(
              height: 60,
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionsDateSegment extends StatelessWidget {
  final String date;
  const TransactionsDateSegment({
    Key? key,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 20, top: 10, bottom: 10),
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: Text(
              date.inTitleCase,
              style: GoogleFonts.poppins(fontSize: 13, color: kTextPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
