import 'package:faveremit_admin/config/dimensions.dart';
import 'package:faveremit_admin/config/styles.dart';
import 'package:faveremit_admin/widgets/giftcard_category_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/giftcard-country-model.dart';

class CategoriesListPage extends StatefulWidget {
  final List<ReceiptCategory> categories;
  const CategoriesListPage({Key? key, required this.categories})
      : super(key: key);

  @override
  _CategoriesListPageState createState() => _CategoriesListPageState();
}

class _CategoriesListPageState extends State<CategoriesListPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: kFormBG,
          foregroundColor: kFormBG,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              FlutterRemix.arrow_down_s_fill,
              color: kTextPrimary,
            ),
          ),
          title: Text(
            "Receipt Categories",
            style: GoogleFonts.poppins(color: kTextPrimary),
          ),
        ),
        body: ListView(
          padding: kAppHorizontalPadding.copyWith(top: 20),
          children: List.generate(
              widget.categories.length,
              (index) =>
                  SingleGiftCardCategory(category: widget.categories[index])),
        ),
      ),
    );
  }
}
