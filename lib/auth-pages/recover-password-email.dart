import 'package:faveremit_admin/auth-pages/password-reset-code-page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../config/dimensions.dart';
import '../config/styles.dart';
import '../main.dart';
import '../services-classes/app-worker.dart';
import '../services-classes/info-modal.dart';
import '../widgets/back-app-bar.dart';
import '../widgets/form-field.dart';
import '../widgets/primary-button.dart';
import '../widgets/show-snackbar.dart';

class RecoverPasswordPage extends StatefulWidget {
  const RecoverPasswordPage({Key? key}) : super(key: key);

  @override
  _RecoverPasswordPageState createState() => _RecoverPasswordPageState();
}

TextEditingController _phoneController = TextEditingController();
String initialCountry = 'NG';
late PhoneNumber? _phoneNumber;
final _formKey = GlobalKey<FormState>();
// String _phone = '';

class _RecoverPasswordPageState extends State<RecoverPasswordPage> {
  @override
  void initState() {
    _phoneController.clear();
    _phoneNumber = PhoneNumber(isoCode: "NG");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: appSystemLightTheme,
        child: Scaffold(
            backgroundColor: kGeneralWhite,
            appBar: buildAppBackBar(context: context),
            body: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                SizedBox(
                  height: 40,
                ),
                Column(
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
                      "Recover Password",
                      style: authSubTextStyle,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenSize.width < tabletBreakPoint
                              ? 40
                              : screenSize.width * 0.08),
                      child: Text(
                        "Enter your phone number to recover your  forgotten password",
                        textAlign: TextAlign.center,
                        style: kAuthSubText2Style,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                    ),
                  ],
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
                            SizedBox(
                              height: 5,
                            ),
                            InternationalPhoneNumberInput(
                              textStyle: kFormTextStyle,
                              initialValue: _phoneNumber,
                              inputDecoration: appInputDecoration(
                                  inputType: AppInputType.phone,
                                  hint: "8X XXX XXXX"),
                              onInputChanged: (PhoneNumber number) {
                                _phoneNumber = number;
                                print(number.phoneNumber);
                              },
                              onInputValidated: (bool value) {
                                print(value);
                              },
                              countries: ["NG"],
                              selectorConfig: SelectorConfig(
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
                        SizedBox(
                          height: 40,
                        ),
                        PrimaryButton(
                          title: Text(
                            "Send Recovery Text",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: kPrimaryButtonTextStyle,
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              ProcessError _error =
                                  await adminWorker.sendPasswordResetOTP(
                                      phone: _phoneNumber!.phoneNumber!,
                                      context: context);
                              if (!_error.any) {
                                showSnackBar(
                                    context: context,
                                    content: "OTP Sent successfully");
                                Navigator.pushReplacement(context,
                                    CupertinoPageRoute(builder: (context) {
                                  return PasswordResetCodePage(
                                      phoneNumber: _phoneNumber!.phoneNumber!);
                                }));
                              } else {
                                showInfoModal(
                                    context: context,
                                    title: "Failed",
                                    content: _error.network
                                        ? "unable to connect to the internet, please check your internet and try again"
                                        : _error.details
                                            ? "phone number is not registered on Faveremit, please check and try again"
                                            : "unable to complete your request at please try again");
                              }
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
