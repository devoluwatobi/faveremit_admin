// import 'dart:io' as io;
//
// import 'package:faveremit_admin/pages/barcode-page.dart';
// import 'package:faveremit_admin/pages/trade-btc-step-3.dart';
// import 'package:faveremit_admin/widgets/loading-modal.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_remix/flutter_remix.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:provider/provider.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:shimmer/shimmer.dart';
//
// import '../config/dimensions.dart';
// import '../config/styles.dart';
// import '../main.dart';
// import '../services-classes/dx-worker.dart';
// import '../services-classes/functions.dart';
// import '../services-classes/info-modal.dart';
// import '../widgets/form-field.dart';
// import '../widgets/primary-button.dart';
// import '../widgets/show-option-modal.dart';
//
// bool _fetchedAddress = false;
// Map? _btcAddress;
// io.File? _paymentProofFile;
// Widget? _paymentProof;
//
// TextEditingController _btcController = TextEditingController();
//
// class TradeBTCStep2 extends StatefulWidget {
//   final int walletTypeID;
//   final double usdAmount;
//   const TradeBTCStep2({
//     Key? key,
//     required this.walletTypeID,
//     required this.usdAmount,
//   }) : super(key: key);
//
//   @override
//   _TradeBTCStep2State createState() => _TradeBTCStep2State();
// }
//
// class _TradeBTCStep2State extends State<TradeBTCStep2> {
//   _fetchBTCAddress() async {
//     ProcessError _error = await dxWorker.getBTCAddress(context: context);
//     if (_error.any) {
//       dynamic rez = await showSingleOptionPopup(
//           context: context,
//           title: "Oops!",
//           body:
//               "Couldn't fetch page resources. Please check your internet connection and try again.",
//           actionTitle: "retry",
//           isDestructive: false,
//           onPressed: () {
//             Navigator.pop(context, true);
//             _fetchBTCAddress;
//           });
//       if (rez == null || rez == false) {
//         Navigator.pop(context);
//       }
//     } else {
//       setState(() {
//         _btcAddress = _error.data;
//         _fetchedAddress = true;
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     _btcController.text = (widget.usdAmount /
//             Provider.of<AppData>(context, listen: false).btcTradeData!.usdValue)
//         .toPrecision(10)
//         .toString();
//     _btcAddress = null;
//     _paymentProofFile = null;
//     _paymentProof = null;
//     _fetchBTCAddress();
//     super.initState();
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
//                         color: kPrimaryColor,
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
//                             "Payment Details",
//                             style: kSubTitleStyle,
//                             textAlign: TextAlign.left,
//                           ),
//                           SizedBox(
//                             height: screenSize.width < tabletBreakPoint
//                                 ? 10
//                                 : screenSize.width * 0.026,
//                           ),
//                           Text(
//                             "Make payment to the provided wallet address and provide payment proof to continue.",
//                             style: kSubTextStyle,
//                           ),
//                           SizedBox(
//                             height: screenSize.width < tabletBreakPoint
//                                 ? 40
//                                 : screenSize.width * 0.1,
//                           ),
//                         ],
//                       ),
//                       _fetchedAddress && _btcAddress != null
//                           ? Column(
//                               children: [
//                                 GestureDetector(
//                                   onTap: () {
//                                     showCupertinoModalBottomSheet(
//                                         barrierColor:
//                                             Colors.black.withOpacity(0.8),
//                                         context: context,
//                                         builder: (context) => BarcodePage());
//                                   },
//                                   child: Container(
//                                     margin: EdgeInsets.only(bottom: 40),
//                                     width: screenSize.width * 0.7,
//                                     height: screenSize.width * 0.7,
//                                     decoration: BoxDecoration(
//                                       border: Border.all(
//                                         color: kPrimaryColor,
//                                         width: 2,
//                                         style: BorderStyle.solid,
//                                       ),
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     child: QrImage(
//                                       data: _btcAddress!["address"],
//                                       version: QrVersions.auto,
//                                       size: 110.0,
//                                     ),
//                                   ),
//                                 ),
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     TextFormField(
//                                       readOnly: true,
//                                       keyboardType: getKeyboardType(
//                                           inputType: AppInputType.number),
//                                       style: kFormTextStyle,
//                                       initialValue: _btcAddress!["address"],
//                                       validator: amountValidator(),
//                                       decoration: InputDecoration(
//                                         hintMaxLines: 1,
//                                         suffix: GestureDetector(
//                                           onTap: () {
//                                             copyToClipboard(
//                                                 copyText:
//                                                     _btcAddress!["address"],
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
//                                 // Column(
//                                 //   crossAxisAlignment: CrossAxisAlignment.start,
//                                 //   children: [
//                                 //     Text(
//                                 //       "Bitcoin Amount",
//                                 //       style: kFormTitleTextStyle,
//                                 //     ),
//                                 //     const SizedBox(
//                                 //       height: 5,
//                                 //     ),
//                                 //     TextFormField(
//                                 //       readOnly: true,
//                                 //       keyboardType: getKeyboardType(
//                                 //           inputType: AppInputType.number),
//                                 //       style: kFormTextStyle,
//                                 //       controller: _btcController,
//                                 //       decoration: InputDecoration(
//                                 //         hintMaxLines: 1,
//                                 //         suffix: GestureDetector(
//                                 //           onTap: () {
//                                 //             copyToClipboard(
//                                 //                 copyText: _btcController.text,
//                                 //                 context: context);
//                                 //           },
//                                 //           child: Row(
//                                 //             mainAxisSize: MainAxisSize.min,
//                                 //             children: [
//                                 //               SizedBox(
//                                 //                 width: 10,
//                                 //               ),
//                                 //               Text(
//                                 //                 "copy",
//                                 //                 style: GoogleFonts.poppins(
//                                 //                   color: kPrimaryColor,
//                                 //                   fontWeight: FontWeight.w600,
//                                 //                 ),
//                                 //               ),
//                                 //               SizedBox(
//                                 //                 width: 4,
//                                 //               ),
//                                 //               Icon(
//                                 //                 FlutterRemix.file_copy_line,
//                                 //                 color: kPrimaryColor,
//                                 //               )
//                                 //             ],
//                                 //           ),
//                                 //         ),
//                                 //         fillColor: kFormBG,
//                                 //         filled: true,
//                                 //         errorBorder: OutlineInputBorder(
//                                 //           borderRadius:
//                                 //               BorderRadius.circular(8),
//                                 //           borderSide: BorderSide(
//                                 //               color: kRed,
//                                 //               width: 1,
//                                 //               style: BorderStyle.solid),
//                                 //         ),
//                                 //         focusedErrorBorder: OutlineInputBorder(
//                                 //           borderRadius:
//                                 //               BorderRadius.circular(8),
//                                 //           borderSide: BorderSide(
//                                 //               color: kRed,
//                                 //               width: 1,
//                                 //               style: BorderStyle.solid),
//                                 //         ),
//                                 //         focusedBorder: OutlineInputBorder(
//                                 //           borderRadius:
//                                 //               BorderRadius.circular(8),
//                                 //           borderSide: BorderSide.none,
//                                 //         ),
//                                 //         contentPadding: EdgeInsets.symmetric(
//                                 //             horizontal: screenSize.width <
//                                 //                     tabletBreakPoint
//                                 //                 ? 16
//                                 //                 : 24,
//                                 //             vertical: screenSize.width <
//                                 //                     tabletBreakPoint
//                                 //                 ? 16
//                                 //                 : 24),
//                                 //         border: OutlineInputBorder(
//                                 //           borderRadius:
//                                 //               BorderRadius.circular(8),
//                                 //           borderSide: BorderSide.none,
//                                 //         ),
//                                 //         hintStyle: GoogleFonts.poppins(
//                                 //           fontSize: screenSize.width <
//                                 //                   tabletBreakPoint
//                                 //               ? 16
//                                 //               : 18,
//                                 //           fontWeight: FontWeight.w600,
//                                 //           color: kInactive,
//                                 //         ),
//                                 //       ),
//                                 //     ),
//                                 //     SizedBox(
//                                 //       height:
//                                 //           screenSize.width < tabletBreakPoint
//                                 //               ? 24
//                                 //               : 30,
//                                 //     )
//                                 //   ],
//                                 // ),
//                                 GestureDetector(
//                                   onTap: () async {
//                                     FilePickerResult? result = await FilePicker
//                                         .platform
//                                         .pickFiles(type: FileType.image);
//
//                                     if (result != null) {
//                                       _paymentProofFile =
//                                           io.File(result.files.single.path!);
//                                       _paymentProof = Column(
//                                         children: [
//                                           Text(
//                                             "Tap to change Payment Proof",
//                                             style: GoogleFonts.poppins(
//                                                 fontWeight: FontWeight.w600,
//                                                 fontSize: 15,
//                                                 color: kPrimaryColor),
//                                           ),
//                                           const SizedBox(
//                                             height: 10,
//                                           ),
//                                           Image.file(
//                                             _paymentProofFile!,
//                                             fit: BoxFit.contain,
//                                           ),
//                                         ],
//                                       );
//                                     } else {
//                                       // User canceled the picker
//                                     }
//                                     setState(() {});
//                                   },
//                                   child: Container(
//                                     width: double.infinity,
//                                     padding: const EdgeInsets.symmetric(
//                                         vertical: 10, horizontal: 10),
//                                     decoration: BoxDecoration(
//                                       border: Border.all(
//                                           color: const Color(0xFFCBCFD5),
//                                           width: 1,
//                                           style: BorderStyle.solid),
//                                       borderRadius: BorderRadius.circular(10),
//                                       color: kGeneralWhite,
//                                     ),
//                                     child: _paymentProof ??
//                                         Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                               vertical: 30),
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.center,
//                                             children: [
//                                               SvgPicture.asset(
//                                                 "assets/svg/btc_proof.svg",
//                                                 height: 54,
//                                                 width: 54,
//                                               ),
//                                               const SizedBox(
//                                                 height: 10,
//                                               ),
//                                               Text(
//                                                 "Tap to upload payment proof",
//                                                 style: GoogleFonts.poppins(
//                                                     fontWeight: FontWeight.w600,
//                                                     fontSize: 15,
//                                                     color: kPrimaryColor),
//                                               )
//                                             ],
//                                           ),
//                                         ),
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   height: 20,
//                                 ),
//                                 Text(
//                                   "Please ensure that you copied the right wallet address before sending the bitcoin",
//                                   style: GoogleFonts.poppins(
//                                     fontSize: 13,
//                                     fontWeight: FontWeight.normal,
//                                     color: kTextGray,
//                                   ),
//                                   textAlign: TextAlign.center,
//                                 ),
//                                 const SizedBox(
//                                   height: 24,
//                                 ),
//                                 const SizedBox(
//                                   height: 60,
//                                 ),
//                                 PrimaryGradientButton(
//                                   title: Text(
//                                     "Confirm Payment",
//                                     style: kPrimaryButtonTextStyle,
//                                   ),
//                                   onPressed: () async {
//                                     if (_paymentProofFile != null) {
//                                       showLoadingModal(
//                                           context: context,
//                                           title: "Processing");
//                                       ProcessError _error =
//                                           await dxWorker.registerBTCTransaction(
//                                               paymentProof: _paymentProofFile!,
//                                               walletTypeID: widget.walletTypeID,
//                                               usdAmount: widget.usdAmount,
//                                               ngnAmount: (widget.usdAmount *
//                                                   Provider.of<AppData>(context,
//                                                           listen: false)
//                                                       .btcTradeData!
//                                                       .usdRate),
//                                               btcAddressID: _btcAddress!["id"],
//                                               context: context);
//                                       Navigator.pop(context);
//                                       if (!_error.any) {
//                                         Navigator.pushReplacement(
//                                             context,
//                                             CupertinoPageRoute(
//                                                 builder: (context) =>
//                                                     TradeBTCStep3(
//                                                       usdAmount:
//                                                           widget.usdAmount,
//                                                     )));
//                                       } else {
//                                         showErrorResponse(
//                                             context: context, error: _error);
//                                       }
//                                     } else {
//                                       showInfoModal(
//                                           context: context,
//                                           title: "Hey Boss!",
//                                           content:
//                                               "Please select payment proof to confirm transaction.");
//                                     }
//                                   },
//                                 ),
//                               ],
//                             )
//                           : _PageShimmer(),
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
//
//   @override
//   void dispose() {
//     _btcAddress = null;
//     _paymentProof = null;
//     _paymentProofFile = null;
//     super.dispose();
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
//           GestureDetector(
//             onTap: () {
//               showCupertinoModalBottomSheet(
//                   barrierColor: Colors.black.withOpacity(0.8),
//                   context: context,
//                   builder: (context) => BarcodePage());
//             },
//             child: Container(
//               margin: EdgeInsets.only(bottom: 40),
//               width: screenSize.width * 0.7,
//               height: screenSize.width * 0.7,
//               decoration: BoxDecoration(
//                 border: Border.all(
//                   color: kPrimaryColor,
//                   width: 2,
//                   style: BorderStyle.solid,
//                 ),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: QrImage(
//                 data:
//                     "ewrdftgvhbjnklojknbvfyrdtyfguiewrdftgvhbjnklojknbvfyrdtyfgui",
//                 version: QrVersions.auto,
//                 size: 110.0,
//               ),
//             ),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextFormField(
//                 keyboardType: getKeyboardType(inputType: AppInputType.number),
//                 style: kFormTextStyle,
//                 initialValue: "ewrdftgvhbjnklojknbvfyrdtyfgui",
//                 validator: amountValidator(),
//                 decoration: InputDecoration(
//                   hintMaxLines: 1,
//                   suffix: GestureDetector(
//                     onTap: () {},
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         SizedBox(
//                           width: 10,
//                         ),
//                         Text(
//                           "copy",
//                           style: GoogleFonts.poppins(
//                             color: kPrimaryColor,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         SizedBox(
//                           width: 4,
//                         ),
//                         Icon(
//                           FlutterRemix.file_copy_line,
//                           color: kPrimaryColor,
//                         )
//                       ],
//                     ),
//                   ),
//                   fillColor: kFormBG,
//                   filled: true,
//                   errorBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: BorderSide(
//                         color: kRed, width: 1, style: BorderStyle.solid),
//                   ),
//                   focusedErrorBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: BorderSide(
//                         color: kRed, width: 1, style: BorderStyle.solid),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: BorderSide.none,
//                   ),
//                   contentPadding: EdgeInsets.symmetric(
//                       horizontal: screenSize.width < tabletBreakPoint ? 16 : 24,
//                       vertical: screenSize.width < tabletBreakPoint ? 16 : 24),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: BorderSide.none,
//                   ),
//                   hintStyle: GoogleFonts.poppins(
//                     fontSize: screenSize.width < tabletBreakPoint ? 16 : 18,
//                     fontWeight: FontWeight.w600,
//                     color: kInactive,
//                   ),
//                 ),
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Bitcoin Amount",
//                     style: kFormTitleTextStyle,
//                   ),
//                   const SizedBox(
//                     height: 5,
//                   ),
//                   TextFormField(
//                     readOnly: true,
//                     keyboardType:
//                         getKeyboardType(inputType: AppInputType.number),
//                     style: kFormTextStyle,
//                     controller: _btcController,
//                     decoration: InputDecoration(
//                       hintMaxLines: 1,
//                       suffix: GestureDetector(
//                         onTap: () {
//                           copyToClipboard(
//                               copyText: _btcController.text, context: context);
//                         },
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Text(
//                               "copy",
//                               style: GoogleFonts.poppins(
//                                 color: kPrimaryColor,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             SizedBox(
//                               width: 4,
//                             ),
//                             Icon(
//                               FlutterRemix.file_copy_line,
//                               color: kPrimaryColor,
//                             )
//                           ],
//                         ),
//                       ),
//                       fillColor: kFormBG,
//                       filled: true,
//                       errorBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: BorderSide(
//                             color: kRed, width: 1, style: BorderStyle.solid),
//                       ),
//                       focusedErrorBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: BorderSide(
//                             color: kRed, width: 1, style: BorderStyle.solid),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: BorderSide.none,
//                       ),
//                       contentPadding: EdgeInsets.symmetric(
//                           horizontal:
//                               screenSize.width < tabletBreakPoint ? 16 : 24,
//                           vertical:
//                               screenSize.width < tabletBreakPoint ? 16 : 24),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: BorderSide.none,
//                       ),
//                       hintStyle: GoogleFonts.poppins(
//                         fontSize: screenSize.width < tabletBreakPoint ? 16 : 18,
//                         fontWeight: FontWeight.w600,
//                         color: kInactive,
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: screenSize.width < tabletBreakPoint ? 24 : 30,
//                   )
//                 ],
//               ),
//               SizedBox(
//                 height: screenSize.width < tabletBreakPoint ? 24 : 30,
//               )
//             ],
//           ),
//           Container(
//             width: double.infinity,
//             padding: EdgeInsets.symmetric(vertical: 40),
//             decoration: BoxDecoration(
//               border: Border.all(
//                   color: Color(0xFFCBCFD5), width: 1, style: BorderStyle.solid),
//               borderRadius: BorderRadius.circular(10),
//               color: kGeneralWhite,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SvgPicture.asset(
//                   "assets/svg/btc_proof.svg",
//                   height: 54,
//                   width: 54,
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   "Tap to upload payment proof",
//                   style: GoogleFonts.poppins(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 15,
//                       color: kPrimaryColor),
//                 )
//               ],
//             ),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           Text(
//             "Please ensure that you copied the right wallet address before sending the bitcoin",
//             style: GoogleFonts.poppins(
//               fontSize: 13,
//               fontWeight: FontWeight.normal,
//               color: kTextGray,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(
//             height: 24,
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
