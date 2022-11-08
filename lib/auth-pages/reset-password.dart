import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../config/dimensions.dart';
import '../config/styles.dart';
import '../main.dart';
import '../services-classes/app-worker.dart';
import '../services-classes/info-modal.dart';
import '../widgets/back-app-bar.dart';
import '../widgets/form-field.dart';
import '../widgets/primary-button.dart';
import '../widgets/show-snackbar.dart';

class PasswordResetPage extends StatefulWidget {
  final bool rememberpassword;
  const PasswordResetPage({Key? key, this.rememberpassword = false})
      : super(key: key);

  @override
  _PasswordResetPageState createState() => _PasswordResetPageState();
}

final _formKey = GlobalKey<FormState>();
Icon _passwordSuffix = Icon(
  CupertinoIcons.eye,
  size: 16,
  color: kPrimaryColor,
);
bool _passwordHide = true;
TextEditingController _passwordController = TextEditingController();
TextEditingController _oldPasswordController = TextEditingController();

Icon _confirmPasswordSuffix = Icon(
  CupertinoIcons.eye,
  size: 16,
  color: kPrimaryColor,
);
bool _confirmPasswordHide = true;

Icon _oldPasswordSuffix = Icon(
  CupertinoIcons.eye,
  size: 16,
  color: kPrimaryColor,
);
bool _oldPasswordHide = true;

