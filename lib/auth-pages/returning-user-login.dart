import 'package:cached_network_image/cached_network_image.dart';
import 'package:faveremit_admin/auth-pages/pin-code-page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:provider/provider.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';

import '../config/dimensions.dart';
import '../config/styles.dart';
import '../main.dart';
import '../services-classes/app-worker.dart';
import '../services-classes/functions.dart';
import '../services-classes/info-modal.dart';
import '../widgets/form-field.dart';
import '../widgets/loading-modal.dart';
import '../widgets/primary-button.dart';

TextEditingController _passwordController = TextEditingController();
Icon _passwordSuffix = Icon(
  CupertinoIcons.eye,
  size: 16,
  color: kPrimaryColor,
);
bool _passwordHide = true;

class ReturnLoginPage extends StatefulWidget {
  const ReturnLoginPage({Key? key}) : super(key: key);

  @override
  _ReturnLoginPageState createState() => _ReturnLoginPageState();
}

class _ReturnLoginPageState extends State<ReturnLoginPage> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
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
                  height: 60,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width < tabletBreakPoint
                          ? 40
                          : screenSize.width * 0.1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome back, ${getFirstName(fullName: Provider.of<UserData>(context).userModel!.user.name)}",
                        style: authSubTextStyle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Center(
                        child: WidgetCircularAnimator(
                          innerColor: kPrimaryColor,
                          outerColor: kPrimaryColor,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(500),
                            child: CachedNetworkImage(
                              imageUrl: Provider.of<UserData>(context)
                                  .userModel!
                                  .user
                                  .photo
                                  .toString(),
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                              placeholder: (context, url) {
                                return Container(
                                  alignment: Alignment.center,
                                  height: 80,
                                  width: 80,
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
                                  height: 80,
                                  width: 80,
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
                        ),
                      ),

                      // ClipRRect(
                      //   borderRadius: BorderRadius.circular(10),
                      //   child: Container(
                      //     alignment: Alignment.center,
                      //     height: 100,
                      //     width: 100,
                      //     color: kPrimaryColor,
                      //     child: Text(
                      //       "${getInitials(Provider.of<VeridoUserData>(context, listen: false).user!.fullName)}",
                      //       textAlign: TextAlign.center,
                      //       style: GoogleFonts.poppins(
                      //           fontSize: 40,
                      //           fontWeight: FontWeight.w700,
                      //           color: kGeneralWhite),
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(
                        height: 10,
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
                        Container(
                          alignment: Alignment.centerRight,
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, 'recoverPassword');
                            },
                            child: Text(
                              'forgot password',
                              style: GoogleFonts.poppins(
                                  fontSize: screenSize.width < tabletBreakPoint
                                      ? 14
                                      : 16,
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        PrimaryButton(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _loading
                                  ? Container(
                                      child: CircularProgressIndicator(
                                        color: kGeneralWhite,
                                        strokeWidth: 2,
                                      ),
                                      height: 28,
                                      width: 28,
                                    )
                                  : SizedBox(),
                              SizedBox(
                                width: _loading ? 16 : 0,
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
                                  phone: Provider.of<UserData>(context,
                                          listen: false)
                                      .userModel!
                                      .user
                                      .phone
                                      .toString(),
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
                                      CupertinoPageRoute(builder: (context) {
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
                        SizedBox(
                          height: 40,
                        ),
                        RichText(
                          text: TextSpan(
                              text: "This is not you ? ",
                              style: GoogleFonts.poppins(
                                  fontSize: screenSize.width < tabletBreakPoint
                                      ? 14
                                      : 16,
                                  color: kTextGray,
                                  fontWeight: FontWeight.w500),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Sign Out',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      print('Sign Out tapped');
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
                        const SizedBox(
                          height: 40,
                        ),
                        Provider.of<UserData>(context).useBiometrics
                            ? Container(
                                child: GestureDetector(
                                onTap: () async {},
                                child: SvgPicture.asset(
                                  "assets/svg/face_id.svg",
                                  color: kPrimaryColor,
                                  width: 80,
                                ),
                              ))
                            : SizedBox(),
                      ],
                    ),
                  ),
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

bool _loading = false;
