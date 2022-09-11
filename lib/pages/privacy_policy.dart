import 'dart:async';
import '../widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyWebView extends StatelessWidget {

  static const String route = '/privacy_policy';

  final String title =  "privacy policy";
  final String selectedUrl =  "https://www.qualnotes.com/privacy-policy.html";

  final Completer<WebViewController> _controller = Completer<WebViewController>();

  MyWebView({Key? key}) : super(key: key);
/*  MyWebView({
    @required this.title,
    @required this.selectedUrl,

  });
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(title)
        ),
        drawer: buildDrawer(context, MyWebView.route),
        body: WebView(
          initialUrl: selectedUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
        ));
  }
}
