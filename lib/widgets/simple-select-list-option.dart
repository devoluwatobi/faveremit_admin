import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/styles.dart';

class SimpleSelectListOption extends StatelessWidget {
  final String value;
  final void Function()? onPressed;
  const SimpleSelectListOption({
    Key? key,
    required this.value,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(value),
        onTap: onPressed ??
            () {
              Navigator.pop(context, value.toLowerCase());
            });
  }
}

class ItemSelectListOption extends StatelessWidget {
  final String value;
  final String imageUrl;
  final void Function()? onPressed;
  const ItemSelectListOption({
    Key? key,
    required this.value,
    this.onPressed,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: CachedNetworkImage(
              imageUrl: imageUrl,
              width: 60,
              height: 40,
              fit: BoxFit.cover,
              errorWidget: (context, object, error) {
                return Container(
                  alignment: Alignment.center,
                  color: kPrimaryColor,
                  child: Text(
                    value,
                    style: GoogleFonts.roboto(
                        color: kGeneralWhite, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }),
        ),
        title: Text(
          value,
          style: GoogleFonts.roboto(fontWeight: FontWeight.w600),
        ),
        onTap: onPressed ??
            () {
              Navigator.pop(context, value.toLowerCase());
            });
  }
}
