import 'package:faveremit_admin/main.dart';
import 'package:faveremit_admin/services-classes/app-worker.dart';
import 'package:faveremit_admin/services-classes/info-modal.dart';
import 'package:faveremit_admin/widgets/loading-modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../config/styles.dart';
import '../models/country-model.dart';
import '../models/giftcard-country-model.dart';
import '../pages/edit-range-page.dart';
import '../services-classes/functions.dart';

class SingleGiftCardRange extends StatelessWidget {
  final GiftCardRange range;
  final String iso;
  final String cardTitle;
  final String cardCountry;
  const SingleGiftCardRange({
    Key? key,
    required this.range,
    required this.iso,
    required this.cardTitle,
    required this.cardCountry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Slidable(
        // Specify a key if the Slidable is dismissible.
        key: ValueKey(range.id),

        // The start action pane is the one at the left or the top side.
        startActionPane: ActionPane(
          // A motion is a widget used to control how the pane animates.
          motion: const ScrollMotion(),

          dragDismissible: false,

          // A pane can dismiss the Slidable.
          dismissible: DismissiblePane(onDismissed: () {}),

          // All actions are defined in the children parameter.
          children: [
            // A SlidableAction can have an icon and/or a label.
            SlidableAction(
              onPressed: (context) async {
                {
                  showLoadingModal(context: context, title: "Updating Status");
                  late ProcessError _error;
                  if (range.status == 1) {
                    _error = await adminWorker.deactivateRange(
                        id: range.id, context: context);
                  } else {
                    _error = await adminWorker.activateRange(
                        id: range.id, context: context);
                  }
                  Navigator.pop(context);
                  if (_error.any) {
                    // Navigator.pop(context);
                    showErrorResponse(context: context, error: _error);
                  } else {
                    // Navigator.pop(context);
                    showInfoModal(
                        context: context,
                        title: "Success",
                        content: "Gift card range status updated successfully");
                  }
                }
              },
              backgroundColor: range.status == 1 ? kYellow : kGreen,
              foregroundColor: Colors.white,
              icon: range.status == 1
                  ? FlutterRemix.forbid_fill
                  : FlutterRemix.checkbox_circle_fill,
              label: '${range.status == 1 ? "Dea" : "A"}ctivate',
            ),
          ],
        ),

        // The end action pane is the one at the right or the bottom side.

        // The child of the Slidable is what the user sees when the
        // component is not dragged.
        child: GestureDetector(
          onTap: () async {
            await showCupertinoModalBottomSheet(
              context: context,
              expand: false,
              barrierColor: const Color(0xFF000000).withOpacity(0.6),
              builder: (context) {
                return RangeRateDetailsPage(
                  range: range,
                  iso: iso,
                  cardCountry: cardCountry,
                  cardTitle: cardTitle,
                );
              },
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: kYellow,
                    width: 1,
                    style: range.status == 1.toString()
                        ? BorderStyle.none
                        : BorderStyle.solid),
                color: kGeneralWhite,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: Offset(0, 5),
                    spreadRadius: 0,
                    blurRadius: 20,
                  )
                ]),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: kPrimaryColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(5)),
                  child: Icon(
                    FlutterRemix.exchange_fill,
                    color: kPrimaryColor,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${range.min} - ${range.max} ${countryList.countries.country.firstWhere((element) => element.countryCode.toLowerCase() == iso.toLowerCase()).currencyCode}",
                        style: GoogleFonts.poppins(
                            color: kTextPrimary,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        "updated ${getHumanDate(range.updatedAt)}".inTitleCase,
                        style:
                            GoogleFonts.poppins(color: kTextGray, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "₦${range.ecodeRate} | ₦${range.physicalRate}",
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
//Slidable(
//   // Specify a key if the Slidable is dismissible.
//   key: const ValueKey(0),
//
//   // The start action pane is the one at the left or the top side.
//   startActionPane: ActionPane(
//     // A motion is a widget used to control how the pane animates.
//     motion: const ScrollMotion(),
//
//     // A pane can dismiss the Slidable.
//     dismissible: DismissiblePane(onDismissed: () {}),
//
//     // All actions are defined in the children parameter.
//     children: const [
//       // A SlidableAction can have an icon and/or a label.
//       SlidableAction(
//         onPressed: doNothing,
//         backgroundColor: Color(0xFFFE4A49),
//         foregroundColor: Colors.white,
//         icon: Icons.delete,
//         label: 'Delete',
//       ),
//       SlidableAction(
//         onPressed: doNothing,
//         backgroundColor: Color(0xFF21B7CA),
//         foregroundColor: Colors.white,
//         icon: Icons.share,
//         label: 'Share',
//       ),
//     ],
//   ),
//
//   // The end action pane is the one at the right or the bottom side.
//   endActionPane: const ActionPane(
//     motion: ScrollMotion(),
//     children: [
//       SlidableAction(
//         // An action can be bigger than the others.
//         flex: 2,
//         onPressed: doNothing,
//         backgroundColor: Color(0xFF7BC043),
//         foregroundColor: Colors.white,
//         icon: Icons.archive,
//         label: 'Archive',
//       ),
//       SlidableAction(
//         onPressed: doNothing,
//         backgroundColor: Color(0xFF0392CF),
//         foregroundColor: Colors.white,
//         icon: Icons.save,
//         label: 'Save',
//       ),
//     ],
//   ),
//
//   // The child of the Slidable is what the user sees when the
//   // component is not dragged.
//   child: const ListTile(title: Text('Slide me')),
// ),
