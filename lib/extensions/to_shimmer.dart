import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../config/styles.dart';

extension ToShimmer on Widget {
  Widget toShimmer({bool showShimmer = true}) {
    return showShimmer
        ? Shimmer.fromColors(
            baseColor: kTextGray.withOpacity(0.3),
            highlightColor: kTextGray.withOpacity(0.1),
            child: this,
          )
        : this;
  }
}
