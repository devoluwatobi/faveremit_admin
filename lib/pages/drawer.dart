import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../config/dimensions.dart';
import '../config/styles.dart';
import '../main.dart';
import '../services-classes/functions.dart';
import '../widgets/option-widget-style-2.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({Key? key}) : super(key: key);

  @override
  _DrawerPageState createState() => _DrawerPageState();
}

bool _notifications = true;
bool _biometrics = false;

class _DrawerPageState extends State<DrawerPage> {
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
          "Menu",
          style: GoogleFonts.poppins(
              color: kTextPrimary, fontWeight: FontWeight.w500),
        ),
      ),
      backgroundColor: kGeneralWhite,
      body: SafeArea(
        child: ListView(
          padding: kAppHorizontalPadding,
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child: CachedNetworkImage(
                    imageUrl: Provider.of<UserData>(context)
                        .userModel!
                        .user
                        .photo
                        .toString(),
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                    placeholder: (context, url) {
                      return Container(
                        alignment: Alignment.center,
                        height: 70,
                        width: 70,
                        color: kPrimaryColor,
                        child: Text(
                          getInitials(
                                  "${Provider.of<UserData>(context).userModel!.user.name}")
                              .toUpperCase(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: kGeneralWhite),
                        ),
                      );
                    },
                    errorWidget: (
                      context,
                      url,
                      error,
                    ) {
                      return Container(
                        alignment: Alignment.center,
                        height: 70,
                        width: 70,
                        color: kPrimaryColor,
                        child: Text(
                          getInitials(
                                  "${Provider.of<UserData>(context).userModel!.user.name}")
                              .toUpperCase(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                              color: kGeneralWhite),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                        text: "Hi, ",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: kTextPrimary,
                        ),
                        children: [
                          TextSpan(
                              text: getFirstName(
                                  fullName: Provider.of<UserData>(context)
                                      .userModel!
                                      .user
                                      .name
                                      .inTitleCase)),
                          TextSpan(text: " 😎")
                        ]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            AppOptionTile(
              title: "Faveremit Accounts",
              iconData: FlutterRemix.group_line,
              onPressed: () {
                Navigator.pushNamed(context, "users");
              },
            ),
            AppOptionTile(
              title: "Reviewed Withdrawals",
              iconData: FlutterRemix.newspaper_fill,
              onPressed: () {
                Navigator.pushNamed(context, "r_withdrawals");
              },
            ),
            AppOptionTile(
              title: "Reviewedx Transactions",
              iconData: FlutterRemix.newspaper_fill,
              onPressed: () {
                Navigator.pushNamed(context, "r_trx");
              },
            ),
            AppOptionTile(
              title: "Promotions",
              iconData: FlutterRemix.bookmark_2_fill,
              onPressed: () {
                Navigator.pushNamed(context, "promotions");
              },
            ),
            // AppOptionTile(
            //   title: "Password",
            //   iconData: FlutterRemix.lock_password_line,
            //   onPressed: () {},
            // ),
            // AppOptionTile(
            //   title: "Support",
            //   iconData: FlutterRemix.customer_service_2_fill,
            //   onPressed: () {},
            // ),
            AppOptionTile(
              title: "Logout",
              iconData: FlutterRemix.logout_circle_line,
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, "login", (route) => false).then((value) {
                  // pallyWorker.logout(context: context);
                });
              },
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
