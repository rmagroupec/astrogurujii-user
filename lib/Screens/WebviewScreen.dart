
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewScreen extends StatefulWidget {
  final url;
  const WebviewScreen({Key? key, this.url}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WebviewScreenState();
  }
}

class WebviewScreenState extends State<WebviewScreen> {
   late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: blueColor,
        title: Text("ASTROGURUJII"),
      ),
     body: WebViewWidget(controller: _controller),
    );
  }
}
