// import 'package:faveremit_admin/main.dart';
// import 'package:faveremit_admin/models/btc-trade-data.dart';
// import 'package:faveremit_admin/pages/trade-btc-step-2.dart';
// import 'package:faveremit_admin/select-lists/wallet-type.dart';
// import 'package:faveremit_admin/services-classes/functions.dart';
// import 'package:faveremit_admin/services-classes/info-modal.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_remix/flutter_remix.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:provider/provider.dart';
// import 'package:shimmer/shimmer.dart';
//
// import '../config/dimensions.dart';
// import '../config/styles.dart';
// import '../services-classes/dx-worker.dart';
// import '../widgets/form-field.dart';
// import '../widgets/primary-button.dart';
// import '../widgets/show-option-modal.dart';
//
// TextEditingController _amountController = TextEditingController();
// TextEditingController _btcController = TextEditingController();
// bool _updatedRate = false;
//
// WalletType? _walletType;
//
// class TradeBTCStep1 extends StatefulWidget {
//   const TradeBTCStep1({Key? key}) : super(key: key);
//
//   @override
//   _TradeBTCStep1State createState() => _TradeBTCStep1State();
// }
//
// class _TradeBTCStep1State extends State<TradeBTCStep1> {
//   @override
//   void initState() {
//     _updatedRate = false;
//     _walletType = null;
//     _amountController.clear();
//     _btcController.text = "0.00";
//     _fetchTradeData();
//     super.initState();
//   }
//
//   _fetchTradeData() async {
//     ProcessError error = await dxWorker.getBTCTradeData(context: context);
//     if (error.any) {
//       dynamic rez = await showSingleOptionPopup(
//           context: context,
//           title: "Oops!",
//           body:
//               "Couldn't fetch page resources. Please check your internet connection and try again.",
//           actionTitle: "retry",
//           isDestructive: false,
//           onPressed: () {
//             Navigator.pop(context, true);
//             _fetchTradeData();
//           });
//       if (rez == null || rez == false) {
//         Navigator.pop(context);
//       }
//     } else {
//       setState(() {
//         _updatedRate = true;
//       });
//     }
//   }
//
//   final _formKey = GlobalKey<FormState>();
//   @override
//   Widget build(BuildContext context) {
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: appSystemLightTheme,
//       child: Scaffold(
//         backgroundColor: kGeneralWhite,
//         appBar: AppBar(
//           automaticallyImplyLeading: true,
//           centerTitle: true,
//           title: Text(
//             "Trade BTC",
//             style: GoogleFonts.poppins(color: kTextPrimary),
//           ),
//           backgroundColor: kGeneralWhite,
//           elevation: 0,
//           iconTheme: IconTheme.of(context).copyWith(color: kTextPrimary),
//           foregroundColor: kGeneralWhite,
//         ),
//         body: SafeArea(
//           child: ListView(
//             physics: BouncingScrollPhysics(),
//             children: [
//               const SizedBox(
//                 height: 30,
//               ),
//               Padding(
//                 padding: kAppHorizontalPadding,
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: kPrimaryColor,
//                           borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(3),
//                             bottomLeft: Radius.circular(3),
//                           ),
//                         ),
//                         height: 6,
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 3,
//                     ),
//                     Expanded(
//                       child: Container(
//                         color: Color(0xFFE5E5EA),
//                         height: 6,
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 3,
//                     ),
//                     Expanded(
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Color(0xFFE5E5EA),
//                           borderRadius: const BorderRadius.only(
//                             topRight: Radius.circular(3),
//                             bottomRight: Radius.circular(3),
//                           ),
//                         ),
//                         height: 6,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(
//                 height: 40,
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(
//                     horizontal: screenSize.width < tabletBreakPoint
//                         ? 20
//                         : screenSize.width * 0.04),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Transaction Details",
//                             style: kSubTitleStyle,
//                             textAlign: TextAlign.left,
//                           ),
//                           SizedBox(
//                             height: screenSize.width < tabletBreakPoint
//                                 ? 10
//                                 : screenSize.width * 0.026,
//                           ),
//                           Text(
//                             "Provide the amount and wallet details of the transaction to be performed.",
//                             style: kSubTextStyle,
//                           ),
//                           SizedBox(
//                             height: screenSize.width < tabletBreakPoint
//                                 ? 40
//                                 : screenSize.width * 0.1,
//                           ),
//                         ],
//                       ),
//                       Provider.of<AppData>(context).btcTradeData == null ||
//                               !_updatedRate
//                           ? _PageShimmer()
//                           : Column(
//                               children: [
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       "Wallet Type",
//                                       style: kFormTitleTextStyle,
//                                     ),
//                                     const SizedBox(
//                                       height: 5,
//                                     ),
//                                     GestureDetector(
//                                       onTap: () async {
//                                         dynamic temp =
//                                             await showCupertinoModalBottomSheet(
//                                                 context: context,
//                                                 builder: (context) =>
//                                                     const WalletTypeSelectList());
//                                         if (temp != null) {
//                                           _walletType = temp;
//                                         }
//                                         setState(() {});
//                                       },
//                                       child: Container(
//                                         width: double.infinity,
//                                         padding: EdgeInsets.symmetric(
//                                             horizontal: screenSize.width <
//                                                     tabletBreakPoint
//                                                 ? 16
//                                                 : 24,
//                                             vertical: screenSize.width <
//                                                     tabletBreakPoint
//                                                 ? 16
//                                                 : 24),
//                                         decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                           border: Border.all(
//                                               color: const Color(0xFFC9CCD3),
//                                               width: 0,
//                                               style: BorderStyle.solid),
//                                           color: kFormBG,
//                                         ),
//                                         child: Row(
//                                           children: [
//                                             Expanded(
//                                               child: Text(
//                                                   _walletType == null
//                                                       ? "Choose wallet type"
//                                                       : _walletType!.name,
//                                                   style: GoogleFonts.mulish(
//                                                     fontSize: screenSize.width <
//                                                             tabletBreakPoint
//                                                         ? 16
//                                                         : 18,
//                                                     fontWeight: FontWeight.w600,
//                                                     color: _walletType == null
//                                                         ? kInactive
//                                                         : kTextPrimary,
//                                                   )),
//                                             ),
//                                             SizedBox(
//                                               width: 20,
//                                             ),
//                                             Icon(
//                                               FlutterRemix.arrow_down_s_fill,
//                                               color: kTextGray,
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height:
//                                           screenSize.width < tabletBreakPoint
//                                               ? 24
//                                               : 30,
//                                     )
//                                   ],
//                                 ),
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       "Amount in USD (\$)",
//                                       style: kFormTitleTextStyle,
//                                     ),
//                                     const SizedBox(
//                                       height: 5,
//                                     ),
//                                     TextFormField(
//                                       keyboardType: getKeyboardType(
//                                           inputType: AppInputType.number),
//                                       style: kFormTextStyle,
//                                       controller: _amountController,
//                                       onChanged: (usd) {
//                                         _btcController.text =
//                                             isNumeric(usd.trim())
//                                                 ? (double.parse(usd.trim()) /
//                                                         Provider.of<AppData>(
//                                                                 context,
//                                                                 listen: false)
//                                                             .btcTradeData!
//                                                             .usdValue)
//                                                     .toPrecision(10)
//                                                     .toString()
//                                                 : "0.00";
//                                         setState(() {});
//                                       },
//                                       validator: amountValidator(minimum: 5),
//                                       decoration: appInputDecoration(
//                                           inputType: AppInputType.number,
//                                           hint: "enter amount in USD"),
//                                     ),
//                                     SizedBox(
//                                       height:
//                                           screenSize.width < tabletBreakPoint
//                                               ? 24
//                                               : 30,
//                                     )
//                                   ],
//                                 ),
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       "Bitcoin Amount",
//                                       style: kFormTitleTextStyle,
//                                     ),
//                                     const SizedBox(
//                                       height: 5,
//                                     ),
//                                     TextFormField(
//                                       readOnly: true,
//                                       keyboardType: getKeyboardType(
//                                           inputType: AppInputType.number),
//                                       style: kFormTextStyle,
//                                       controller: _btcController,
//                                       decoration: InputDecoration(
//                                         hintMaxLines: 1,
//                                         suffix: GestureDetector(
//                                           onTap: () {
//                                             copyToClipboard(
//                                                 copyText: _btcController.text,
//                                                 context: context);
//                                           },
//                                           child: Row(
//                                             mainAxisSize: MainAxisSize.min,
//                                             children: [
//                                               SizedBox(
//                                                 width: 10,
//                                               ),
//                                               Text(
//                                                 "copy",
//                                                 style: GoogleFonts.poppins(
//                                                   color: kPrimaryColor,
//                                                   fontWeight: FontWeight.w600,
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 width: 4,
//                                               ),
//                                               Icon(
//                                                 FlutterRemix.file_copy_line,
//                                                 color: kPrimaryColor,
//                                               )
//                                             ],
//                                           ),
//                                         ),
//                                         fillColor: kFormBG,
//                                         filled: true,
//                                         errorBorder: OutlineInputBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(8),
//                                           borderSide: BorderSide(
//                                               color: kRed,
//                                               width: 1,
//                                               style: BorderStyle.solid),
//                                         ),
//                                         focusedErrorBorder: OutlineInputBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(8),
//                                           borderSide: BorderSide(
//                                               color: kRed,
//                                               width: 1,
//                                               style: BorderStyle.solid),
//                                         ),
//                                         focusedBorder: OutlineInputBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(8),
//                                           borderSide: BorderSide.none,
//                                         ),
//                                         contentPadding: EdgeInsets.symmetric(
//                                             horizontal: screenSize.width <
//                                                     tabletBreakPoint
//                                                 ? 16
//                                                 : 24,
//                                             vertical: screenSize.width <
//                                                     tabletBreakPoint
//                                                 ? 16
//                                                 : 24),
//                                         border: OutlineInputBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(8),
//                                           borderSide: BorderSide.none,
//                                         ),
//                                         hintStyle: GoogleFonts.poppins(
//                                           fontSize: screenSize.width <
//                                                   tabletBreakPoint
//                                               ? 16
//                                               : 18,
//                                           fontWeight: FontWeight.w600,
//                                           color: kInactive,
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height:
//                                           screenSize.width < tabletBreakPoint
//                                               ? 24
//                                               : 30,
//                                     )
//                                   ],
//                                 ),
//                                 const SizedBox(
//                                   height: 24,
//                                 ),
//                                 Column(
//                                   children: [
//                                     Text(
//                                       "Amount you will receive",
//                                       style: GoogleFonts.poppins(
//                                           fontSize: 14, color: kTextGray),
//                                     ),
//                                     SizedBox(
//                                       height: 5,
//                                     ),
//                                     Text(
//                                       "₦${!isNumeric(_amountController.text.trim()) ? "0.00" : addCommas((Provider.of<AppData>(context).btcTradeData!.usdRate * double.parse(_amountController.text.trim())).toString())}",
//                                       style: GoogleFonts.poppins(
//                                           fontSize: 32,
//                                           color: kPrimaryColor,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(
//                                   height: 60,
//                                 ),
//                                 PrimaryGradientButton(
//                                   title: Text(
//                                     "Continue",
//                                     style: kPrimaryButtonTextStyle,
//                                   ),
//                                   onPressed: () async {
//                                     if (_formKey.currentState!.validate()) {
//                                       if (_walletType != null) {
//                                         Navigator.pushReplacement(
//                                             context,
//                                             CupertinoPageRoute(
//                                                 builder: (context) =>
//                                                     TradeBTCStep2(
//                                                       usdAmount: double.parse(
//                                                           _amountController
//                                                               .text),
//                                                       walletTypeID:
//                                                           _walletType!.id,
//                                                     )));
//                                       } else {
//                                         showInfoModal(
//                                             context: context,
//                                             title: "Hey Boss!",
//                                             content:
//                                                 "Please select wallet type to complete transaction");
//                                       }
//                                     }
//                                   },
//                                 ),
//                               ],
//                             ),
//                       const SizedBox(
//                         height: 40,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 40,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// //Page Shimmer
// class _PageShimmer extends StatelessWidget {
//   const _PageShimmer({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey.withOpacity(0.3),
//       highlightColor: Colors.grey.withOpacity(0.1),
//       child: Column(
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Wallet Type",
//                 style: kFormTitleTextStyle,
//               ),
//               const SizedBox(
//                 height: 5,
//               ),
//               GestureDetector(
//                 onTap: () async {},
//                 child: Container(
//                   width: double.infinity,
//                   padding: EdgeInsets.symmetric(
//                       horizontal: screenSize.width < tabletBreakPoint ? 16 : 24,
//                       vertical: screenSize.width < tabletBreakPoint ? 16 : 24),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(
//                         color: const Color(0xFFC9CCD3),
//                         width: 0,
//                         style: BorderStyle.solid),
//                     color: kFormBG,
//                   ),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: Text("Choose wallet type",
//                             style: GoogleFonts.mulish(
//                               fontSize:
//                                   screenSize.width < tabletBreakPoint ? 16 : 18,
//                               fontWeight: FontWeight.w600,
//                               color: kTextPrimary,
//                             )),
//                       ),
//                       SizedBox(
//                         width: 20,
//                       ),
//                       Icon(
//                         FlutterRemix.arrow_down_s_fill,
//                         color: kTextGray,
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: screenSize.width < tabletBreakPoint ? 24 : 30,
//               )
//             ],
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Amount in USD (\$)",
//                 style: kFormTitleTextStyle,
//               ),
//               const SizedBox(
//                 height: 5,
//               ),
//               TextFormField(
//                 keyboardType: getKeyboardType(inputType: AppInputType.number),
//                 style: kFormTextStyle,
//                 controller: _amountController,
//                 validator: amountValidator(),
//                 decoration: appInputDecoration(
//                     inputType: AppInputType.number,
//                     hint: "enter amount in USD"),
//               ),
//               SizedBox(
//                 height: screenSize.width < tabletBreakPoint ? 24 : 30,
//               )
//             ],
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "BTC Amount",
//                 style: kFormTitleTextStyle,
//               ),
//               const SizedBox(
//                 height: 5,
//               ),
//               TextFormField(
//                 keyboardType: getKeyboardType(inputType: AppInputType.number),
//                 style: kFormTextStyle,
//                 controller: _amountController,
//                 validator: amountValidator(),
//                 decoration: appInputDecoration(
//                     inputType: AppInputType.number,
//                     hint: "enter amount in USD"),
//               ),
//               SizedBox(
//                 height: screenSize.width < tabletBreakPoint ? 24 : 30,
//               )
//             ],
//           ),
//           const SizedBox(
//             height: 24,
//           ),
//           Column(
//             children: [
//               Text(
//                 "Amount you will receive",
//                 style: GoogleFonts.poppins(fontSize: 14, color: kTextGray),
//               ),
//               SizedBox(
//                 height: 5,
//               ),
//               Text(
//                 "₦540,000.00",
//                 style: GoogleFonts.poppins(
//                     fontSize: 32,
//                     color: kPrimaryColor,
//                     fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//           const SizedBox(
//             height: 60,
//           ),
//           PrimaryGradientButton(
//             title: Text(
//               "Continue",
//               style: kPrimaryButtonTextStyle,
//             ),
//             onPressed: () async {},
//           ),
//         ],
//       ),
//     );
//   }
// }
