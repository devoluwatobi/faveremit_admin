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

class WalletTypeSelectList extends StatefulWidget {
  final bool reverse;

  const WalletTypeSelectList({
    Key? key,
    this.reverse = false,
  }) : super(key: key);

  @override
  _WalletTypeSelectListState createState() => _WalletTypeSelectListState();
}

bool _loading = false;

class _WalletTypeSelectListState extends State<WalletTypeSelectList> {
  @override
  void initState() {
    _searchController.clear();
    _fetchTVList();
    super.initState();
  }

  _fetchTVList() async {
    if (Provider.of<AppData>(context, listen: false).btcTradeData == null) {
      setState(() {
        _loading = true;
      });
      await adminWorker.getBTCTradeData(context: context);
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
                    style: GoogleFonts.roboto(
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
                "Select TV Provider",
                style: GoogleFonts.roboto(color: kTextPrimary),
              ),
            ),
            body: SafeArea(
              bottom: false,
              child: Provider.of<AppData>(context, listen: true).btcTradeData !=
                      null
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
                                onPressed: () {
                                  Navigator.pop(
                                      context,
                                      Provider.of<AppData>(context,
                                              listen: false)
                                          .btcTradeData!
                                          .walletTypes
                                          .where((element) => element.name
                                              .toLowerCase()
                                              .contains(_searchController.text
                                                  .toLowerCase()))
                                          .toList()[index]);
                                },
                                value:
                                    Provider.of<AppData>(context, listen: false)
                                        .btcTradeData!
                                        .walletTypes
                                        .where((element) => element.name
                                            .toLowerCase()
                                            .contains(_searchController.text
                                                .toLowerCase()))
                                        .toList()[index]
                                        .name,
                              );
                            },
                            itemCount: Provider.of<AppData>(context,
                                    listen: false)
                                .btcTradeData!
                                .walletTypes
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
                                    style: GoogleFonts.roboto(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w600,
                                        color: kTextPrimary),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Couldn't successfully fetch the TV Provider list",
                                    style: GoogleFonts.roboto(
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
                                        _fetchTVList();
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
                                    "Fetching TV Providers",
                                    style: GoogleFonts.roboto(
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
