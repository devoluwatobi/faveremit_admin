import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/dimensions.dart';
import '../config/styles.dart';
import '../widgets/options-widget.dart';

class LegalsPage extends StatefulWidget {
  const LegalsPage({Key? key}) : super(key: key);

  @override
  _LegalsPageState createState() => _LegalsPageState();
}

class _LegalsPageState extends State<LegalsPage> {
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
          "Legals",
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
          OptionTile2(
            title: "Privacy Policy",
            image: Image.asset("assets/3d/doc-white.png"),
            onPressed: () async {
              // bool? _goAhead = await showCupertinoModalPopup(
              //     context: context,
              //     builder: (context) => CupertinoAlertDialog(
              //           title: Text(
              //             "Please Confirm",
              //             style: GoogleFonts.poppins(),
              //           ),
              //           content: Text(
              //               "Are you sure you want to change your Verido password ?"),
              //           actions: [
              //             CupertinoDialogAction(
              //               child: Text(
              //                 "Yes",
              //                 style: GoogleFonts.poppins(color: kTextPrimary),
              //               ),
              //               onPressed: () {
              //                 Navigator.pop(context, true);
              //               },
              //             ),
              //             CupertinoDialogAction(
              //               isDefaultAction: true,
              //               child: Text(
              //                 "No",
              //                 style: GoogleFonts.poppins(color: kVeridoPrimary),
              //               ),
              //               onPressed: () {
              //                 Navigator.pop(context, false);
              //               },
              //             ),
              //           ],
              //         ));
              //
              // if (_goAhead != null && _goAhead) {
              //   Navigator.push(context, CupertinoPageRoute(builder: (context) {
              //     return PasswordResetCodePage(
              //         phoneNumber:
              //             Provider.of<VeridoUserData>(context, listen: false)
              //                 .user!
              //                 .phone);
              //   }));
              // }
            },
          ),
          OptionTile2(
            title: "Terms and Conditions",
            image: Image.asset("assets/3d/doc-yellow.png"),
            onPressed: () async {},
          ),
          // VeridoOptionTile2(
          //   title: 'Reset Pin',
          //   iconData: FlutterRemix.door_lock_box_fill,
          //   onPressed: () async {},
          // ),
        ],
      ),
    );
  }
}
