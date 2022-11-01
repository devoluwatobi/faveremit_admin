// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:mypally/models/network-model.dart';
//
// import '../config/styles.dart';
// import '../models/data-bundle-model.dart';
// import '../services-classes/app-worker.dart';
// import '../widgets/primary-button.dart';
// import '../widgets/simple-select-list-option.dart';
//
// TextEditingController _searchController = TextEditingController();
// ProcessError? _response;
// late DataBundleList _dataPackages;
//
// class DataBundleSelectList extends StatefulWidget {
//   final bool reverse;
//   final NetworkService networkService;
//
//   const DataBundleSelectList({
//     Key? key,
//     this.reverse = false,
//     required this.networkService,
//   }) : super(key: key);
//
//   @override
//   _DataBundleSelectListState createState() => _DataBundleSelectListState();
// }
//
// bool _loading = false;
//
// class _DataBundleSelectListState extends State<DataBundleSelectList> {
//   @override
//   void initState() {
//     _searchController.clear();
//     _response = null;
//     _fetchPackageList();
//
//     super.initState();
//   }
//
//   _fetchPackageList() async {
//     if (_response == null) {
//       setState(() {
//         _loading = true;
//       });
//       _response = await pallyWorker.getDataBundleList(
//           context: context, billCode: widget.networkService.dataServiceId);
//       if (!_response!.any) {
//         _dataPackages = _response!.data;
//       }
//       setState(() {
//         _loading = false;
//       });
//     } else {
//       setState(() {
//         _loading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//         child: Scaffold(
//             appBar: AppBar(
//               leading: Container(
//                 alignment: Alignment.centerRight,
//                 child: GestureDetector(
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   child: Text(
//                     "cancel",
//                     style: GoogleFonts.roboto(
//                       color: kPrimaryColor,
//                     ),
//                   ),
//                 ),
//               ),
//               automaticallyImplyLeading: false,
//               centerTitle: true,
//               iconTheme: IconTheme.of(context).copyWith(color: kTextPrimary),
//               backgroundColor: kFormBG,
//               elevation: 0,
//               title: Text(
//                 "Select Data Plan",
//                 style: GoogleFonts.roboto(color: kTextPrimary),
//               ),
//             ),
//             body: SafeArea(
//               bottom: false,
//               child: _response != null && _response!.data != null
//                   ? Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(20.0),
//                           child: CupertinoSearchTextField(
//                             controller: _searchController,
//                             onChanged: (value) {
//                               setState(() {});
//                             },
//                           ),
//                         ),
//                         Expanded(
//                           child: ListView.separated(
//                             reverse: widget.reverse,
//                             shrinkWrap: true,
//                             controller: ModalScrollController.of(context),
//                             physics: const ClampingScrollPhysics(),
//                             itemBuilder: (context, index) {
//                               return SimpleSelectListOption(
//                                   onPressed: () {
//                                     Navigator.pop(
//                                         context,
//                                         _dataPackages.content.varations
//                                             .where((element) => element.name
//                                                 .toLowerCase()
//                                                 .contains(_searchController.text
//                                                     .toLowerCase()))
//                                             .toList()[index]);
//                                   },
//                                   value:
//                                       _dataPackages.content.varations.where((element) => element.name.toLowerCase().contains(_searchController.text.toLowerCase())).toList()[index].name);
//                             },
//                             itemCount: _dataPackages.content.varations
//                                 .where((element) => element.name
//                                     .toLowerCase()
//                                     .contains(
//                                         _searchController.text.toLowerCase()))
//                                 .toList()
//                                 .length,
//                             separatorBuilder:
//                                 (BuildContext context, int index) {
//                               return const Divider();
//                             },
//                           ),
//                         ),
//                       ],
//                     )
//                   : Padding(
//                       padding: const EdgeInsets.all(20),
//                       child: Center(
//                         child: !_loading
//                             ? Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     "Oops!",
//                                     style: GoogleFonts.roboto(
//                                         fontSize: 32,
//                                         fontWeight: FontWeight.w600,
//                                         color: kTextPrimary),
//                                   ),
//                                   const SizedBox(
//                                     height: 20,
//                                   ),
//                                   Text(
//                                     "Couldn't successfully fetch the Data Bundle Plan list",
//                                     style: GoogleFonts.roboto(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w500,
//                                       color: kTextSecondary,
//                                     ),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                   const SizedBox(
//                                     height: 40,
//                                   ),
//                                   PrimaryGradientButton(
//                                       onPressed: () {
//                                         _fetchPackageList();
//                                       },
//                                       title: Text(
//                                         "retry",
//                                         style: kPrimaryButtonTextStyle,
//                                       )),
//                                 ],
//                               )
//                             : Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     "Fetching Data Packages",
//                                     style: GoogleFonts.roboto(
//                                         fontSize: 24,
//                                         fontWeight: FontWeight.w600,
//                                         color: kTextPrimary),
//                                   ),
//                                   const SizedBox(
//                                     height: 20,
//                                   ),
//                                   const CupertinoActivityIndicator(
//                                     radius: 24,
//                                   ),
//                                 ],
//                               ),
//                       ),
//                     ),
//             )));
//   }
// }
