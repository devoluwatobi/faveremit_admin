import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/styles.dart';

class AppFAB extends StatelessWidget {
  final Function()? onTap;
  final String title;
  final Widget? leading;
  const AppFAB({
    Key? key,
    this.onTap,
    required this.title,
    required this.leading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Spacer(),
        GestureDetector(
          onTap: onTap ??
              () async {
                // await showCupertinoModalBottomSheet(
                //   context: context,
                //   expand: false,
                //   barrierColor: const Color(0xFF000000).withOpacity(0.6),
                //   builder: (context) {
                //     return EditEmailDetailsPage(
                //       paypalAddress: "my@pally.co",
                //       categoryID: 1,
                //       status: 0,
                //       id: 0,
                //       isEdit: false,
                //     );
                //   },
                // );
              },
          child: Container(
            decoration: BoxDecoration(
                gradient: appGradient,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: kGeneralWhite, width: 2),
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(0, 5),
                      blurRadius: 20,
                      color: const Color(0xFF606470).withOpacity(0.1)),
                ]),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: Row(
              children: [
                leading != null
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          leading!,
                          const SizedBox(
                            width: 6,
                          ),
                        ],
                      )
                    : const SizedBox(),
                Text(
                  title,
                  style: GoogleFonts.roboto(
                      color: kGeneralWhite,
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
