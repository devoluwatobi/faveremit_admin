import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../config/styles.dart';

class WebViewPage extends StatefulWidget {
  final String title;
  final String url;

  WebViewPage({required this.title, required this.url});

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

bool isLoading = true;

class _WebViewPageState extends State<WebViewPage> {
  @override
  void initState() {
    isLoading = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQueryData = MediaQuery.of(context).copyWith(textScaleFactor: 0.9);
    return MediaQuery(
        data: mediaQueryData,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            leading: TextButton(
              child: Text(
                "Close",
                style: GoogleFonts.poppins(color: kPrimaryColor),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: kBackground,
            title: Text(
              widget.title,
              style: GoogleFonts.poppins(color: kTextPrimary),
            ),
          ),
          backgroundColor: kGeneralWhite,
          body: Stack(
            children: [
              Container(
                child: WebView(
                  initialUrl:
                      '${widget.url.contains('https://') ? widget.url : 'https://' + widget.url}',
                  javascriptMode: JavascriptMode.unrestricted,
                  onPageFinished: (finish) {
                    setState(() {
                      isLoading = false;
                    });
                  },
                ),
              ),
              isLoading
                  ? Center(
                      child: CupertinoActivityIndicator(
                        animating: true,
                        radius: 20,
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ));
  }
}
