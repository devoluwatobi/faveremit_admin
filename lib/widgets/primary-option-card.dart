// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:faveremit_admin/models/home-data-info.dart';
// import 'package:faveremit_admin/pages/pay-bills-page.dart';
// import 'package:faveremit_admin/pages/sell-giftcard.dart';
// import 'package:faveremit_admin/pages/trade-btc-stage-one.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_remix/flutter_remix.dart';
//
// import '../config/dimensions.dart';
// import '../config/styles.dart';
//
// class PrimaryOptionCard extends StatelessWidget {
//   final PrimaryServiceObject service;
//   const PrimaryOptionCard({
//     Key? key,
//     required this.service,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         if (service.id == 1) {
//           Navigator.push(context,
//               CupertinoPageRoute(builder: (context) => SellGiftCardPage()));
//         } else if (service.id == 2) {
//           Navigator.push(context,
//               CupertinoPageRoute(builder: (context) => TradeBTCStep1()));
//         } else {
//           Navigator.push(context,
//               CupertinoPageRoute(builder: (context) => PayBillsPage()));
//         }
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(
//               screenSize.width < tabletBreakPoint
//                   ? 20
//                   : screenSize.width * 0.04),
//           color: kFormBG,
//         ),
//         width: double.infinity,
//         padding: EdgeInsets.all(
//             screenSize.width < tabletBreakPoint ? 20 : screenSize.width * 0.04),
//         margin: EdgeInsets.symmetric(
//             vertical: screenSize.width < tabletBreakPoint
//                 ? 10
//                 : screenSize.width * 0.02),
//         child: Row(
//           children: [
//             Container(
//               height: screenSize.width < tabletBreakPoint
//                   ? 60
//                   : screenSize.width * 0.12,
//               width: screenSize.width < tabletBreakPoint
//                   ? 60
//                   : screenSize.width * 0.12,
//               child: CachedNetworkImage(
//                 imageUrl: service.icon.toString(),
//                 height: screenSize.width < tabletBreakPoint
//                     ? 60
//                     : screenSize.width * 0.12,
//                 fit: BoxFit.cover,
//                 placeholder: (context, url) {
//                   return Icon(
//                     FlutterRemix.coupon_3_fill,
//                     size: 40,
//                     color: kPrimaryColor,
//                   );
//                 },
//                 errorWidget: (
//                   context,
//                   url,
//                   error,
//                 ) {
//                   return Icon(
//                     FlutterRemix.coupon_3_fill,
//                     size: 40,
//                     color: kPrimaryColor,
//                   );
//                 },
//               ),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF5E1FD),
//                 borderRadius: BorderRadius.circular(
//                     screenSize.width < tabletBreakPoint
//                         ? 10
//                         : screenSize.width * 0.02),
//               ),
//             ),
//             SizedBox(
//               width: screenSize.width < tabletBreakPoint
//                   ? 20
//                   : screenSize.width * 0.04,
//             ),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     service.title.toString(),
//                     style: primaryOptionTextStyle,
//                   ),
//                   SizedBox(
//                     height: screenSize.width < tabletBreakPoint
//                         ? 5
//                         : screenSize.width * 0.01,
//                   ),
//                   Text(
//                     service.description.toString(),
//                     style: primaryOptionSubTextStyle,
//                     textAlign: TextAlign.left,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
