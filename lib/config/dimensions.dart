import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

late Size screenSize;

double tabletBreakPoint = 700;

late double statusBarHeight;

late EdgeInsets kAppHorizontalPadding = EdgeInsets.symmetric(
    horizontal:
        screenSize.width < tabletBreakPoint ? 20 : screenSize.width * 0.04);
