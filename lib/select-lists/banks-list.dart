import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../config/styles.dart';
import '../main.dart';
import '../widgets/primary-button.dart';
import '../widgets/simple-select-list-option.dart';

TextEditingController _searchController = TextEditingController();

class BanksSelectList extends StatefulWidget {
  final bool reverse;

  const BanksSelectList({
    Key? key,
    this.reverse = false,
  }) : super(key: key);

  @override
  _BanksSelectListState createState() => _BanksSelectListState();
}

bool _loading = false;

class _BanksSelectListState extends State<BanksSelectList> {
  @override
  void initState() {
    _searchController.clear();
    _fetchBanks();
    super.initState();
  }

  _fetchBanks() async {
    if (!Provider.of<AppData>(context, listen: false).banksAvailable) {
      setState(() {
        _loading = true;
      });
      await adminWorker.getBankList(context: context);
      setState(() {
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
      });
    }
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
                "Select Bank",
                style: GoogleFonts.mulish(color: kTextPrimary),
              ),
            ),
            body: SafeArea(
              bottom: false,
              child: Provider.of<AppData>(context, listen: true).banksAvailable
                  ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: CupertinoSearchTextField(
                            controller: _searchController,
                            onChanged: (value) {
                              setState(() {});
                            },
                          ),
                        ),
                        Expanded(
                          child: ListView.separated(
                            reverse: widget.reverse,
                            shrinkWrap: true,
                            controller: ModalScrollController.of(context),
                            physics: const ClampingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return SimpleSelectListOption(
                                value:
                                    Provider.of<AppData>(context, listen: false)
                                        .bankListModel!
                                        .data
                                        .where((element) => element.name
                                            .toLowerCase()
                                            .contains(_searchController.text
                                                .toLowerCase()))
                                        .toList()[index]
                                        .name,
                                onPressed: () {
                                  Navigator.pop(
                                    context,
                                    Provider.of<AppData>(context, listen: false)
                                        .bankListModel!
                                        .data
                                        .where((element) => element.name
                                            .toLowerCase()
                                            .contains(_searchController.text
                                                .toLowerCase()))
                                        .toList()[index],
                                  );
                                },
                              );
                            },
                            itemCount: Provider.of<AppData>(context,
                                    listen: false)
                                .bankListModel!
                                .data
                                .where((element) => element.name
                                    .toLowerCase()
                                    .contains(
                                        _searchController.text.toLowerCase()))
                                .toList()
                                .length,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const Divider();
                            },
                          ),
                        ),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: !_loading
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Oops!",
                                    style: GoogleFonts.mulish(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w600,
                                        color: kTextPrimary),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Couldn't sucessfully fetch the bank list",
                                    style: GoogleFonts.mulish(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: kTextSecondary,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  PrimaryButton(
                                      onPressed: () {
                                        _fetchBanks();
                                      },
                                      title: Text(
                                        "retry",
                                        style: kPrimaryButtonTextStyle,
                                      )),
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Fetching Banks",
                                    style: GoogleFonts.mulish(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600,
                                        color: kTextPrimary),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const CupertinoActivityIndicator(
                                    radius: 24,
                                  ),
                                ],
                              ),
                      ),
                    ),
            )));
  }
}
