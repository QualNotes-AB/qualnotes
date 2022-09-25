import 'dart:async';
import 'package:qualnotes/pages/live_location.dart';

import '../widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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

  final Uri privacy_url = Uri.parse('https://www.qualnotes.com/privacy-policy.html');

  Future<void> _launchPrivacyNoteUrl() async {
    if (!await launchUrl(privacy_url)) {
      throw 'Could not launch $privacy_url';
    }
  }

  Future<void> _showInfoDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Privacy notice & location data use notice'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('This app uses your device location data to function as intended. '),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('AGREE & START USING'),
              onPressed: () {
                Navigator.pushReplacementNamed(context, LiveLocationPage.route);

              },
            ),
            TextButton(
              child: const Text('READ POLICY'),
              onPressed: () async {
                String url = "https://www.qualnotes.com/privacy-policy.html";
                var urllaunchable = await canLaunch(url); //canLaunch is from url_launcher package
                if(urllaunchable){
                  await launch(url); //launch is from url_launcher package to launch URL
                }else{
                  print("URL can't be launched.");
                }
              },

            ),

          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () => _showInfoDialog(context));
    return Scaffold(
      appBar: AppBar(
          title: Text("PRIVACY NOTICE")
      ),
      //drawer: buildDrawer(context, MyWebView.route),
      body:
      WebView(
        initialUrl: selectedUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },),
    );

  }
}
