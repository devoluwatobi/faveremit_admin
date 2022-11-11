import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Naira extends StatelessWidget {
  final Color color;
  final double size;
  const Naira({Key? key, this.color = const Color(0xFF2A3342), this.size = 13})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      "assets/svg/naira.svg",
      color: color,
      height: size,
    );
  }
}
