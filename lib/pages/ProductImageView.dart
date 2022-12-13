import 'dart:math';

import 'package:faveremit_admin/config/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../services-classes/info-modal.dart';
import '../widgets/loading-modal.dart';
import '../widgets/show-option-modal.dart';
import '../widgets/show-snackbar.dart';

int _currentImage = 0;

class ProductImageView extends StatefulWidget {
  final ImageProvider? productImage;
  final String title;
  final bool isGallery;
  final List<String> gallery;
  final PageController? pageController;

  const ProductImageView({
    Key? key,
    required this.productImage,
    required this.isGallery,
    required this.gallery,
    this.pageController,
    this.title = "Transaction Images",
  }) : super(key: key);
  @override
  _ProductImageViewState createState() => _ProductImageViewState();
}

class _ProductImageViewState extends State<ProductImageView> {
  @override
  void initState() {
    // TODO: implement initState
    if (widget.isGallery && widget.pageController != null) {
      _currentImage = widget.pageController!.initialPage;
      widget.gallery.removeWhere((element) => element.trim().isEmpty);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.title,
          style: GoogleFonts.poppins(
              color: kPrimaryColor, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            FlutterRemix.arrow_left_line,
            color: kPrimaryColor,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                if (await Permission.storage.request().isGranted) {
                  showLoadingModal(context: context, title: "Saving");
                  final List<String> files = widget.gallery;
                  if (kDebugMode) {
                    print(files);
                  }
                  files.removeWhere((element) => element.trim().isEmpty);
                  for (var element in files) {
                    final file =
                        await DefaultCacheManager().getSingleFile(element);

                    ImageGallerySaver.saveImage(
                      file.readAsBytesSync(),
                      quality: 60,
                      name:
                          "Faveremit ~ ${DateTime.now()} ~ ${Random.secure()}",
                      isReturnImagePathOfIOS: true,
                    );
                  }
                  Navigator.pop(context);
                  showSnackBar(
                      context: context, content: "Images Saved", isGood: true);
                  showInfoModal(
                      context: context,
                      title: "Success",
                      content: "images saved to gallery successfully");
                } else if (await Permission
                    .storage.status.isPermanentlyDenied) {
                  showSingleOptionPopup(
                      context: context,
                      title: "Oops!",
                      body:
                          "You need to grant Faveremit access to your photo library and phone storage to be able to save this files",
                      isDestructive: false,
                      actionTitle: "Go to Settings",
                      onPressed: () async {
                        openAppSettings();
                      });
                } else {
                  showInfoModal(
                      context: context,
                      title: "Oops!",
                      content:
                          "You need to grant Faveremit access to your photo library and phone storage to be able to save this files");
                  openAppSettings();
                }
                if (kDebugMode) {
                  print(await Permission.storage.status);
                }
              },
              icon: Icon(
                FlutterRemix.download_2_fill,
                color: kPrimaryColor,
              ))
        ],
      ),
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: widget.isGallery
                ? PhotoViewGallery.builder(
                    scrollPhysics: const BouncingScrollPhysics(),
                    builder: (BuildContext context, int index) {
                      return PhotoViewGalleryPageOptions(
                        imageProvider:
                            NetworkImage(widget.gallery![index].trim()),
                        initialScale: PhotoViewComputedScale.contained * 1,
                        heroAttributes: PhotoViewHeroAttributes(
                            tag: widget.gallery![index].trim()),
                      );
                    },
                    itemCount: widget.gallery!.length,
                    loadingBuilder: (context, event) => Center(
                      child: SizedBox(
                        width: 20.0,
                        height: 20.0,
                        child: CircularProgressIndicator(
                          value: event == null
                              ? 0
                              : event.cumulativeBytesLoaded /
                                  event.expectedTotalBytes!,
                        ),
                      ),
                    ),
                    backgroundDecoration: const BoxDecoration(
                      color: Colors.white54,
                    ),
                    pageController: widget.pageController,
                    onPageChanged: (newInt) {
                      setState(() {
                        _currentImage = newInt;
                      });
                    },
                  )
                : PhotoView(
                    // imageProvider: AssetImage("assets/large-image.jpg"),
                    imageProvider: widget.productImage,
                    backgroundDecoration: const BoxDecoration(
                      color: Colors.white54,
                    ),
                  ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: kBackground,
                  borderRadius: BorderRadius.circular(5),
                ),
                height: 40,
                child: Text(
                  'Trx Image ${_currentImage + 1} of ${widget.isGallery ? widget.gallery!.length : "1"}',
                  style: TextStyle(
                      color: kTextGray,
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                )),
          ),
        ],
      ),
    );
  }
}
