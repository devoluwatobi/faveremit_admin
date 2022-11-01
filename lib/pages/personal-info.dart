import 'package:cached_network_image/cached_network_image.dart';
import 'package:faveremit_admin/services-classes/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';

import '../config/dimensions.dart';
import '../config/styles.dart';
import '../main.dart';
import '../widgets/form-field.dart';
import '../widgets/loading-modal.dart';
import '../widgets/primary-button.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({Key? key}) : super(key: key);

  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

TextEditingController _emailController = TextEditingController();
TextEditingController _phoneController = TextEditingController();
TextEditingController _nameController = TextEditingController();
late PhoneNumber? _phoneNumber;
late String _number;
final _formKey = GlobalKey<FormState>();

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  @override
  void initState() {
    _nameController.text =
        Provider.of<UserData>(context, listen: false).userModel!.user.name;
    _emailController.text =
        Provider.of<UserData>(context, listen: false).userModel!.user.email;
    _phoneController.text = Provider.of<UserData>(context, listen: false)
        .userModel!
        .user
        .phone
        .substring(4);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGeneralWhite,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Personal Information",
          style: GoogleFonts.poppins(color: kTextPrimary),
          overflow: TextOverflow.ellipsis,
        ),
        iconTheme: IconThemeData(color: kTextPrimary),
        backgroundColor: kGeneralWhite,
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          SizedBox(
            height: screenSize.width < tabletBreakPoint
                ? 20
                : screenSize.width * 0.1,
          ),
          Padding(
            padding: kAppHorizontalPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: screenSize.width < tabletBreakPoint
                      ? 20
                      : screenSize.width * 0.05,
                ),
                GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     CupertinoPageRoute(
                    //         builder: (context) => ImageCapturePage()));
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: 117,
                        width: 117,
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: Provider.of<UserData>(context)
                                  .userModel!
                                  .user
                                  .photo
                                  .toString(),
                              height: screenSize.width < tabletBreakPoint
                                  ? 100
                                  : screenSize.width * 0.25,
                              width: screenSize.width < tabletBreakPoint
                                  ? 100
                                  : screenSize.width * 0.25,
                              fit: BoxFit.cover,
                              placeholder: (context, url) {
                                return Container(
                                  alignment: Alignment.center,
                                  height: 100,
                                  width: 100,
                                  color: kPrimaryColor,
                                  child: Text(
                                    getInitials(Provider.of<UserData>(context)
                                            .userModel!
                                            .user
                                            .name)
                                        .toUpperCase(),
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
                                  height: 100,
                                  width: 100,
                                  color: kPrimaryColor,
                                  child: Text(
                                    getInitials(Provider.of<UserData>(context)
                                            .userModel!
                                            .user
                                            .name)
                                        .toUpperCase(),
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
                      Positioned(
                          right: 0,
                          bottom: 0,
                          child: GestureDetector(
                            onTap: () {
                              // Navigator.push(
                              //     context,
                              //     CupertinoPageRoute(
                              //         builder: (context) => ImageCapturePage()));
                            },
                            child: Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                  gradient: kPurpleGradient,
                                  borderRadius: BorderRadius.circular(17)),
                              child: Icon(
                                FlutterRemix.camera_fill,
                                color: kGeneralWhite,
                                size: 16,
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  height: screenSize.width < tabletBreakPoint
                      ? 60
                      : screenSize.width * 0.15,
                ),
                Form(
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
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: _nameController,
                            keyboardType:
                                getKeyboardType(inputType: AppInputType.text),
                            style: kFormTextStyle,
                            validator: fullNameValidator,
                            decoration: appInputDecoration(
                              inputType: AppInputType.text,
                              hint: "FirstName LastName",
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
                            "Phone Number",
                            style: kFormTitleTextStyle,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          InternationalPhoneNumberInput(
                            textStyle: kFormTextStyle,
                            // initialValue: _phoneNumber,
                            inputDecoration: appInputDecoration(
                                inputType: AppInputType.phone,
                                hint: "8X XXX XXXX"),
                            onInputChanged: (PhoneNumber number) {
                              // print(number.phoneNumber);
                              _phoneNumber = number;
                              print(_phoneNumber!.phoneNumber);
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
                            keyboardType:
                                getKeyboardType(inputType: AppInputType.phone),
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
                            keyboardType:
                                getKeyboardType(inputType: AppInputType.email),
                            style: kFormTextStyle,
                            validator: optionalEmailValidator,
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
                    ],
                  ),
                ),
                SizedBox(
                  height: screenSize.width < tabletBreakPoint
                      ? 60
                      : screenSize.width * 0.15,
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
                        "Save Changes",
                        style: kPrimaryButtonTextStyle,
                      ),
                    ],
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      showLoadingModal(context: context, title: "Updating");

                      // if (!_error.any) {
                      //   showInfoModal(
                      //       context: context,
                      //       title: "Success",
                      //       content:
                      //       "Profile Details have been updated successfully");
                      // } else if (!_error.network) {
                      //   showInfoModal(
                      //       context: context,
                      //       title: "Oops",
                      //       content:
                      //       "could not connect to the internet please check network and trt again");
                      // } else {
                      //   showInfoModal(
                      //       context: context,
                      //       title: "Oops",
                      //       content:
                      //       "Verido encountered an error while updating profile details. please try again");
                      // }
                    }
                  },
                ),
                SizedBox(
                  height: screenSize.width < tabletBreakPoint
                      ? 60
                      : screenSize.width * 0.15,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

bool _loading = false;
