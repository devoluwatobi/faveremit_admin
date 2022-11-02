import 'package:cached_network_image/cached_network_image.dart';
import 'package:faveremit_admin/models/dx-user-model.dart';
import 'package:faveremit_admin/services-classes/functions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../config/dimensions.dart';
import '../config/styles.dart';
import '../main.dart';
import '../widgets/primary-button.dart';

late String _paypalAddress;

late int _role;

class UserDetailsPage extends StatefulWidget {
  final DxUserModel user;
  const UserDetailsPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kFormBG,
        foregroundColor: kFormBG,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "cancel",
                style: GoogleFonts.poppins(color: kDarkBG),
              )
            ],
          ),
        ),
        title: Text(
          "User Details",
          style: GoogleFonts.poppins(
              color: kTextPrimary, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: kGeneralWhite,
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: kAppHorizontalPadding,
          children: [
            const SizedBox(
              height: 40,
            ),
            Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: CachedNetworkImage(
                    imageUrl:
                        adminWorker.baseUrl + widget.user.photo.toString(),
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                    placeholder: (context, url) {
                      return Container(
                        alignment: Alignment.center,
                        height: 100,
                        width: 100,
                        color: kDarkBG,
                        child: Text(
                          getInitials(widget.user.name).toUpperCase(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: kGeneralWhite),
                        ),
                      );
                    },
                    errorWidget: (
                      context,
                      url,
                      error,
                    ) {
                      return Container(
                        alignment: Alignment.center,
                        height: 100,
                        width: 100,
                        color: kDarkBG,
                        child: Text(
                          getInitials(widget.user.name).toUpperCase(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: kGeneralWhite),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: kAppHorizontalPadding,
                  child: Text(
                    "${widget.user.name}".inTitleCase,
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: kDarkBG,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              decoration: BoxDecoration(
                color: kTextPrimary.withOpacity(0.02),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: const Color(0xFFE8EBF3),
                    width: 1,
                    style: BorderStyle.solid),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "User ID",
                          style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: kTextPrimary,
                              fontWeight: FontWeight.normal),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          "${widget.user.id}",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: kTextPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                    color: Color(0xFFE8EBF3),
                    height: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Full Name",
                          style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: kTextPrimary,
                              fontWeight: FontWeight.normal),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text(
                            widget.user.name,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: kDarkBG,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                    color: Color(0xFFE8EBF3),
                    height: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Email",
                          style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: kTextPrimary,
                              fontWeight: FontWeight.normal),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text(
                            widget.user.email,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: kDarkBG,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                    color: Color(0xFFE8EBF3),
                    height: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Phone",
                          style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: kTextPrimary,
                              fontWeight: FontWeight.normal),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text(
                            widget.user.phone,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: kDarkBG,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                    color: Color(0xFFE8EBF3),
                    height: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Account Type",
                          style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: kTextPrimary,
                              fontWeight: FontWeight.normal),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text(
                            widget.user.role == 0 ? "User" : "Admin",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: kDarkBG,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                    color: Color(0xFFE8EBF3),
                    height: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Date Joined",
                          style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: kTextPrimary,
                              fontWeight: FontWeight.normal),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text(
                            "${DateFormat.jm().format(widget.user.createdAt)}, ${humanDate(widget.user.createdAt)}"
                                .inTitleCase,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: kDarkBG,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            PrimaryTextButton(
                onPressed: () async {}, title: "Change Account Type"),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 60,
            ),
          ],
        ),
      ),
    );
  }
}
