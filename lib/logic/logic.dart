// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:url_launcher/url_launcher.dart';

class SimpleLogic {
  SimpleLogic._();

  /// [share] Share url with custom title and custom description
  /// to 3rd party application
  static Future<void> share({
    @required String? title,
    @required String? message,
    @required String? url,
  }) async {
    await FlutterShare.share(
      title: title!,
      text: message!,
      linkUrl: url!,
      chooserTitle: 'Share To Friends',
    );
  }

  /// [ifMobileApp] differentiate environemtna nad run logic
  /// based on platform
  static void ifMobileApp({
    void Function()? doThis,
    void Function()? otherwise,
  }) {
    if (!kIsWeb) {
      doThis!();
    } else {
      otherwise!();
    }
  }

  static Future<void> openUri(String? url) async {
    if (await canLaunch(url!)) {
      await launch(url);
    } else {
      Future.error('Could not launch $url');
    }
  }
}
