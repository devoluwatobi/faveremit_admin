import 'dart:io';

import 'package:faveremit_admin/services-classes/biometric.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth-pages/reset-password.dart';
import '../config/dimensions.dart';
import '../config/styles.dart';
import '../main.dart';
import '../services-classes/info-modal.dart';
import '../widgets/options-widget.dart';
import '../widgets/show-snackbar.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({Key? key}) : super(key: key);

  @override
  _SecurityPageState createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
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
          "Security",
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
        physics: BouncingScrollPhysics(),
        children: [
          SizedBox(
            height: screenSize.width < tabletBreakPoint
                ? 20
                : screenSize.width * 0.1,
          ),
          OptionTile2(
            title: 'Reset Password',
            image: Image.asset("assets/3d/pin.png"),
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

              Navigator.pushReplacement(context,
                  CupertinoPageRoute(builder: (context) {
                return PasswordResetPage(
                  rememberpassword: true,
                );
              }));
            },
          ),
          OptionTile2(
            title: 'Setup Fingerprint / Face ID',
            image: Image.asset(
                "assets/3d/${Platform.isIOS ? "faceid" : "thumbprint"}.png"),
            onPressed: () async {
              if (!appBiometrics.canCheckBiometrics) {
                showInfoModal(
                    context: context,
                    title: "Oops!",
                    content:
                        "Sorry, Faveremit can't use biometrics on this device");
              } else {
                bool valid = await appBiometrics.authenticate();
                if (valid) {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setBool("biometrics", true);
                  Provider.of<UserData>(context, listen: false)
                      .updateUseBiometric(true);
                  showSnackBar(
                      context: context,
                      content:
                          '${Platform.isAndroid ? "Fingerprint" : "FaceID"} Unlock Updated');
                } else {
                  showSnackBar(
                      context: context,
                      content:
                          'Could not update ${Platform.isAndroid ? "Fingerprint" : "FaceID"}');
                }
              }
            },
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

// String? _selectedDate;
bool _loading = false;
