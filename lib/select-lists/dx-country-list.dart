import 'package:faveremit_admin/services-classes/app-worker.dart';
import 'package:faveremit_admin/services-classes/info-modal.dart';
import 'package:faveremit_admin/widgets/loading-modal.dart';
import 'package:faveremit_admin/widgets/show-option-modal.dart';
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

class CountrySelectList extends StatefulWidget {
  final bool reverse;
  final int giftcardID;

  const CountrySelectList({
    Key? key,
    this.reverse = false,
    required this.giftcardID,
  }) : super(key: key);

  @override
  _CountrySelectListState createState() => _CountrySelectListState();
}

bool _loading = false;

class _CountrySelectListState extends State<CountrySelectList> {
  @override
  void initState() {
    _searchController.clear();
    _fetchCountryList();
    super.initState();
  }

  _fetchCountryList() async {
    if (Provider.of<AppData>(context, listen: false).dxCountries == null) {
      setState(() {
        _loading = true;
      });
      await adminWorker.getCountries(context: context);
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
                "Select Country",
                style: GoogleFonts.roboto(color: kTextPrimary),
              ),
            ),
            body: SafeArea(
              bottom: false,
              child: Provider.of<AppData>(context, listen: true).dxCountries !=
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
                              return ItemSelectListOption(
                                onPressed: () async {
                                  bool? _proceed = await showOptionPopup(
                                      context: context,
                                      title: "Please Confirm",
                                      body:
                                          "Are you sure you want to add this giftcard country ?",
                                      actionTitle: "I'm Sure",
                                      isDestructive: true);
                                  if (_proceed != null && _proceed) {
                                    showLoadingModal(
                                        context: context,
                                        title: "Creating Country");
                                    ProcessError _error =
                                        await adminWorker.createGiftcardCountry(
                                            countryId: Provider.of<AppData>(
                                                    context,
                                                    listen: false)
                                                .dxCountries!
                                                .where((element) => element.name
                                                    .toLowerCase()
                                                    .contains(_searchController
                                                        .text
                                                        .toLowerCase()))
                                                .toList()[index]
                                                .id,
                                            giftCardId: widget.giftcardID,
                                            context: context);
                                    Navigator.pop(context);
                                    if (_error.any) {
                                      showErrorResponse(
                                          context: context, error: _error);
                                    } else {
                                      Navigator.pop(context);
                                      showInfoModal(
                                          context: context,
                                          title: "Success",
                                          content:
                                              "Giftcard country  cfeated successfully");
                                    }
                                    // Navigator.pop(
                                    //     context,
                                    //     Provider.of<AppData>(context,
                                    //             listen: false)
                                    //         .dxCountries!
                                    //         .where((element) => element.name
                                    //             .toLowerCase()
                                    //             .contains(_searchController.text
                                    //                 .toLowerCase()))
                                    //         .toList()[index]);
                                  }
                                },
                                value:
                                    Provider.of<AppData>(context, listen: false)
                                        .dxCountries!
                                        .where((element) => element.name
                                            .toLowerCase()
                                            .contains(_searchController.text
                                                .toLowerCase()))
                                        .toList()[index]
                                        .name,
                                imageUrl:
                                    Provider.of<AppData>(context, listen: false)
                                        .dxCountries!
                                        .where((element) => element.name
                                            .toLowerCase()
                                            .contains(_searchController.text
                                                .toLowerCase()))
                                        .toList()[index]
                                        .image,
                              );
                            },
                            itemCount: Provider.of<AppData>(context,
                                    listen: false)
                                .dxCountries!
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
                                    "Couldn't successfully fetch the country list",
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
                                        _fetchCountryList();
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
                                    "Fetching Countries",
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
