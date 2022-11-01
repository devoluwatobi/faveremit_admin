import 'package:faveremit_admin/auth-pages/pin-code-page.dart';
import 'package:faveremit_admin/config/styles.dart';
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
import '../main.dart';
import '../pages/webview_page.dart';
import '../services-classes/app-worker.dart';
import '../services-classes/info-modal.dart';
import '../widgets/form-field.dart';
import '../widgets/loading-modal.dart';
import '../widgets/primary-button.dart';

TextEditingController _emailController = TextEditingController();
TextEditingController _passwordController = TextEditingController();
TextEditingController _organizationIDController = TextEditingController();
TextEditingController _phoneController = TextEditingController();
TextEditingController _nameController = TextEditingController();
String initialCountry = 'NG';
late PhoneNumber? _phoneNumber;
Icon _passwordSuffix = Icon(
  CupertinoIcons.eye,
  size: 16,
  color: kPrimaryColor,
);
bool _passwordHide = true;

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  void initState() {
    _phoneNumber = PhoneNumber(isoCode: "NG");
    _emailController.clear();
    _phoneController.clear();
    _nameController.clear();
    _passwordController.clear();
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
              physics: BouncingScrollPhysics(),
              children: [
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width < tabletBreakPoint
                          ? 60
                          : screenSize.width * 0.16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/svg/logo-primary.svg",
                        width: screenSize.width < tabletBreakPoint
                            ? screenSize.width * 0.5
                            : 300,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Create an Account, it’s free!",
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
                              "Full Name",
                              style: kFormTitleTextStyle,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              keyboardType:
                                  getKeyboardType(inputType: AppInputType.text),
                              style: kFormTextStyle,
                              controller: _nameController,
                              validator: fullNameValidator,
                              decoration: appInputDecoration(
                                  inputType: AppInputType.text,
                                  hint: "FirstName LastName"),
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
                                print(number.phoneNumber);
                                _phoneNumber = number;
                              },
                              onInputValidated: (bool value) {
                                print(value);
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
                                print('On Saved: $number');
                              },
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
                              "Email Address",
                              style: kFormTitleTextStyle,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: getKeyboardType(
                                  inputType: AppInputType.email),
                              style: kFormTextStyle,
                              validator: emailValidator,
                              decoration: appInputDecoration(
                                  inputType: AppInputType.email,
                                  hint: "yourmail@xmail.com"),
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
                              "Password",
                              style: kFormTitleTextStyle,
                            ),
                            const SizedBox(
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
                              height:
                                  screenSize.width < tabletBreakPoint ? 24 : 30,
                            )
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Transform.scale(
                              scale: 1.4,
                              child: Checkbox(
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isChecked = value != null ? value : false;
                                  });
                                },
                                value: _isChecked,
                                fillColor:
                                    MaterialStateProperty.resolveWith(getColor),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                    text: "I agree to the ",
                                    style: GoogleFonts.poppins(
                                      fontSize:
                                          screenSize.width < tabletBreakPoint
                                              ? 14
                                              : 16,
                                      color: kTextGray,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: "Terms & Conditions",
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => WebViewPage(
                                                      title: " ",
                                                      url:
                                                          "https://verido.app/privacy-policy/"),
                                                ));

                                            print('Terms & Conditions tapped');
                                          },
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          color: kPrimaryColor,
                                        ),
                                      ),
                                      TextSpan(text: " and "),
                                      TextSpan(
                                        text: "Privacy Policy",
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => WebViewPage(
                                                      title: " ",
                                                      url:
                                                          "https://verido.app/privacy-policy/"),
                                                ));
                                            print('Privacy Policy tapped');
                                          },
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          color: kPrimaryColor,
                                        ),
                                      ),
                                    ]),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        PrimaryButton(
                          title: Text(
                            "Sign Up",
                            style: kPrimaryButtonTextStyle,
                          ),
                          onPressed: () async {
                            if (_isChecked) {
                              if (_formKey.currentState!.validate()) {
                                showLoadingModal(
                                    context: context, title: "Signing Up");
                                SignInError _error = await adminWorker.signUp(
                                    phone: _phoneNumber!.phoneNumber.toString(),
                                    password: _passwordController.text,
                                    email: _emailController.text,
                                    fullName: _nameController.text,
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
                                        CupertinoPageRoute(builder: (context) {
                                      return PinCodeVerificationScreen(
                                        phoneNumber:
                                            Provider.of<UserData>(context)
                                                .userModel!
                                                .user
                                                .phone,
                                        resendOTP: false,
                                        allowBack: false,
                                      );
                                    }));
                                  }
                                } else {
                                  showInfoModal(
                                      context: context,
                                      title: "Sign Up Failed",
                                      content: _error.network
                                          ? "unable to connect to the internet, please check your internet and try again"
                                          : _error.emailXPhone
                                              ? "phone number or email is already registered, please check and try again"
                                              : "unable to complete your request at please try again");
                                }
                              }
                            } else {
                              showInfoModal(
                                  context: context,
                                  title: "Hey!",
                                  content:
                                      "you need to accept the privacy policy and terms to use Faveremit. Please read policy and terms for more info");
                            }
                          },
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        RichText(
                          text: TextSpan(
                              text: "Already have an account? ",
                              style: GoogleFonts.poppins(
                                  fontSize: screenSize.width < tabletBreakPoint
                                      ? 14
                                      : 16,
                                  color: kTextGray,
                                  fontWeight: FontWeight.w500),
                              children: <TextSpan>[
                                TextSpan(
                                  text: "Login",
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      if (kDebugMode) {
                                        print('Login tapped');
                                      }
                                      Navigator.pushReplacementNamed(
                                          context, "login");
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
          ),
        ),
      ),
    );
  }
}

Color getColor(Set<MaterialState> states) {
  const Set<MaterialState> interactiveStates = <MaterialState>{
    MaterialState.hovered,
    MaterialState.focused,
  };
  if (states.any(interactiveStates.contains)) {
    return kInactive;
  }
  return kPrimaryColor;
}

bool _isChecked = false;
