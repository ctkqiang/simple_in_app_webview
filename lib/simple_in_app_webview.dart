library simple_in_app_webview;

import 'dart:io';

///
///
///
import 'package:flutter/material.dart';
import 'package:simple_in_app_webview/logic/logic.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// @author : John Melody Me <johnmelodyme@yahoo.com>
/// ignore: must_be_immutable
class SimpleWebView extends StatefulWidget {
  String? url;
  String? title;
  String? message;
  bool? isUrlCentered;
  Color? appBarColour;
  Color? shareButtonColour;
  Color? loadingIndicatorColour;

  /// [SimpleWebView]
  /// This widget diaplay an in app webview with @required
  /// parameters [url] : the url to be presented,
  /// [title] : the Title for share the [url] to 3rd parties app,
  /// [message] : the custom description of the [url] to be shared
  /// to 3rd parties app
  SimpleWebView({
    Key? key,
    @required this.url,
    @required this.title,
    @required this.message,
    this.isUrlCentered = false,
    this.appBarColour = Colors.white,
    this.shareButtonColour = Colors.black,
    this.loadingIndicatorColour = Colors.black,
  }) : super(key: key);

  @override
  State<SimpleWebView> createState() => _SimpleWebViewState();
}

class _SimpleWebViewState extends State<SimpleWebView> {
  bool? isVisible = true;
  int? progress = 1;

  @override
  void initState() {
    super.initState();

    SimpleLogic.ifMobileApp(
      doThis: () {
        if (Platform.isAndroid) WebView.platform = AndroidWebView();
      },
      otherwise: () => SimpleLogic.openUri(widget.url!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: widget.isUrlCentered!,
        title: Text(widget.url!),
        backgroundColor: widget.appBarColour!,
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: widget.shareButtonColour!),
            onPressed: () => SimpleLogic.share(
              title: widget.title!,
              message: widget.message!,
              url: widget.url!,
            ),
          ),
          PopupMenuButton(
            icon: Icon(
              Icons.more_vert_outlined,
              color: widget.shareButtonColour!,
            ),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: const Text('Open in browser'),
                  onTap: () => SimpleLogic.openUri(widget.url!),
                ),
                PopupMenuItem(
                  child: const Text('Close'),
                  onTap: () => Navigator.pop(context),
                ),
              ];
            },
          ),
        ],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: progress,
          children: [
            WebView(
              initialUrl: widget.url!,
              javascriptMode: JavascriptMode.unrestricted,
              gestureNavigationEnabled: true,
              zoomEnabled: true,
              onPageStarted: (value) => setState(() => progress = 1),
              onPageFinished: (value) => setState(() => progress = 0),
              onProgress: (value) => progress,
            ),
            Center(
              child: CircularProgressIndicator(
                color: widget.loadingIndicatorColour!,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
