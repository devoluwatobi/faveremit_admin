import 'package:faveremit_admin/auth-pages/pin-code-page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:provider/provider.dart';

import '../config/dimensions.dart';
import '../config/styles.dart';
import '../main.dart';
import '../services-classes/app-worker.dart';
import '../services-classes/info-modal.dart';
import '../widgets/form-field.dart';
import '../widgets/loading-modal.dart';
import '../widgets/primary-button.dart';

TextEditingController _phoneController = TextEditingController();
TextEditingController _passwordController = TextEditingController();
String initialCountry = 'NG';
late PhoneNumber? _phoneNumber;
Icon _passwordSuffix = Icon(
  CupertinoIcons.eye,
  size: 16,
  color: kPrimaryColor,
);
bool _passwordHide = true;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    _passwordController.clear();
    _phoneController.clear();
    _phoneNumber = PhoneNumber(isoCode: "NG");
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: appSystemLightTheme,
        child: WillPopScope(
          onWillPop: () async {
            MoveToBackground.moveTaskToBack();
            return false;
          },
          child: Scaffold(
              backgroundColor: kGeneralWhite,
              body: SafeArea(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    const SizedBox(
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
                          GestureDetector(
                            onTap: () {},
                            child: SvgPicture.asset(
                              "assets/svg/logo-primary.svg",
                              width: screenSize.width < tabletBreakPoint
                                  ? screenSize.width * 0.5
                                  : 300,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Welcome back, Sign in.",
                            style: authSubTextStyle,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
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
                                  "Phone Number",
                                  style: kFormTitleTextStyle,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                InternationalPhoneNumberInput(
                                  countries: const [
                                    "NG",
                                  ],
                                  textStyle: kFormTextStyle,
                                  initialValue: _phoneNumber,
                                  inputDecoration: appInputDecoration(
                                      inputType: AppInputType.phone,
                                      hint: "8X XXX XXXX"),
                                  onInputChanged: (PhoneNumber number) {
                                    // print(number.phoneNumber);
                                    _phoneNumber = number;
                                    if (kDebugMode) {
                                      print(_phoneNumber!.phoneNumber);
                                    }
                                  },
                                  onInputValidated: (bool value) {
                                    if (kDebugMode) {
                                      print(value);
                                    }
                                  },
                                  selectorConfig: const SelectorConfig(
                                      setSelectorButtonAsPrefixIcon: true,
                                      leadingPadding: 16,
                                      useEmoji: false,
                                      selectorType:
                                          PhoneInputSelectorType.BOTTOM_SHEET,
                                      trailingSpace: true),
                                  ignoreBlank: false,
                                  autoValidateMode: AutovalidateMode.disabled,
                                  selectorTextStyle: kFormTextStyle,
                                  textFieldController: _phoneController,
                                  formatInput: false,
                                  keyboardType: getKeyboardType(
                                      inputType: AppInputType.phone),
                                  inputBorder: OutlineInputBorder(),
                                  onSaved: (PhoneNumber number) {
                                    if (kDebugMode) {
                                      print('On Saved: $number');
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: screenSize.width < tabletBreakPoint
                                      ? 24
                                      : 30,
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Password",
                                  style: kFormTitleTextStyle,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  obscureText: _passwordHide,
                                  controller: _passwordController,
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
                                    hintText: "your password",
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
                                  height: screenSize.width < tabletBreakPoint
                                      ? 24
                                      : 30,
                                )
                              ],
                            ),
                            // Container(
                            //   alignment: Alignment.centerRight,
                            //   width: double.infinity,
                            //   child: GestureDetector(
                            //     onTap: () {
                            //       Navigator.pushNamed(
                            //           context, 'recoverPassword');
                            //     },
                            //     child: Text(
                            //       "Forgot Password",
                            //       style: GoogleFonts.poppins(
                            //           fontSize:
                            //               screenSize.width < tabletBreakPoint
                            //                   ? 14
                            //                   : 16,
                            //           color: kPrimaryColor,
                            //           fontWeight: FontWeight.w500),
                            //     ),
                            //   ),
                            // ),
                            const SizedBox(
                              height: 40,
                            ),
                            PrimaryButton(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Provider.of<DXConfigData>(context,
                                              listen: true)
                                          .loggingIn
                                      ? SizedBox(
                                          child: CircularProgressIndicator(
                                            color: kGeneralWhite,
                                            strokeWidth: 2,
                                          ),
                                          height: 28,
                                          width: 28,
                                        )
                                      : const SizedBox(),
                                  SizedBox(
                                    width: Provider.of<DXConfigData>(context,
                                                listen: true)
                                            .loggingIn
                                        ? 16
                                        : 0,
                                  ),
                                  Text(
                                    "Login",
                                    style: kPrimaryButtonTextStyle,
                                  ),
                                ],
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  showLoadingModal(
                                      context: context, title: "Signing In");

                                  SignInError _error = await adminWorker.login(
                                      phone:
                                          _phoneNumber!.phoneNumber.toString(),
                                      password: _passwordController.text,
                                      context: context);
                                  Navigator.pop(context);
                                  if (!_error.any) {
                                    if (Provider.of<UserData>(context,
                                                listen: false)
                                            .userModel!
                                            .user
                                            .phoneVerifiedAt !=
                                        null) {
                                      Navigator.pushNamed(context, "home");
                                    } else {
                                      Navigator.push(context,
                                          CupertinoPageRoute(
                                              builder: (context) {
                                        return PinCodeVerificationScreen(
                                            phoneNumber:
                                                Provider.of<UserData>(context)
                                                    .userModel!
                                                    .user
                                                    .phone);
                                      }));
                                    }
                                  } else {
                                    showInfoModal(
                                        context: context,
                                        title: "Login Failed",
                                        content: _error.network
                                            ? "unable to connect to the internet, please check your internet and try again"
                                            : _error.emailXPhone
                                                ? "phone number or password is incorrect, please check and try again"
                                                : "unable to complete your request at please try again");
                                  }
                                }
                              },
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            RichText(
                              text: TextSpan(
                                  text: "Don’t have an account? ",
                                  style: GoogleFonts.poppins(
                                      fontSize:
                                          screenSize.width < tabletBreakPoint
                                              ? 14
                                              : 16,
                                      color: kTextGray,
                                      fontWeight: FontWeight.w500),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "Sign Up",
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          if (kDebugMode) {
                                            print('Sign Up tapped');
                                          }
                                          Navigator.pushReplacementNamed(
                                              context, "signUp");
                                          // Navigator.pushNamed(context, "signUp");
                                        },
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        color: kPrimaryColor,
                                      ),
                                    ),
                                  ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              )),
        ));
  }
}
