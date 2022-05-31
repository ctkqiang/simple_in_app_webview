library simple_in_app_webview;

import 'dart:io';
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
  Color? fontColour;
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
    this.fontColour = Colors.white,
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
      otherwise: () => SimpleLogic.openUri(widget.url.toString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    WebViewController? webViewController;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close, color: widget.shareButtonColour!),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: widget.isUrlCentered!,
        title: ListTile(
          style: ListTileStyle.list,
          minLeadingWidth: 1,
          dense: true,
          iconColor: widget.fontColour,
          contentPadding: const EdgeInsets.all(1),
          leading: (() {
            if (widget.url!.contains('https://')) {
              return const Icon(Icons.lock);
            }

            return const Text('');
          }()),
          title: Flexible(
            child: Text(
              widget.url!,
              style: TextStyle(color: widget.fontColour!),
            ),
          ),
        ),
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
                  child: const Text('Refresh'),
                  onTap: () => webViewController?.reload(),
                ),
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
              onWebViewCreated: (controller) => webViewController = controller,
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
