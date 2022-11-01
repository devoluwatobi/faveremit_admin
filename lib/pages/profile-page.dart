import 'package:cached_network_image/cached_network_image.dart';
import 'package:faveremit_admin/pages/helpdesk-page.dart';
import 'package:faveremit_admin/pages/personal-info.dart';
import 'package:faveremit_admin/pages/security-page.dart';
import 'package:faveremit_admin/pages/wallet-page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../config/cool_icons_icons.dart';
import '../config/dimensions.dart';
import '../config/styles.dart';
import '../main.dart';
import '../services-classes/functions.dart';
import '../widgets/options-widget.dart';
import 'legals-page.dart';

bool dxg = true;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        SizedBox(
          height: screenSize.width < tabletBreakPoint
              ? 60
              : screenSize.width * 0.10,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenSize.width < tabletBreakPoint
                  ? 40
                  : screenSize.width * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: Provider.of<UserData>(context)
                      .userModel!
                      .user
                      .photo
                      .toString(),
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                  placeholder: (context, url) {
                    return Container(
                      alignment: Alignment.center,
                      height: 100,
                      width: 100,
                      color: kPrimaryColor,
                      child: Text(
                        getInitials(Provider.of<UserData>(context)
                                .userModel!
                                .user
                                .name)
                            .toString(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
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
                      height: 100,
                      width: 100,
                      color: kPrimaryColor,
                      child: Text(
                        getInitials(Provider.of<UserData>(context)
                                .userModel!
                                .user
                                .name)
                            .toString(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                            color: kGeneralWhite),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: screenSize.width < tabletBreakPoint
                    ? 10
                    : screenSize.width * 0.02,
              ),
              Text(
                Provider.of<UserData>(context).userModel!.user.name.inTitleCase,
                style: authSubTextStyle,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: screenSize.width < tabletBreakPoint
                    ? 5
                    : screenSize.width * 0.01,
              ),
              Text(
                Provider.of<UserData>(context).userModel!.user.email,
                style: kAuthSubText2Style,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: screenSize.width < tabletBreakPoint
                    ? 45
                    : screenSize.width * 0.15,
              ),
            ],
          ),
        ),
        Padding(
          padding: kAppHorizontalPadding,
          child: Column(
            children: [
              OptionTile(
                onPressed: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => const WalletPage()));
                },
                title: "Wallet",
                image: Image.asset("assets/3d/wallet.png"),
              ),
              OptionTile(
                onPressed: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => const PersonalInfoPage()));
                },
                title: "Personal Info",
                image: Image.asset("assets/3d/personal-info.png"),
              ),
              OptionTile(
                onPressed: () {},
                title: "Bank Accounts",
                image: Image.asset("assets/3d/bank.png"),
              ),
              OptionTile(
                onPressed: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => const SecurityPage()));
                },
                title: "Security",
                image: Image.asset("assets/3d/security.png"),
              ),
              OptionTile(
                onPressed: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => const HelpDeskPage()));
                },
                title: "Help Desk",
                image: Image.asset("assets/3d/helpdesk.png"),
              ),
              OptionTile(
                onPressed: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => const LegalsPage()));
                },
                title: "Legals",
                image: Image.asset("assets/3d/legals.png"),
              ),
              SizedBox(
                height: screenSize.width < tabletBreakPoint
                    ? 40
                    : screenSize.width * 0.08,
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.symmetric(
                    vertical: screenSize.width < tabletBreakPoint
                        ? 5
                        : screenSize.width * 0.01,
                  ),
                  padding: EdgeInsets.only(
                    left: screenSize.width < tabletBreakPoint
                        ? 14
                        : screenSize.width * 0.022,
                    right: screenSize.width < tabletBreakPoint
                        ? 14
                        : screenSize.width * 0.03,
                  ),
                  width: double.infinity,
                  height: screenSize.width < tabletBreakPoint
                      ? 60
                      : screenSize.width * 0.12,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: kPrimaryColor.withOpacity(.1),
                          offset: Offset(0, 5),
                          spreadRadius: 0,
                          blurRadius: 20,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(
                          screenSize.width < tabletBreakPoint ? 10 : 16),
                      color: kGeneralWhite,
                      border: Border.all(color: kRed, width: 2)),
                  child: Row(
                    children: [
                      Container(
                        height: screenSize.width < tabletBreakPoint
                            ? 40
                            : screenSize.width * 0.08,
                        width: screenSize.width < tabletBreakPoint
                            ? 40
                            : screenSize.width * 0.08,
                        child: Image.asset("assets/3d/logout.png"),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              screenSize.width < tabletBreakPoint
                                  ? 10
                                  : screenSize.width * 0.015),
                        ),
                      ),
                      SizedBox(
                        width: screenSize.width < tabletBreakPoint
                            ? 20
                            : screenSize.width * 0.03,
                      ),
                      Expanded(
                        child: Text(
                          "Logout",
                          style: GoogleFonts.poppins(
                              fontSize:
                                  screenSize.width < tabletBreakPoint ? 16 : 26,
                              fontWeight: FontWeight.w500,
                              color: kRed),
                        ),
                      ),
                      SizedBox(
                        width: screenSize.width < tabletBreakPoint ? 16 : 30,
                      ),
                      Icon(
                        CoolIcons.chevron_big_right,
                        color: kRed,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 60,
              ),
            ],
          ),
        )
      ],
    );
  }
}