class _PasswordResetPageState extends State<PasswordResetPage> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: appSystemLightTheme,
        child: Scaffold(
            backgroundColor: kGeneralWhite,
            appBar: buildAppBackBar(context: context),
            body: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width < tabletBreakPoint
                          ? 40
                          : screenSize.width * 0.1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/logos/logo-primary.svg",
                        width: screenSize.width < tabletBreakPoint
                            ? screenSize.width * 0.5
                            : 300,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Choose your new Password",
                        style: authSubTextStyle,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Enter and confirm your new password",
                        textAlign: TextAlign.center,
                        style: kAuthSubText2Style,
                      ),
                      SizedBox(
                        height: 45,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width < tabletBreakPoint
                          ? 20
                          : screenSize.width * 0.04),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Current Password",
                              style: kFormTitleTextStyle,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              controller: _oldPasswordController,
                              obscureText: _oldPasswordHide,
                              keyboardType: getKeyboardType(
                                  inputType: AppInputType.password),
                              style: kFormTextStyle,
                              validator: passwordValidator,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: _oldPasswordSuffix,
                                  onPressed: () {
                                    if (_oldPasswordHide) {
                                      setState(() {
                                        _oldPasswordHide = false;
                                        _oldPasswordSuffix = Icon(
                                          CupertinoIcons.eye_slash,
                                          size: 16,
                                          color: kPrimaryColor,
                                        );
                                      });
                                    } else {
                                      setState(() {
                                        _oldPasswordHide = true;
                                        _oldPasswordSuffix = Icon(
                                          CupertinoIcons.eye,
                                          size: 16,
                                          color: kPrimaryColor,
                                        );
                                      });
                                    }
                                  },
                                ),
                                fillColor: kFormBG,
                                filled: true,
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      color: kRed,
                                      width: 1,
                                      style: BorderStyle.solid),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      color: kRed,
                                      width: 1,
                                      style: BorderStyle.solid),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal:
                                        screenSize.width < tabletBreakPoint
                                            ? 16
                                            : 24,
                                    vertical:
                                        screenSize.width < tabletBreakPoint
                                            ? 16
                                            : 24),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: "your current password",
                                hintStyle: GoogleFonts.poppins(
                                    fontSize:
                                        screenSize.width < tabletBreakPoint
                                            ? 16
                                            : 18,
                                    fontWeight: FontWeight.w600,
                                    color: kInactive),
                              ),
                            ),
                            SizedBox(
                              height:
                                  screenSize.width < tabletBreakPoint ? 24 : 30,
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "New Password",
                              style: kFormTitleTextStyle,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _passwordHide,
                              keyboardType: getKeyboardType(
                                  inputType: AppInputType.password),
                              style: kFormTextStyle,
                              validator: passwordValidator,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: _passwordSuffix,
                                  onPressed: () {
                                    if (_passwordHide) {
                                      setState(() {
                                        _passwordHide = false;
                                        _passwordSuffix = Icon(
                                          CupertinoIcons.eye_slash,
                                          size: 16,
                                          color: kPrimaryColor,
                                        );
                                      });
                                    } else {
                                      setState(() {
                                        _passwordHide = true;
                                        _passwordSuffix = Icon(
                                          CupertinoIcons.eye,
                                          size: 16,
                                          color: kPrimaryColor,
                                        );
                                      });
                                    }
                                  },
                                ),
                                fillColor: kFormBG,
                                filled: true,
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      color: kRed,
                                      width: 1,
                                      style: BorderStyle.solid),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      color: kRed,
                                      width: 1,
                                      style: BorderStyle.solid),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal:
                                        screenSize.width < tabletBreakPoint
                                            ? 16
                                            : 24,
                                    vertical:
                                        screenSize.width < tabletBreakPoint
                                            ? 16
                                            : 24),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: "your new password",
                                hintStyle: GoogleFonts.poppins(
                                    fontSize:
                                        screenSize.width < tabletBreakPoint
                                            ? 16
                                            : 18,
                                    fontWeight: FontWeight.w600,
                                    color: kInactive),
                              ),
                            ),
                            SizedBox(
                              height:
                                  screenSize.width < tabletBreakPoint ? 24 : 30,
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Confirm Password",
                              style: kFormTitleTextStyle,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              obscureText: _confirmPasswordHide,
                              keyboardType: getKeyboardType(
                                  inputType: AppInputType.password),
                              style: kFormTextStyle,
                              validator: _confirmPasswordValidator,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: _confirmPasswordSuffix,
                                  onPressed: () {
                                    if (_confirmPasswordHide) {
                                      setState(() {
                                        _confirmPasswordHide = false;
                                        _confirmPasswordSuffix = Icon(
                                          CupertinoIcons.eye_slash,
                                          size: 16,
                                          color: kPrimaryColor,
                                        );
                                      });
                                    } else {
                                      setState(() {
                                        _confirmPasswordHide = true;
                                        _confirmPasswordSuffix = Icon(
                                          CupertinoIcons.eye,
                                          size: 16,
                                          color: kPrimaryColor,
                                        );
                                      });
                                    }
                                  },
                                ),
                                fillColor: kFormBG,
                                filled: true,
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      color: kRed,
                                      width: 1,
                                      style: BorderStyle.solid),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      color: kRed,
                                      width: 1,
                                      style: BorderStyle.solid),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal:
                                        screenSize.width < tabletBreakPoint
                                            ? 16
                                            : 24,
                                    vertical:
                                        screenSize.width < tabletBreakPoint
                                            ? 16
                                            : 24),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: "confirm new password",
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: screenSize.width < tabletBreakPoint
                                      ? 16
                                      : 18,
                                  fontWeight: FontWeight.w600,
                                  color: kInactive,
                                ),
                              ),
                            ),
                            SizedBox(
                              height:
                                  screenSize.width < tabletBreakPoint ? 24 : 30,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        PrimaryButton(
                          title: Text(
                            "Reset Password",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: kPrimaryButtonTextStyle,
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              late ProcessError _error;
                              if (widget.rememberpassword) {
                                _error = await adminWorker.updatePassword(
                                    newPassword: _passwordController.text,
                                    oldPassword: _oldPasswordController.text,
                                    context: context);
                              } else {
                                _error = await adminWorker.resetPassword(
                                    newPassword: _passwordController.text,
                                    otp: Provider.of<UserData>(context,
                                            listen: false)
                                        .otp
                                        .toString(),
                                    context: context);
                              }

                              if (!_error.any) {
                                showSnackBar(
                                    context: context,
                                    content: "Password Reset Successfully");
                                Navigator.pop(context);
                                showInfoModal(
                                    context: context,
                                    title: "Success",
                                    content:
                                        "Your Password has been reset successfully. You can now proceed with your new password");
                              } else {
                                showInfoModal(
                                    context: context,
                                    title: "Oops!",
                                    content: _error.network
                                        ? "unable to connect to the internet, please check your internet and try again by clicking the verify button"
                                        : _error.details
                                            ? "session expired, please generate OTP and try again"
                                            : "unable to complete your request at please try again");
                              }
                            } else {
                              print("Invalid form");
                            }
                          },
                        ),
                        SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )));
  }
}

String? _confirmPasswordValidator(value) {
  if (value == null || value.isEmpty) {
    return 'your password is required';
  }
  if (value.trim().length < 8) {
    return 'your password must contain at least 8 characters';
  }
  if (value != _passwordController.text) {
    return "both passwords are not the same";
  }
  return null;
}
