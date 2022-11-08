import 'dart:async';

import 'package:faveremit_admin/auth-pages/reset-password.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../config/dimensions.dart';
import '../config/styles.dart';
import '../main.dart';
import '../services-classes/app-worker.dart';
import '../services-classes/info-modal.dart';
import '../widgets/back-app-bar.dart';
import '../widgets/primary-button.dart';
import '../widgets/show-snackbar.dart';

class PasswordResetCodePage extends StatefulWidget {
  final String phoneNumber;

  PasswordResetCodePage({required this.phoneNumber});

  @override
  _PasswordResetCodePageState createState() => _PasswordResetCodePageState();
}

const int time = 60;
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
          const SizedBox(
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

class _PasswordResetCodePageState extends State<PasswordResetCodePage>
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
    ProcessError _error = await adminWorker.sendPasswordResetOTP(
        phone: widget.phoneNumber, context: context);
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

    errorController = StreamController<ErrorAnimationType>();

    totalTimeInSeconds = time;
    super.initState();
    _controller = AnimationController(
        duration: const Duration(seconds: time), vsync: this)
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
    return Scaffold(
      appBar: buildAppBackBar(context: context),
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
                      "assets/logos/logo-primary.svg",
                      width: screenSize.width < tabletBreakPoint
                          ? screenSize.width * 0.5
                          : 300,
                    ),
                    const SizedBox(
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
              const SizedBox(height: 8),
              const SizedBox(
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
              const SizedBox(
                height: 34,
              ),
              Padding(
                padding: kAppHorizontalPadding,
                child: PrimaryButton(
                  onPressed: () async {
                    if (textEditingController.text ==
                        Provider.of<UserData>(context, listen: false)
                            .otp
                            .toString()) {
                      showSnackBar(context: context, content: "OTP Correct");

                      Navigator.pushReplacement(context,
                          CupertinoPageRoute(builder: (context) {
                        return PasswordResetPage();
                      }));
                    } else {
                      showInfoModal(
                          context: context,
                          title: "Oops!",
                          content:
                              "OTP code is incorrect or expired, please check and try again");
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
