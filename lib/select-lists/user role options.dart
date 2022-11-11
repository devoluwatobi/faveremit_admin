import 'package:faveremit_admin/models/dx-user-model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/styles.dart';
import '../main.dart';
import '../services-classes/app-worker.dart';
import '../services-classes/info-modal.dart';
import '../widgets/loading-modal.dart';
import '../widgets/review-trx-option-widget.dart';
import '../widgets/show-option-modal.dart';

class UserRoleOptionsList extends StatelessWidget {
  final FavUserModel user;
  const UserRoleOptionsList({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: kGeneralWhite,
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    FlutterRemix.close_fill,
                    color: kTextGray,
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Change User Role",
                    style: GoogleFonts.roboto(
                        fontSize: 16,
                        color: kDarkBG,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  user.role != 0
                      ? ReviewTrxOption(
                          title: "Basic User",
                          description:
                              "This is a basic user role that grants access to all Faveremit user featuers",
                          color: kPrimaryColor,
                          id: 0,
                          onPressed: () {
                            _changeUserRole(
                                context: context,
                                user: user,
                                roleID: 0,
                                roleTitle: "Basic User");
                          },
                        )
                      : const SizedBox(),
                  user.role != 1
                      ? ReviewTrxOption(
                          title: "Admin",
                          description:
                              "This is role gives this user the permission to view and review paypal transactions..",
                          color: kGreen,
                          id: 1,
                          onPressed: () async {
                            _changeUserRole(
                                context: context,
                                user: user,
                                roleID: 1,
                                roleTitle: "Admin");
                          },
                        )
                      : const SizedBox(),
                  user.role != 2
                      ? ReviewTrxOption(
                          title: "Sub Admin",
                          description:
                              "This is role gives this user view only access to crypto/giftcard Trades on Faveremit.",
                          color: kPurple,
                          id: 2,
                          onPressed: () async {
                            _changeUserRole(
                                context: context,
                                user: user,
                                roleID: 2,
                                roleTitle: "Sub Admin");
                          },
                        )
                      : const SizedBox(),
                  user.role != 3
                      ? ReviewTrxOption(
                          title: "Sub Admin Pro",
                          description:
                              "This is role gives this user view only access to withdrawals Trades and withdrawal transactions on Faveremit.",
                          color: kIndigo,
                          id: 3,
                          onPressed: () async {
                            _changeUserRole(
                                context: context,
                                user: user,
                                roleID: 3,
                                roleTitle: "Sub Admin Pro");
                          },
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 80,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

void _changeUserRole(
    {required BuildContext context,
    required FavUserModel user,
    required int roleID,
    required String roleTitle}) async {
  bool? _proceed = await showOptionPopup(
      context: context,
      title: "Please Confirm",
      body:
          "Are you sure you want to change this user's role to $roleTitle ?. ${roleID == 0 ? "this user would loose all privileges that came with his/her user role" : "This user would be able to login on the admin app and access the $roleTitle account features"}.",
      actionTitle: "Change User Role",
      isDestructive: true);
  if (_proceed != null && _proceed) {
    showLoadingModal(context: context);
    ProcessError error = await adminWorker.upgradeDowngradeUser(
        context: context, email: user.email, phone: user.phone, role: roleID);
    Navigator.pop(context);
    if (error.any) {
      Navigator.pop(context);
      showErrorResponse(context: context, error: error);
    } else {
      // Navigator.pop(context);
      Navigator.pop(context);
      showInfoModal(
          context: context,
          title: "Success",
          content: "User role has been updated successfully.");
    }
  } else {
    Navigator.pop(context);
  }
}
