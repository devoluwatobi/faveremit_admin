// import 'dart:async';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:verido/config/dimensions.dart';
// import 'package:verido/config/styles.dart';
// import 'package:verido/widgets/back-app-bar.dart';
//
// class OTPVerificationPage extends StatefulWidget {
//   final String phone;
//   const OTPVerificationPage({Key? key, required this.phone}) : super(key: key);
//
//   @override
//   _OTPVerificationPageState createState() => _OTPVerificationPageState();
// }
//
// late String? otp = "";
//
// class _OTPVerificationPageState extends State<OTPVerificationPage>
//     with SingleTickerProviderStateMixin {
//   // Constants
//   final int time = 60;
//   late AnimationController _controller;
//
//   // Variables
//   late String? _currentDigit;
//   late String? _firstDigit = "";
//   late String? _secondDigit = "";
//   late String? _thirdDigit = "";
//   late String? _fourthDigit = "";
//
//   // late bool _isOTPFilled;
//
//   late Timer timer;
//   late int totalTimeInSeconds;
//   late bool _hideResendButton;
//
//   // Return "OTP" input field
//   get _buildInputField {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: <Widget>[
//           _otpTextField(_firstDigit),
//           _otpTextField(_secondDigit),
//           _otpTextField(_thirdDigit),
//           _otpTextField(_fourthDigit),
//         ],
//       ),
//     );
//   }
//
//   // Returns "OTP" input part
//
//   // Returns "Timer" label
//   get _buildTimerText {
//     return Container(
//       height: 32,
//       child: Offstage(
//         offstage: !_hideResendButton,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Icon(
//               Icons.access_time,
//               color: kVeridoPrimary,
//               size: 24,
//             ),
//             SizedBox(
//               width: 5.0,
//             ),
//             OTPTimer(
//               controller: _controller,
//               fontSize: screenSize.width < tabletBreakPoint ? 16.0 : 24,
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Returns "Resend" button
//   get _buildResendButton {
//     return InkWell(
//       child: Container(
//         height: 32,
//         width: 120,
//         decoration: BoxDecoration(
//             color: kVeridoPrimary,
//             shape: BoxShape.rectangle,
//             borderRadius: BorderRadius.circular(32)),
//         alignment: Alignment.center,
//         child: Text(
//           "Resend OTP",
//           style: GoogleFonts.poppins(
//               fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//       ),
//       onTap: () {
//         // Resend you OTP via API or anything
//       },
//     );
//   }
//
//   // Returns "Otp" keyboard
//   get _buildOtpKeyboard {
//     return Container(
//         height: screenSize.width - 110,
//         child: Column(
//           children: <Widget>[
//             Expanded(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   _otpKeyboardInputButton(
//                       label: "1",
//                       onPressed: () {
//                         _setCurrentDigit(1);
//                       }),
//                   _otpKeyboardInputButton(
//                       label: "2",
//                       onPressed: () {
//                         _setCurrentDigit(2);
//                       }),
//                   _otpKeyboardInputButton(
//                       label: "3",
//                       onPressed: () {
//                         _setCurrentDigit(3);
//                       }),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   _otpKeyboardInputButton(
//                       label: "4",
//                       onPressed: () {
//                         _setCurrentDigit(4);
//                       }),
//                   _otpKeyboardInputButton(
//                       label: "5",
//                       onPressed: () {
//                         _setCurrentDigit(5);
//                       }),
//                   _otpKeyboardInputButton(
//                       label: "6",
//                       onPressed: () {
//                         _setCurrentDigit(6);
//                       }),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   _otpKeyboardInputButton(
//                       label: "7",
//                       onPressed: () {
//                         _setCurrentDigit(7);
//                       }),
//                   _otpKeyboardInputButton(
//                       label: "8",
//                       onPressed: () {
//                         _setCurrentDigit(8);
//                       }),
//                   _otpKeyboardInputButton(
//                       label: "9",
//                       onPressed: () {
//                         _setCurrentDigit(9);
//                       }),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   _otpKeyboardActionButton(
//                     label: Icon(
//                       CupertinoIcons.checkmark_circle_fill,
//                       color: otp == null || otp!.trim().length < 4
//                           ? kInactive
//                           : kVeridoPrimary,
//                       size: 44,
//                     ),
//                     onPressed: () {
//                       setState(
//                         () {
//                           Navigator.pushNamed(context, "home");
//                           // verifyOTP(otp: otp)
//                         },
//                       );
//                     },
//                   ),
//                   _otpKeyboardInputButton(
//                       label: "0",
//                       onPressed: () {
//                         _setCurrentDigit(0);
//                       }),
//                   _otpKeyboardActionButton(
//                       label: Icon(
//                         CupertinoIcons.delete_left,
//                         color: kTextPrimary,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           if (_fourthDigit != null) {
//                             _fourthDigit = null;
//                           } else if (_thirdDigit != null) {
//                             _thirdDigit = null;
//                           } else if (_secondDigit != null) {
//                             _secondDigit = null;
//                           } else if (_firstDigit != null) {
//                             _firstDigit = null;
//                           }
//                         });
//                       }),
//                 ],
//               ),
//             ),
//           ],
//         ));
//   }
//
//   // Overridden methods
//   @override
//   void initState() {
//     totalTimeInSeconds = time;
//     super.initState();
//     _controller =
//         AnimationController(vsync: this, duration: Duration(seconds: time))
//           ..addStatusListener((status) {
//             if (status == AnimationStatus.dismissed) {
//               setState(() {
//                 _hideResendButton = !_hideResendButton;
//               });
//             }
//           });
//     _controller.reverse(
//         from: _controller.value == 0.0 ? 1.0 : _controller.value);
//     _startCountdown();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: veridoSystemLightTheme,
//       child: Scaffold(
//         appBar: buildVeridoBackBar(context: context),
//         backgroundColor: kGeneralWhite,
//         body: Container(
//           width: double.infinity,
// //        padding:  EdgeInsets.only(bottom: 16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               SizedBox(
//                 height: 20,
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(
//                     horizontal: screenSize.width < tabletBreakPoint
//                         ? 40
//                         : screenSize.width * 0.1),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     SvgPicture.asset(
//                       "assets/svg/flurry-primary-short.svg",
//                       color: kVeridoPrimary,
//                       width: screenSize.width < tabletBreakPoint
//                           ? screenSize.width * 0.5
//                           : 300,
//                     ),
//                     SizedBox(
//                       height: 30,
//                     ),
//                     Text(
//                       "Type the verification code we’ve sent you",
//                       style: authSubTextStyle,
//                       textAlign: TextAlign.center,
//                     ),
//                     SizedBox(
//                       height: screenSize.height < 700 ? 30 : 45,
//                     ),
//                   ],
//                 ),
//               ),
//               _buildInputField,
//               _buildOtpKeyboard,
//               _hideResendButton ? _buildTimerText : _buildResendButton,
//               SizedBox(
//                 height: screenSize.height < 700 ? 20 : 30,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Returns "Otp custom text field"
//   Widget _otpTextField(String? digit) {
//     return Container(
//       width: (screenSize.width - 110) / 4,
//       height: (screenSize.width - 110) / 4,
//       alignment: Alignment.center,
//       child: Text(
//         digit != null ? digit.toString() : "",
//         style: GoogleFonts.poppins(
//           fontSize: 30.0,
//           color: kTextPrimary,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//       decoration: BoxDecoration(
//         color: kFormBG,
//         borderRadius: BorderRadius.circular(15),
//       ),
//     );
//   }
//
//   // Returns "Otp keyboard input Button"
//   Widget _otpKeyboardInputButton(
//       {required String label, required VoidCallback onPressed}) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: onPressed,
//         borderRadius: BorderRadius.circular(40.0),
//         child: Container(
//           width: (screenSize.width - 110) / 4,
//           height: (screenSize.width - 110) / 4,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//           ),
//           child: Center(
//             child: Text(
//               label,
//               style: GoogleFonts.poppins(
//                 fontSize: 30.0,
//                 color: kTextPrimary,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Returns "Otp keyboard action Button"
//   _otpKeyboardActionButton(
//       {required Widget label, required VoidCallback onPressed}) {
//     return InkWell(
//       onTap: onPressed,
//       borderRadius: BorderRadius.circular(40.0),
//       child: Container(
//         height: 80.0,
//         width: 80.0,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//         ),
//         child: Center(
//           child: label,
//         ),
//       ),
//     );
//   }
//
//   // Current digit
//   void _setCurrentDigit(int i) {
//     setState(() {
//       _currentDigit = i.toString();
//       if (_firstDigit == null || _firstDigit == "") {
//         _firstDigit = _currentDigit;
//       } else if (_secondDigit == null || _secondDigit == "") {
//         _secondDigit = _currentDigit;
//       } else if (_thirdDigit == null || _thirdDigit == "") {
//         _thirdDigit = _currentDigit;
//       } else if (_fourthDigit == null || _fourthDigit == "") {
//         _fourthDigit = _currentDigit;
//
//         setState(() {
//           otp = _firstDigit.toString() +
//               _secondDigit.toString() +
//               _thirdDigit.toString() +
//               _fourthDigit.toString();
//         });
//
//         // Verify your otp by here. API call
//       }
//     });
//   }
//
//   Future<Null> _startCountdown() async {
//     setState(() {
//       _hideResendButton = true;
//       totalTimeInSeconds = time;
//     });
//     _controller.reverse(
//         from: _controller.value == 0.0 ? 1.0 : _controller.value);
//   }
//
//   void clearOtp() {
//     _fourthDigit = "";
//     _thirdDigit = "";
//     _secondDigit = "";
//     _firstDigit = "";
//     setState(() {});
//   }
// }
//
// class OTPTimer extends StatelessWidget {
//   final AnimationController controller;
//   final double fontSize;
//   final Color? timeColor;
//
//   OTPTimer({required this.controller, required this.fontSize, this.timeColor});
//
//   String get timerString {
//     Duration duration = controller.duration! * controller.value;
//     if (duration.inHours > 0) {
//       return '${duration.inHours}:${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
//     }
//     return '${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
//   }
//
//   Duration? get duration {
//     Duration? duration = controller.duration;
//     return duration;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//         animation: controller,
//         builder: (BuildContext context, Widget? child) {
//           return Text(
//             timerString,
//             style: TextStyle(
//                 fontSize: fontSize,
//                 color: timeColor == null ? kVeridoPrimary : timeColor,
//                 fontWeight: FontWeight.w600),
//           );
//         });
//   }
// }
//
// verifyOTP({required String otp}) {}
