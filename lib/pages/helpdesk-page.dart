import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/dimensions.dart';
import '../config/styles.dart';
import '../widgets/help-desk-option.dart';

class HelpDeskPage extends StatefulWidget {
  const HelpDeskPage({Key? key}) : super(key: key);

  @override
  _HelpDeskPageState createState() => _HelpDeskPageState();
}

class _HelpDeskPageState extends State<HelpDeskPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGeneralWhite,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Help Desk",
          style: GoogleFonts.poppins(color: kTextPrimary),
          overflow: TextOverflow.ellipsis,
        ),
        iconTheme: IconThemeData(color: kTextPrimary),
        backgroundColor: kGeneralWhite,
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: ListView(
        padding: kAppHorizontalPadding,
        physics: const BouncingScrollPhysics(),
        children: [
          SizedBox(
            height: screenSize.width < tabletBreakPoint
                ? 20
                : screenSize.width * 0.1,
          ),
          HelpDeskOption(
            image: Image.asset(
              "assets/3d/call.png",
              errorBuilder: (context, x, y) {
                return Icon(
                  FlutterRemix.phone_fill,
                  size: 40,
                  color: kPrimaryColor,
                );
              },
            ),
            title: "Support Call Center",
            value: "+2348077445802",
            onPressed: () async {
              Uri _url = Uri.parse('tel:2348077445802');
              if (!await launchUrl(_url)) throw 'Could not launch $_url';
            },
            imageBG: const Color(0xFFD8F6F4),
          ),
          HelpDeskOption(
            image: Image.asset(
              "assets/3d/email.png",
              errorBuilder: (context, x, y) {
                return Icon(
                  FlutterRemix.mail_fill,
                  size: 40,
                  color: kPrimaryColor,
                );
              },
            ),
            title: "Email",
            value: "support@faveremit.com",
            onPressed: () async {
              Uri _url = Uri.parse('mailto:support@faveremit.com');
              if (!await launchUrl(_url)) throw 'Could not launch $_url';
            },
            imageBG: const Color(0xFFF6EED8),
          ),
        ],
      ),
    );
  }
}
