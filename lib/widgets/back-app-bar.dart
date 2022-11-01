import 'package:faveremit_admin/config/styles.dart';
import 'package:flutter/cupertino.dart';

import '../config/dimensions.dart';

PreferredSize buildAppBackBar({required BuildContext context}) {
  return PreferredSize(
    preferredSize: Size(double.infinity, 56 + statusBarHeight),
    child: Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: statusBarHeight),
      child: Container(
        alignment: Alignment.centerLeft,
        height: 56,
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: kFormBG,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  CupertinoIcons.arrow_left,
                  color: kPrimaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
