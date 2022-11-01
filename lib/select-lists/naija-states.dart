import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../config/styles.dart';
import '../widgets/simple-select-list-option.dart';

class AddressSelectList extends StatefulWidget {
  final bool reverse;

  const AddressSelectList({
    Key? key,
    this.reverse = false,
  }) : super(key: key);

  @override
  _AddressSelectListState createState() => _AddressSelectListState();
}

class _AddressSelectListState extends State<AddressSelectList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
            appBar: AppBar(
              leading: Container(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "cancel",
                    style: GoogleFonts.mulish(
                      color: kPrimaryColor,
                    ),
                  ),
                ),
              ),
              automaticallyImplyLeading: false,
              centerTitle: true,
              iconTheme: IconTheme.of(context).copyWith(color: kTextPrimary),
              backgroundColor: kFormBG,
              elevation: 0,
              title: Text(
                "Select Address",
                style: GoogleFonts.mulish(color: kTextPrimary),
              ),
            ),
            body: SafeArea(
              bottom: false,
              child: ListView.separated(
                reverse: widget.reverse,
                shrinkWrap: true,
                controller: ModalScrollController.of(context),
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  return SimpleSelectListOption(value: _naijaStates[index]);
                },
                itemCount: _naijaStates.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                },
              ),
            )));
  }
}

List<String> _naijaStates = [
  "Abia",
  "Adamawa",
  "Akwa Ibom",
  "Anambra",
  "Bauchi",
  "Bayelsa",
  "Benue",
  "Borno",
  "Cross River",
  "Delta",
  "Ebonyi",
  "Edo",
  "Ekiti",
  "Enugu",
  "FCT - Abuja",
  "Gombe",
  "Imo",
  "Jigawa",
  "Kaduna",
  "Kano",
  "Katsina",
  "Kebbi",
  "Kogi",
  "Kwara",
  "Lagos",
  "Nasarawa",
  "Niger",
  "Ogun",
  "Ondo",
  "Osun",
  "Oyo",
  "Plateau",
  "Rivers",
  "Sokoto",
  "Taraba",
  "Yobe",
  "Zamfara"
];
