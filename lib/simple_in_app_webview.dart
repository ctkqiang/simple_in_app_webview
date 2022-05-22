library simple_in_app_webview;

///
///
///
import 'package:flutter/material.dart';

/// @author : John Melody Me <johnmelodyme@yahoo.com>
/// ignore: must_be_immutable
class SimpleWebView extends StatefulWidget {
  String? url;
  Color? appBarColour;

  /// [SimpleWebView]
  ///
  SimpleWebView({
    Key? key,
    @required this.url,
    this.appBarColour = Colors.white,
  }) : super(key: key);

  @override
  State<SimpleWebView> createState() => _SimpleWebViewState();
}

class _SimpleWebViewState extends State<SimpleWebView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(child: Text('')),
    );
  }
}
