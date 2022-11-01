import 'package:faveremit_admin/config/dimensions.dart';
import 'package:faveremit_admin/config/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class BarcodePage extends StatefulWidget {
  const BarcodePage({Key? key}) : super(key: key);

  @override
  _BarcodePageState createState() => _BarcodePageState();
}

class _BarcodePageState extends State<BarcodePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        foregroundColor: kFormBG,
        backgroundColor: kFormBG,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 5,
              width: screenSize.width * 0.4,
              decoration: BoxDecoration(
                color: kTextSecondary,
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: kAppHorizontalPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 40,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 5,
                    color: kPrimaryColor,
                  )),
              child: QrImage(
                data:
                    "ewrdftgvhbjnklojknbvfyrdtyfguiewrdftgvhbjnklojknbvfyrdtyfguiwrdftgvhbjnklojknbvfyrdtyfgui",
                version: QrVersions.auto,
                size: screenSize.width - 100,
              ),
            )
          ],
        ),
      ),
    );
  }
}
