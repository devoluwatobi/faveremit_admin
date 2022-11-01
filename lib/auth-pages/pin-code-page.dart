import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../config/dimensions.dart';
import '../config/styles.dart';
import '../main.dart';
import '../services-classes/app-worker.dart';
import '../services-classes/info-modal.dart';
import '../widgets/back-app-bar.dart';
import '../widgets/loading-modal.dart';
import '../widgets/primary-button.dart';
import '../widgets/show-snackbar.dart';

class PinCodeVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final bool resendOTP;
  final bool allowBack;

  PinCodeVerificationScreen(
      {required this.phoneNumber,
      this.resendOTP = true,
      this.allowBack = true});

  @override
  _PinCodeVerificationScreenState createState() =>
      _PinCodeVerificationScreenState();
}

final int time = 60;
late AnimationController _controller;

get _buildTimerText {
  return Container(
    height: 32,
    child: Offstage(
      offstage: !_hideResendButton,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.access_time,
            color: kPrimaryColor,
            size: 24,
          ),
          SizedBox(
            width: 5.0,
          ),
          OTPTimer(
            controller: _controller,
            fontSize: screenSize.width < tabletBreakPoint ? 16.0 : 24,
          )
        ],
      ),
    ),
  );
}

late Timer timer;
late int totalTimeInSeconds;
late bool _hideResendButton;

class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController textEditingController = TextEditingController();
  // ..text = "123456";

  Future<Null> startCountdown() async {
    setState(() {
      _hideResendButton = true;
      totalTimeInSeconds = time;
    });
    _controller.reverse(
        from: _controller.value == 0.0 ? 1.0 : _controller.value);
  }

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final _formKey = GlobalKey<FormState>();

  _sendUserOtp() async {
    ProcessError _error =
        await adminWorker.sendOTP(phone: widget.phoneNumber, context: context);
    if (!_error.any) {
      showSnackBar(context: context, content: "OTP sent successfully");
      startCountdown();
    } else {
      showSnackBar(
          context: context, content: "Could not send OTP", isGood: false);
      showInfoModal(
          context: context,
          title: "Oops!",
          content: _error.network
              ? "unable to connect to the internet, please check your internet and try again by clicking the resend button"
              : "We could not send an OTP to your phone at this time. Please Try again by clicking the resend button");
    }
  }

  @override
  void initState() {
    _hideResendButton = false;
    if (widget.resendOTP) {
      _sendUserOtp();
    }

    errorController = StreamController<ErrorAnimationType>();

    totalTimeInSeconds = time;
    super.initState();
    _controller =
        AnimationController(duration: Duration(seconds: time), vsync: this)
          ..addStatusListener((status) {
            if (status == AnimationStatus.dismissed) {
              setState(() {
                _hideResendButton = !_hideResendButton;
              });
            }
          });
    _controller.reverse(
        from: _controller.value == 0.0 ? 1.0 : _controller.value);
    _sendUserOtp();

    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();
    _controller.dispose();
    super.dispose();
  }

  // snackBar Widget
  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        MoveToBackground.moveTaskToBack();
        return false;
      },
      child: Scaffold(
        appBar: widget.allowBack ? buildAppBackBar(context: context) : null,
        backgroundColor: kGeneralWhite,
        body: GestureDetector(
          onTap: () {},
          child: Container(
            padding: kAppHorizontalPadding,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              children: <Widget>[
                SizedBox(height: 40),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width < tabletBreakPoint
                          ? 40
                          : screenSize.width * 0.1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/svg/logo-primary.svg",
                        width: screenSize.width < tabletBreakPoint
                            ? screenSize.width * 0.5
                            : 300,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Type the verification code we’ve sent to ${widget.phoneNumber}",
                        style: authSubTextStyle,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: screenSize.height < 700 ? 30 : 45,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: PinCodeTextField(
                    appContext: context,
                    pastedTextStyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, color: kPrimaryColor),
                    length: 6,
                    obscureText: false,
                    obscuringCharacter: '*',
                    blinkWhenObscuring: true,
                    animationType: AnimationType.fade,
                    validator: (v) {
                      if (v!.length < 6) {
                        return "OTP code is incomplete";
                      } else {
                        return null;
                      }
                    },
                    pinTheme: PinTheme(
                      selectedFillColor: kFormBG,
                      inactiveFillColor: kFormBG,
                      borderWidth: 0,
                      errorBorderColor: kInactive,
                      inactiveColor: kInactive,
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(8),
                      fieldHeight: 50,
                      fieldWidth: (screenSize.width - 90) / 6,
                      activeFillColor: Colors.white,
                    ),
                    cursorColor: Colors.black,
                    animationDuration: Duration(milliseconds: 300),
                    enableActiveFill: true,
                    errorAnimationController: errorController,
                    controller: textEditingController,
                    keyboardType: TextInputType.number,
                    onCompleted: (v) {
                      print("Completed");
                    },
                    // onTap: () {
                    //   print("Pressed");
                    // },
                    onChanged: (value) {
                      print(value);
                      setState(() {
                        currentText = value;
                      });
                    },
                    beforeTextPaste: (text) {
                      print("Allowing to paste $text");
                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                      return true;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text(
                    hasError ? "*Please fill up all the cells properly" : "",
                    style: TextStyle(
                        color: kFormBG,
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(
                  height: 34,
                ),
                Padding(
                  padding: kAppHorizontalPadding,
                  child: PrimaryButton(
                    onPressed: () async {
                      showLoadingModal(
                          context: context, title: "Verifying OTP");
                      ProcessError _error = await adminWorker.verifyOTP(
                          phone: widget.phoneNumber,
                          otp: textEditingController.text,
                          context: context);
                      Navigator.pop(context);
                      if (!_error.any) {
                        showSnackBar(
                            context: context,
                            content: "OTP Verified Successfully");
                        Navigator.pushReplacementNamed(context, "home");
                      } else {
                        showInfoModal(
                            context: context,
                            title: "Oops!",
                            content: _error.network
                                ? "unable to connect to the internet, please check your internet and try again by clicking the verify button"
                                : _error.details
                                    ? "OTP code is invalid or expired, please check and try again"
                                    : "unable to complete your request at please try again");
                      }
                    },
                    title: Text(
                      "Verify OTP",
                      style: kPrimaryButtonTextStyle,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                _hideResendButton
                    ? _buildTimerText
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Didn't receive the code? ",
                            style: GoogleFonts.poppins(
                                color: kTextGray, fontSize: 16),
                          ),
                          TextButton(
                              onPressed: () async {
                                _sendUserOtp();
                              },
                              child: Text(
                                "RESEND",
                                style: GoogleFonts.poppins(
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ))
                        ],
                      ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OTPTimer extends StatelessWidget {
  final AnimationController controller;
  final double fontSize;
  final Color? timeColor;

  OTPTimer({required this.controller, required this.fontSize, this.timeColor});

  String get timerString {
    Duration duration = controller.duration! * controller.value;
    if (duration.inHours > 0) {
      return '${duration.inHours}:${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    }
    return '${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  Duration? get duration {
    Duration? duration = controller.duration;
    return duration;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget? child) {
          return Text(
            timerString,
            style: TextStyle(
                fontSize: fontSize,
                color: timeColor == null ? kPrimaryColor : timeColor,
                fontWeight: FontWeight.w600),
          );
        });
  }
}
