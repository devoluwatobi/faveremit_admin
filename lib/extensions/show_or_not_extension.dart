import 'package:flutter/material.dart';

extension ShowOrNot on Widget {
  Widget? showOrNull(bool isShow) => isShow ? this : null;

  Widget showOrHide(bool isShow) => isShow ? this : const SizedBox();
}
