// class PersistentHeader extends SliverPersistentHeaderDelegate {
//   final Widget widget;
//   PersistentHeader({required this.widget});
//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     // TODO: implement build
//     return Container(
//       width: double.infinity,
//       height: 56,
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 20),
//         color: kBackground,
//         child: widget,
//       ),
//     );
//   }
//
//   @override
//   // TODO: implement maxExtent
//   double get maxExtent => 56;
//
//   @override
//   // TODO: implement minExtent
//   double get minExtent => 56;
//
//   @override
//   bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
//     // TODO: implement shouldRebuild
//     return true;
//     // throw UnimplementedError();
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../config/styles.dart';

class AppPersistentSlideControlDelegate extends SliverPersistentHeaderDelegate {
  final Widget widget;
  AppPersistentSlideControlDelegate({required this.widget});
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // TODO: implement build
    return Container(
      width: double.infinity,
      height: 100,
      color: kGeneralWhite,
      child: widget,
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => 100;

  @override
  // TODO: implement minExtent
  double get minExtent => 100;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    return true;
    // throw UnimplementedError();
  }
}
