
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewerTerms extends StatefulWidget {
  final appbarText;
  final webUrl;
  WebViewerTerms({this.appbarText, @required this.webUrl});

  @override
  State<WebViewerTerms> createState() => _WebViewerTermsState();
}

class _WebViewerTermsState extends State<WebViewerTerms> {
  @override
  Widget build(BuildContext context) {
     late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.webUrl));
  }
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(widget.appbarText),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
