import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dimensions.dart';

Color kGeneralWhite = Color(0xFFFFFFFF);
Color kBackground = Color(0xFFF7F8F9);
Color kDarkBG = Color(0xFF2A3342);
Color kPrimaryColor = Color(0xFF1EB0D9);
Color kPrimaryLight = Color(0xFFE3F2F7);
Color kPrimaryDark = Color(0xFF157B98);
Color kTextPrimary = Color(0xFF000000);
Color kTextSecondary = Color(0xFF333333);
Color kTextGray = Color(0xFF60708F);
Color kInactive = Color(0xFF8896AB);
Color kMessageBG = Color(0xFFEFEFEF);

Color kDXLight = Color(0xFFECEEFB);

Color kBlue = Color(0xFF007AFF);
Color kBlueLight = Color(0xFFE6FAFF);
Color kGreen = Color(0xFF34C759);
Color kGreenLight = Color(0xFFECFBEC);
Color kRed = Color(0xFFFF3B30);
Color kRedLight = Color(0xFFFFF0F4);
Color kYellow = Color(0xFFFF9500);
Color kIndigo = Color(0xFF5856D6);
Color kPurple = Color(0xFFDB0FA2);
Color kIndigoLight = Color(0xFFE6EDFF);
Color kFormBG = Color(0xFFF2F2F7);
Gradient kBlueGradient = LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft, // 10% of the width, so there are ten blinds.
  colors: <Color>[
    Color(0xFF0985FA),
    Color(0xFF094AFA),
  ],
);
Gradient kYellowGradient = LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft, // 10% of the width, so there are ten blinds.
  colors: <Color>[
    Color(0xFFFEC810),
    Color(0xFFF8981D),
  ],
);
Gradient kGreenGradient = LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft, // 10% of the width, so there are ten blinds.
  colors: <Color>[
    Color(0xFF48D27E),
    Color(0xFF05BA4C),
  ],
);
Gradient kPurpleGradient = LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft, // 10% of the width, so there are ten blinds.
  colors: <Color>[
    Color(0xFFFF6FD7),
    Color(0xFFDB0FA2),
  ],
);
Gradient kWineGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight, // 10% of the width, so there are ten blinds.
  colors: <Color>[
    Color(0xFFE42C66),
    Color(0xFFF55B46),
  ],
);

TextStyle authSubTextStyle = GoogleFonts.poppins(
  color: kTextPrimary,
  fontSize: screenSize.width < tabletBreakPoint ? 18 : 24,
  fontWeight: FontWeight.w600,
);
TextStyle primaryOptionTextStyle = GoogleFonts.poppins(
  color: kTextPrimary,
  fontSize: screenSize.width < tabletBreakPoint ? 18 : 32,
  fontWeight: FontWeight.w600,
);
TextStyle trxTitleTextStyle = GoogleFonts.poppins(
  color: kTextPrimary,
  fontSize: screenSize.width < tabletBreakPoint ? 16 : 26,
  fontWeight: FontWeight.w500,
);
TextStyle trxAmountTextStyle = GoogleFonts.poppins(
  color: kPrimaryColor,
  fontSize: screenSize.width < tabletBreakPoint ? 18 : 32,
  fontWeight: FontWeight.w600,
);
TextStyle trxDateTextStyle = GoogleFonts.poppins(
  color: kTextGray,
  fontSize: screenSize.width < tabletBreakPoint ? 13 : 16,
);
TextStyle trxStatusTextStyle = GoogleFonts.poppins(
  color: kTextGray,
  fontSize: screenSize.width < tabletBreakPoint ? 13 : 16,
);

TextStyle primaryOptionSubTextStyle = GoogleFonts.poppins(
  color: kTextSecondary,
  fontSize: screenSize.width < tabletBreakPoint ? 14 : 20,
);

TextStyle kFormTextStyle = GoogleFonts.poppins(
    color: kTextPrimary,
    fontWeight: FontWeight.w600,
    fontSize: screenSize.width < tabletBreakPoint ? 14 : 18);

TextStyle kFormTitleTextStyle = GoogleFonts.poppins(
    color: kTextSecondary,
    fontWeight: FontWeight.w600,
    fontSize: screenSize.width < tabletBreakPoint ? 14 : 18);

TextStyle kPrimaryButtonTextStyle = GoogleFonts.poppins(
    color: kGeneralWhite,
    fontWeight: FontWeight.w600,
    fontSize: screenSize.width < tabletBreakPoint ? 16 : 20);
TextStyle kSecondaryButtonTextStyle = GoogleFonts.poppins(
    color: kPrimaryColor,
    fontWeight: FontWeight.w600,
    fontSize: screenSize.width < tabletBreakPoint ? 16 : 20);

TextStyle kTertiaryButtonTextStyle = GoogleFonts.poppins(
    color: kTextGray,
    fontWeight: FontWeight.w600,
    fontSize: screenSize.width < tabletBreakPoint ? 16 : 20);

TextStyle kSubTitleTextStyle = GoogleFonts.poppins(
    color: kTextSecondary,
    fontWeight: FontWeight.w600,
    fontSize: screenSize.width < tabletBreakPoint ? 16 : 20);
TextStyle kWhiteSubTitleTextStyle = GoogleFonts.poppins(
    color: kGeneralWhite,
    fontWeight: FontWeight.w600,
    fontSize: screenSize.width < tabletBreakPoint ? 16 : 20);

TextStyle kWalletBalTextStyle = GoogleFonts.poppins(
    color: kGeneralWhite,
    fontWeight: FontWeight.w600,
    fontSize: screenSize.width < tabletBreakPoint ? 28 : 44);

TextStyle kAuthSubText2Style = GoogleFonts.poppins(
    color: kTextSecondary,
    fontSize: screenSize.width < tabletBreakPoint ? 14 : 18);

SystemUiOverlayStyle appSystemLightTheme = SystemUiOverlayStyle.light.copyWith(
    systemNavigationBarColor: kBackground,
    systemNavigationBarIconBrightness: Brightness.dark);

SystemUiOverlayStyle appSystemDarkTheme = SystemUiOverlayStyle.dark.copyWith(
    systemNavigationBarColor: kTextPrimary,
    systemNavigationBarIconBrightness: Brightness.light);

SystemUiOverlayStyle appSystemPrimaryTheme = SystemUiOverlayStyle.light
    .copyWith(
        systemNavigationBarColor: kPrimaryColor,
        systemNavigationBarIconBrightness: Brightness.light);

TextStyle kSubTitleStyle = GoogleFonts.poppins(
  color: kTextGray,
  fontSize: screenSize.width < tabletBreakPoint ? 20 : 32,
  fontWeight: FontWeight.w600,
);
TextStyle kSubTextStyle = GoogleFonts.poppins(
  color: kTextGray,
  fontSize: screenSize.width < tabletBreakPoint ? 13 : 16,
);
TextStyle kTitleStyle = GoogleFonts.poppins(
  color: kTextPrimary,
  fontSize: screenSize.width < tabletBreakPoint ? 20 : 32,
  fontWeight: FontWeight.w600,
);

Gradient appGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [
      kPrimaryColor,
      kPrimaryDark,
    ]);
